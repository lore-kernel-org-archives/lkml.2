Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238Ab0IIW07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:26:59 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45244 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107Ab0IIW05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:26:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=k/vO2Md4B0+Lqk4Fy1eZY/Xyt5MAQAIAIXGAR4OZBU3lAzokGvyi33Og3faJBSt1+6
         fE8su1TOQRXa87N6tdtGwElbuc9H8L5vhEwuziOrXqhzgNAcOP7dMlo1gfJYiAtwqpxR
         3XnRNIbpwrunIMGzmexByxEs/QMFqUE4HGuGY=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 045/223]drivers/media/video/ivtv/ivtv-cards.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:26:45 -0700
Message-Id: <1284071205-7756-15-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071205-7756-1-git-send-email-justinmattock@gmail.com>
References: <1284071205-7756-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/media/video/ivtv/ivtv-cards.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/ivtv/ivtv-cards.c b/drivers/media/video/ivtv/ivtv-cards.c
index ca1fd32..4f9dbca 100644
--- a/drivers/media/video/ivtv/ivtv-cards.c
+++ b/drivers/media/video/ivtv/ivtv-cards.c
@@ -65,7 +65,7 @@ static struct ivtv_card_tuner_i2c ivtv_i2c_tda8290 = {
 
 /********************** card configuration *******************************/
 
-/* Please add new PCI IDs to: http://pci-ids.ucw.cz/iii
+/* Please add new PCI IDs to: http://pci-ids.ucw.cz/
    This keeps the PCI ID database up to date. Note that the entries
    must be added under vendor 0x4444 (Conexant) as subsystem IDs.
    New vendor IDs should still be added to the vendor ID list. */
-- 
1.7.2.1

