Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009Ab0IIW1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:27:41 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:48692 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756986Ab0IIW1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:27:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=XqmIPo5R7b8BkiBBbLfEgJn/04Yd4vRAoeBSbltwvEKkb+y0MXmgysSEmEDS/3zZii
         KfLdW0OH1U9LK18FPwAMidspkCSSxoo2SMNFMdeAVE0QZIi5sNpylpooy4sRlQTVIfuw
         JWOzAjQ2mzaDvsCvtSGms/EkHcAdRugr1704U=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 054/223]drivers/media/video/cx18/cx18-cards.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:27:37 -0700
Message-Id: <1284071263-7789-9-git-send-email-justinmattock@gmail.com>
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
 drivers/media/video/cx18/cx18-cards.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/cx18/cx18-cards.c b/drivers/media/video/cx18/cx18-cards.c
index 6b805af..7f65a4d 100644
--- a/drivers/media/video/cx18/cx18-cards.c
+++ b/drivers/media/video/cx18/cx18-cards.c
@@ -39,7 +39,7 @@ static struct cx18_card_tuner_i2c cx18_i2c_std = {
 	.tv    = { 0x61, 0x60, I2C_CLIENT_END },
 };
 
-/* Please add new PCI IDs to: http://pci-ids.ucw.cz/iii
+/* Please add new PCI IDs to: http://pci-ids.ucw.cz/
    This keeps the PCI ID database up to date. Note that the entries
    must be added under vendor 0x4444 (Conexant) as subsystem IDs.
    New vendor IDs should still be added to the vendor ID list. */
-- 
1.7.2.1

