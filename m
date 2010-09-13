Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854Ab0IMUQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 16:16:37 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51615 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666Ab0IMUQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 16:16:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VyoaPmUdtAb9kF6d/Pf/Rf6q3hwjeNUlfXA5GXdyBKIwuMGPy0MJAKXbhh34bApl8L
         Vg14CQ5Dkk/8UONbP7VkVrogaps/iCznXnO56MOz+EL0Tbr6tUj/m5j6uVU7mrtTZHyW
         eJU30AagALcgTKf8TfLvwHQGyYcDaKOR7ttxc=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        clemens@ladisch.de, "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 2/3 v2]sound/pci/ens1370.c Update broken web addresses.
Date: Mon, 13 Sep 2010 13:17:02 -0700
Message-Id: <1284409023-4419-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284409023-4419-1-git-send-email-justinmattock@gmail.com>
References: <1284409023-4419-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a resend from the original, due to Clemens Ladisch providing
the right locations of the *.pdf's etc..

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
---
 sound/pci/ens1370.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/pci/ens1370.c b/sound/pci/ens1370.c
index c7fba53..deffcc8 100644
--- a/sound/pci/ens1370.c
+++ b/sound/pci/ens1370.c
@@ -22,7 +22,7 @@
 /* Power-Management-Code ( CONFIG_PM )
  * for ens1371 only ( FIXME )
  * derived from cs4281.c, atiixp.c and via82xx.c
- * using http://www.alsa-project.org/~iwai/writing-an-alsa-driver/c1540.htm
+ * using http://www.kernel.org/pub/linux/kernel/people/tiwai/docs/writing-an-alsa-driver/index.html 
  * by Kurt J. Bosch
  */
 
-- 
1.7.2.1

