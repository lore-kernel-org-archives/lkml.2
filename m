Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933355Ab1CZBTI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 21:19:08 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:45111 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932153Ab1CZBSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 21:18:40 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/Qf+ppcLHQb4WvNUsJ6nDPMQbRovEa1nNO52yjrh
	2kNR1KAeINhc9Q
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Harry Wei <jiaweiwei.xiyou@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 07/27] staging/easycap: Fix common spelling mistakes
Date: Sat, 26 Mar 2011 02:17:56 +0100
Message-Id: <1301102296-15565-8-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <20110314224746.GA21100@kroah.com>
References: <20110314224746.GA21100@kroah.com>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a common spelling mistake in
drivers/staging/easycap.

WRONG -> RIGHT
acknowlegements -> acknowledgements

Kernel Version: staging/staging-next 20110325 (4bbba111)

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/easycap/README        |    2 +-
 drivers/staging/easycap/easycap_low.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/easycap/README b/drivers/staging/easycap/README
index 6b5ac0d..ca53165 100644
--- a/drivers/staging/easycap/README
+++ b/drivers/staging/easycap/README
@@ -155,7 +155,7 @@ options easycap  gain=16 bars=1
 install easycap /sbin/rmmod snd-usb-audio; /sbin/modprobe --ignore-install easycap
 
 
-ACKNOWLEGEMENTS AND REFERENCES
+ACKNOWLEDGEMENTS AND REFERENCES
 ------------------------------
 This driver makes use of information contained in the Syntek Semicon DC-1125
 Driver, presently maintained at http://sourceforge.net/projects/syntekdriver/
diff --git a/drivers/staging/easycap/easycap_low.c b/drivers/staging/easycap/easycap_low.c
index 0385735..782a05e 100644
--- a/drivers/staging/easycap/easycap_low.c
+++ b/drivers/staging/easycap/easycap_low.c
@@ -27,7 +27,7 @@
 */
 /*****************************************************************************/
 /*
- *  ACKNOWLEGEMENTS AND REFERENCES
+ *  ACKNOWLEDGEMENTS AND REFERENCES
  *  ------------------------------
  *  This driver makes use of register information contained in the Syntek
  *  Semicon DC-1125 driver hosted at
-- 
1.7.3.4

