Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab0C2R4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 13:56:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:57061 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755316Ab0C2Rw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 13:52:58 -0400
From: Tejun Heo <tj@kernel.org>
To: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 01/17] sound: update gfp/slab.h includes
Date: Tue, 30 Mar 2010 02:52:29 +0900
Message-Id: <1269885165-18617-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269885165-18617-1-git-send-email-tj@kernel.org>
References: <1269885165-18617-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 29 Mar 2010 17:52:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
gfp.h or slab.h is included as necessary.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Takashi Iwai <tiwai@suse.de>
---
 sound/soc/codecs/cq93vc.c        |    1 +
 sound/soc/davinci/davinci-vcif.c |    1 +
 sound/usb/caiaq/input.c          |    1 +
 sound/usb/urb.c                  |    1 +
 4 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/cq93vc.c b/sound/soc/codecs/cq93vc.c
index 5132974..8f19b93 100644
--- a/sound/soc/codecs/cq93vc.c
+++ b/sound/soc/codecs/cq93vc.c
@@ -27,6 +27,7 @@
 #include <linux/pm.h>
 #include <linux/platform_device.h>
 #include <linux/device.h>
+#include <linux/slab.h>
 #include <linux/clk.h>
 #include <linux/mfd/davinci_voicecodec.h>
 
diff --git a/sound/soc/davinci/davinci-vcif.c b/sound/soc/davinci/davinci-vcif.c
index 54b91e1..9aa980d 100644
--- a/sound/soc/davinci/davinci-vcif.c
+++ b/sound/soc/davinci/davinci-vcif.c
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <linux/io.h>
 #include <linux/mfd/davinci_voicecodec.h>
 
diff --git a/sound/usb/caiaq/input.c b/sound/usb/caiaq/input.c
index 27ed0bc..8bbfbfd 100644
--- a/sound/usb/caiaq/input.c
+++ b/sound/usb/caiaq/input.c
@@ -16,6 +16,7 @@
  *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
 */
 
+#include <linux/gfp.h>
 #include <linux/init.h>
 #include <linux/usb.h>
 #include <linux/usb/input.h>
diff --git a/sound/usb/urb.c b/sound/usb/urb.c
index e2b7c47..5570a2b 100644
--- a/sound/usb/urb.c
+++ b/sound/usb/urb.c
@@ -15,6 +15,7 @@
  *
  */
 
+#include <linux/gfp.h>
 #include <linux/init.h>
 #include <linux/usb.h>
 #include <linux/usb/audio.h>
-- 
1.6.4.2

