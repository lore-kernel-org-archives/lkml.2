Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267Ab0IIWtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:49:18 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57020 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933270Ab0IIWpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:45:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YEDLg9HwYgtNiGXKJIGvD9jDMma9S8C7U0dE93W9tySQ/wxC1NnkMKbqHJwA/4mPGZ
         mXUzMm89hSrpXpyPqwlMJVUM/tNBZTohLoKvedA2CBBKQ7eXkrLavphW0atKhWA76kw9
         j9COY/2lpTvq8Wvn7xWixiS15yU0UWH5yGXYQ=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 209/223]drivers/usb/storage/unusual_devs.h Update broken web addresses.
Date: Thu,  9 Sep 2010 15:45:08 -0700
Message-Id: <1284072309-8452-14-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284072309-8452-1-git-send-email-justinmattock@gmail.com>
References: <1284072309-8452-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/usb/storage/unusual_devs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 2c897ee..db641d8 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -962,7 +962,7 @@ UNUSUAL_DEV(  0x07af, 0x0006, 0x0100, 0x0100,
  * Only revision 1.13 tested (same for all of the above devices,
  * based on the Datafab DF-UG-07 chip).  Needed for US_FL_FIX_INQUIRY.
  * Submitted by Marek Michalkiewicz <marekm@amelek.gda.pl>.
- * See also http://martin.wilck.bei.t-online.de/#kecf .
+ * See also http://web.archive.org/web/20030808203106/http://martin.wilck.bei.t-online.de/.
  */
 UNUSUAL_DEV(  0x07c4, 0xa400, 0x0000, 0xffff,
 		"Datafab",
-- 
1.7.2.1

