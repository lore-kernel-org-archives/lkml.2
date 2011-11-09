Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935858Ab1KJDgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:36:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43586 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933916Ab1KJDf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:35:58 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:42 2011
Message-Id: <20111109213142.835985510@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:30:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Alexander Thomas <alexander.thomas@esaturnus.com>
Subject: [007/264] staging: usbip: fix up api changes that broke windows clients
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Thomas <alexander.thomas@esaturnus.com>

commit 7518b9b8fc72a6c0ba67f33bdd4689c7dd28686a upstream.

Revert changes in definitions that were submitted on May 11 2011 and
committed on June 7 2011. No reason for the change in these values was
given in the patch comment, it broke compatibility with older
versions, and was difficult to detect by the simultaneous move of the
lines of code.

Signed-off-by: Alexander Thomas <alexander.thomas@esaturnus.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/usbip/usbip_common.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/staging/usbip/usbip_common.h
+++ b/drivers/staging/usbip/usbip_common.h
@@ -126,12 +126,12 @@ extern struct device_attribute dev_attr_
  *
  */
 #define USBIP_CMD_SUBMIT	0x0001
-#define USBIP_RET_SUBMIT	0x0002
-#define USBIP_CMD_UNLINK	0x0003
+#define USBIP_CMD_UNLINK	0x0002
+#define USBIP_RET_SUBMIT	0x0003
 #define USBIP_RET_UNLINK	0x0004
 
-#define USBIP_DIR_IN	0x00
-#define USBIP_DIR_OUT	0x01
+#define USBIP_DIR_OUT	0x00
+#define USBIP_DIR_IN	0x01
 
 /**
  * struct usbip_header_basic - data pertinent to every request


