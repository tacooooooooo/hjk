<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Image to Base64 Converter</title>
<style>
    body {
        font-family: Arial, sans-serif;
        margin: 20px;
    }
    #imageInput {
        display: none;
    }
    #linkInput, #nameInput {
        width: 100%;
        margin-top: 10px;
        padding: 10px;
        box-sizing: border-box;
    }
</style>
</head>
<body>
    <h1>Image to Base64 Converter</h1>

    <input type="file" id="imageInput" accept="image/*">
    <button onclick="selectImage()">Select Image</button>
    <input type="text" id="nameInput" placeholder="Enter Image Name">
    <input type="text" id="linkInput" placeholder="Enter Link">
    <button onclick="uploadBase64Data()">Upload Base64 Data</button>

    <div id="imageContainer" style="margin-top: 20px;">
        <h2>Rendered Image</h2>
        <img id="renderedImage" style="max-width: 100%;" alt="Rendered Image">
    </div>

    <script>
        function selectImage() {
            document.getElementById('imageInput').click();
        }

        document.getElementById('imageInput').addEventListener('change', function() {
            var file = this.files[0];
            if (file) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    var base64String = e.target.result;
                    renderImage(base64String); // Render the image from Base64 string
                };
                reader.readAsDataURL(file);
            }
        });

        function renderImage(base64String) {
            var image = document.getElementById('renderedImage');
            image.src = base64String;
        }

        function uploadBase64Data() {
            var linkInput = document.getElementById('linkInput').value;
            var nameInput = document.getElementById('nameInput').value;
            var base64String = document.getElementById('renderedImage').src;

            var url = new URL(linkInput);
            var id = url.pathname.split('/')[1];
            var key = url.searchParams.get('k');

            var csvData = `name,base64\n${nameInput},${base64String}`;

            var xhr = new XMLHttpRequest();
            xhr.open('POST', 'https://html.cafe/_save/', true);
            xhr.setRequestHeader('Content-Type', 'application/json');
            var data = JSON.stringify({ id: id, key: key, data: csvData });
            xhr.send(data);
        }

        function fetchAndRenderImage() {
            var urlParams = new URLSearchParams(window.location.search);
            var imgName = urlParams.get('img');
            var id = urlParams.get('id');
            if (imgName && id) {
                var xhr = new XMLHttpRequest();
                xhr.open('GET', `https://html.cafe/_load/?id=${id}`, true);
                xhr.onload = function() {
                    if (xhr.status === 200) {
                        var lines = xhr.responseText.split('\n');
                        for (var i = 1; i < lines.length; i++) {
                            var cells = lines[i].split(',');
                            if (cells[0] === imgName) {
                                renderImage(cells[1]);
                                break;
                            }
                        }
                    }
                };
                xhr.send();
            }
        }

        window.onload = fetchAndRenderImage;
    </script>
</body>
</html>
