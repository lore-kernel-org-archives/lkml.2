Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab0HCDhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 23:37:54 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59551 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab0HCDhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 23:37:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=DOxfm1TqMB+e0EtljW7VL+fsfKjbMmXYFqV75zUeXLs/nU0LlmBf74DUBDL/aEM0n5
         2uuXnHSdQuFLGqhXwgdgBXsxbVHo3LzDywXfEZWP3e07dRYBuU21bvVtWKG61PJlcGxK
         kpEueBFDtv+yifAOU2UnUThYdpbg2+YRR/amc=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]drivers/usb/host/ehci-sched.c Fix typo
Date: Mon,  2 Aug 2010 20:37:50 -0700
Message-Id: <1280806670-21009-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch fixes a typo in a comment.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/usb/host/ehci-sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/ehci-sched.c b/drivers/usb/host/ehci-sched.c
index 805ec63..3c170a9 100644
--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -1662,7 +1662,7 @@ itd_link_urb (
 
 #define	ISO_ERRS (EHCI_ISOC_BUF_ERR | EHCI_ISOC_BABBLE | EHCI_ISOC_XACTERR)
 
-/* Process and recycle a completed ITD.  Return true iff its urb completed,
+/* Process and recycle a completed ITD.  Return true if its urb completed,
  * and hence its completion callback probably added things to the hardware
  * schedule.
  *
-- 
1.7.1.rc1.21.gf3bd6

