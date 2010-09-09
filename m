Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341Ab0IIW1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:27:55 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36527 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325Ab0IIW1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:27:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=XHbYST6+dYg4kQdVsl0rK8VEacFUU+Z2jzwCQCphHQ2zIJ6CUFIbSeG7dz28CrmiqB
         MKRfufOAwhAv+IvMyy9kqPWUQVZd551AMi6iFLUgMvlRouZprZPnx5JF92SSYGgt3SL2
         mMOb1LfX9Yv3ITS7wgnrWFjMI2BLx/c6Q+uDw=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 060/223]drivers/media/radio/Kconfig Update broken web addresses.
Date: Thu,  9 Sep 2010 15:27:43 -0700
Message-Id: <1284071263-7789-15-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071263-7789-1-git-send-email-justinmattock@gmail.com>
References: <1284071263-7789-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/media/radio/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 83567b8..c199ed9 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -24,7 +24,7 @@ config RADIO_CADET
 	  <file:Documentation/video4linux/API.html>.
 
 	  Further documentation on this driver can be found on the WWW at
-	  <http://linux.blackhawke.net/cadet/>.
+	  <http://web.archive.org/web/*/http://linux.blackhawke.net/cadet/>.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called radio-cadet.
@@ -237,7 +237,7 @@ config RADIO_SF16FMR2
 	  In order to control your radio card, you will need to use programs
 	  that are compatible with the Video For Linux API.  Information on
 	  this API and pointers to "v4l" programs may be found on the WWW at
-	  <http://roadrunner.swansea.uk.linux.org/v4l.shtml>.
+	  <http://web.archive.org/web/*/http://roadrunner.swansea.uk.linux.org/v4l.shtml>.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called radio-sf16fmr2.
-- 
1.7.2.1

