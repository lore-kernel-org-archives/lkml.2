Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760555Ab1CEBAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:00:50 -0500
Received: from kroah.org ([198.145.64.141]:50397 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760507Ab1CEBAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:41 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:39 2011
Message-Id: <20110305005639.587543798@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:55:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [51/73] ASoC: correct pxa AC97 DAI names
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

commit 4bfc4e2508234f9149fd33fae853e99fb9e4a75b upstream.

Correct names for pxa AC97 DAI are pxa2xx-ac97 and pxa2xx-ac97-aux. Fix
that for all PXA platforms.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/pxa/e740_wm9705.c    |    4 ++--
 sound/soc/pxa/e750_wm9705.c    |    4 ++--
 sound/soc/pxa/e800_wm9712.c    |    4 ++--
 sound/soc/pxa/em-x270.c        |    4 ++--
 sound/soc/pxa/mioa701_wm9713.c |    4 ++--
 sound/soc/pxa/palm27x.c        |    4 ++--
 sound/soc/pxa/tosa.c           |    4 ++--
 sound/soc/pxa/zylonite.c       |    4 ++--
 8 files changed, 16 insertions(+), 16 deletions(-)

--- a/sound/soc/pxa/e740_wm9705.c
+++ b/sound/soc/pxa/e740_wm9705.c
@@ -117,7 +117,7 @@ static struct snd_soc_dai_link e740_dai[
 	{
 		.name = "AC97",
 		.stream_name = "AC97 HiFi",
-		.cpu_dai_name = "pxa-ac97.0",
+		.cpu_dai_name = "pxa2xx-ac97",
 		.codec_dai_name = "wm9705-hifi",
 		.platform_name = "pxa-pcm-audio",
 		.codec_name = "wm9705-codec",
@@ -126,7 +126,7 @@ static struct snd_soc_dai_link e740_dai[
 	{
 		.name = "AC97 Aux",
 		.stream_name = "AC97 Aux",
-		.cpu_dai_name = "pxa-ac97.1",
+		.cpu_dai_name = "pxa2xx-ac97-aux",
 		.codec_dai_name = "wm9705-aux",
 		.platform_name = "pxa-pcm-audio",
 		.codec_name = "wm9705-codec",
--- a/sound/soc/pxa/e750_wm9705.c
+++ b/sound/soc/pxa/e750_wm9705.c
@@ -99,7 +99,7 @@ static struct snd_soc_dai_link e750_dai[
 	{
 		.name = "AC97",
 		.stream_name = "AC97 HiFi",
-		.cpu_dai_name = "pxa-ac97.0",
+		.cpu_dai_name = "pxa2xx-ac97",
 		.codec_dai_name = "wm9705-hifi",
 		.platform_name = "pxa-pcm-audio",
 		.codec_name = "wm9705-codec",
@@ -109,7 +109,7 @@ static struct snd_soc_dai_link e750_dai[
 	{
 		.name = "AC97 Aux",
 		.stream_name = "AC97 Aux",
-		.cpu_dai_name = "pxa-ac97.1",
+		.cpu_dai_name = "pxa2xx-ac97-aux",
 		.codec_dai_name ="wm9705-aux",
 		.platform_name = "pxa-pcm-audio",
 		.codec_name = "wm9705-codec",
--- a/sound/soc/pxa/e800_wm9712.c
+++ b/sound/soc/pxa/e800_wm9712.c
@@ -89,7 +89,7 @@ static struct snd_soc_dai_link e800_dai[
 	{
 		.name = "AC97",
 		.stream_name = "AC97 HiFi",
-		.cpu_dai_name = "pxa-ac97.0",
+		.cpu_dai_name = "pxa2xx-ac97",
 		.codec_dai_name = "wm9712-hifi",
 		.platform_name = "pxa-pcm-audio",
 		.codec_name = "wm9712-codec",
@@ -98,7 +98,7 @@ static struct snd_soc_dai_link e800_dai[
 	{
 		.name = "AC97 Aux",
 		.stream_name = "AC97 Aux",
-		.cpu_dai_name = "pxa-ac97.1",
+		.cpu_dai_name = "pxa2xx-ac97-aux",
 		.codec_dai_name ="wm9712-aux",
 		.platform_name = "pxa-pcm-audio",
 		.codec_name = "wm9712-codec",
--- a/sound/soc/pxa/em-x270.c
+++ b/sound/soc/pxa/em-x270.c
@@ -38,7 +38,7 @@ static struct snd_soc_dai_link em_x270_d
 	{
 		.name = "AC97",
 		.stream_name = "AC97 HiFi",
-		.cpu_dai_name = "pxa-ac97.0",
+		.cpu_dai_name = "pxa2xx-ac97",
 		.codec_dai_name = "wm9712-hifi",
 		.platform_name = "pxa-pcm-audio",
 		.codec_name = "wm9712-codec",
@@ -46,7 +46,7 @@ static struct snd_soc_dai_link em_x270_d
 	{
 		.name = "AC97 Aux",
 		.stream_name = "AC97 Aux",
-		.cpu_dai_name = "pxa-ac97.1",
+		.cpu_dai_name = "pxa2xx-ac97-aux",
 		.codec_dai_name ="wm9712-aux",
 		.platform_name = "pxa-pcm-audio",
 		.codec_name = "wm9712-codec",
--- a/sound/soc/pxa/mioa701_wm9713.c
+++ b/sound/soc/pxa/mioa701_wm9713.c
@@ -162,7 +162,7 @@ static struct snd_soc_dai_link mioa701_d
 	{
 		.name = "AC97",
 		.stream_name = "AC97 HiFi",
-		.cpu_dai_name = "pxa-ac97.0",
+		.cpu_dai_name = "pxa2xx-ac97",
 		.codec_dai_name = "wm9713-hifi",
 		.codec_name = "wm9713-codec",
 		.init = mioa701_wm9713_init,
@@ -172,7 +172,7 @@ static struct snd_soc_dai_link mioa701_d
 	{
 		.name = "AC97 Aux",
 		.stream_name = "AC97 Aux",
-		.cpu_dai_name = "pxa-ac97.1",
+		.cpu_dai_name = "pxa2xx-ac97-aux",
 		.codec_dai_name ="wm9713-aux",
 		.codec_name = "wm9713-codec",
 		.platform_name = "pxa-pcm-audio",
--- a/sound/soc/pxa/palm27x.c
+++ b/sound/soc/pxa/palm27x.c
@@ -132,7 +132,7 @@ static struct snd_soc_dai_link palm27x_d
 {
 	.name = "AC97 HiFi",
 	.stream_name = "AC97 HiFi",
-	.cpu_dai_name = "pxa-ac97.0",
+	.cpu_dai_name = "pxa2xx-ac97",
 	.codec_dai_name =  "wm9712-hifi",
 	.codec_name = "wm9712-codec",
 	.platform_name = "pxa-pcm-audio",
@@ -141,7 +141,7 @@ static struct snd_soc_dai_link palm27x_d
 {
 	.name = "AC97 Aux",
 	.stream_name = "AC97 Aux",
-	.cpu_dai_name = "pxa-ac97.1",
+	.cpu_dai_name = "pxa2xx-ac97-aux",
 	.codec_dai_name = "wm9712-aux",
 	.codec_name = "wm9712-codec",
 	.platform_name = "pxa-pcm-audio",
--- a/sound/soc/pxa/tosa.c
+++ b/sound/soc/pxa/tosa.c
@@ -217,7 +217,7 @@ static struct snd_soc_dai_link tosa_dai[
 {
 	.name = "AC97",
 	.stream_name = "AC97 HiFi",
-	.cpu_dai_name = "pxa-ac97.0",
+	.cpu_dai_name = "pxa2xx-ac97",
 	.codec_dai_name = "wm9712-hifi",
 	.platform_name = "pxa-pcm-audio",
 	.codec_name = "wm9712-codec",
@@ -227,7 +227,7 @@ static struct snd_soc_dai_link tosa_dai[
 {
 	.name = "AC97 Aux",
 	.stream_name = "AC97 Aux",
-	.cpu_dai_name = "pxa-ac97.1",
+	.cpu_dai_name = "pxa2xx-ac97-aux",
 	.codec_dai_name = "wm9712-aux",
 	.platform_name = "pxa-pcm-audio",
 	.codec_name = "wm9712-codec",
--- a/sound/soc/pxa/zylonite.c
+++ b/sound/soc/pxa/zylonite.c
@@ -166,7 +166,7 @@ static struct snd_soc_dai_link zylonite_
 	.stream_name = "AC97 HiFi",
 	.codec_name = "wm9713-codec",
 	.platform_name = "pxa-pcm-audio",
-	.cpu_dai_name = "pxa-ac97.0",
+	.cpu_dai_name = "pxa2xx-ac97",
 	.codec_name = "wm9713-hifi",
 	.init = zylonite_wm9713_init,
 },
@@ -175,7 +175,7 @@ static struct snd_soc_dai_link zylonite_
 	.stream_name = "AC97 Aux",
 	.codec_name = "wm9713-codec",
 	.platform_name = "pxa-pcm-audio",
-	.cpu_dai_name = "pxa-ac97.1",
+	.cpu_dai_name = "pxa2xx-ac97-aux",
 	.codec_name = "wm9713-aux",
 },
 {


