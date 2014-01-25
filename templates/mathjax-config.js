/* Fix org-generated pictures to MathJX. Big thanks to Davide Cervone
  on StackOverflow with this. http://stackoverflow.com/a/14631703/308668
  */
MathJax.Extension.myImg2jax = {
    version: "1.0",
    PreProcess: function (element) {
        var images = element.getElementsByTagName("img");
        for (var i = images.length - 1; i >= 0; i--) {
            var img = images[i];
            if (img.className === "dvipng") {
                var script = document.createElement("script");
                script.type = "math/tex";
                var match = img.alt.match(/^(\$\$?)(.*)\1/);
                if (match[1] === "$$") {script.type += ";mode=display"}
                MathJax.HTML.setScript(script,match[2]);
                img.parentNode.replaceChild(script,img);
            }
        }
    }
};
MathJax.Hub.Register.PreProcessor(["PreProcess",MathJax.Extension.myImg2jax]);
