Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761218Ab0HFKWH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 06:22:07 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41378 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761186Ab0HFKWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 06:22:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=bx5XMDyOwareK5Zv4IcmtUSxmTJhQqfDEWk3QzZ9IXR4KGkaiSVb811Jxvr22jhObR
         e9zCPs3skj0yqRJ229IUbHts8ygN1F9w19LEQ9uq4ZanPSSTxEbtrKowv+Vrsn/VJhZB
         2Lv04EbL41WXby3w3bNitTxWLoEhLBT21qM+4=
From: Neil Munro <neilmunro@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Niadh <neilmunro@gmail.com>
Subject: [PATCH 984/984] Staging: RT2860: Fixed the error in oid.h
Date: Fri,  6 Aug 2010 11:27:51 +0100
Message-Id: <1281090471-3373-1-git-send-email-neilmunro@gmail.com>
X-Mailer: git-send-email 1.7.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Niadh <neilmunro@gmail.com>

Fixed the single spacing error in oid.h.

Signed-off-by: Neil Munro <neilmunro@gmail.com>
---
 drivers/staging/rt2860/oid.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rt2860/oid.h b/drivers/staging/rt2860/oid.h
index fd1c141..1704c27 100644
--- a/drivers/staging/rt2860/oid.h
+++ b/drivers/staging/rt2860/oid.h
@@ -701,7 +701,7 @@ struct PACKED rt_rt_802_11_acl {

 struct rt_802_11_wds {
 	unsigned long Num;
-	NDIS_802_11_MAC_ADDRESS Entry[24 /*MAX_NUM_OF_WDS_LINK */ ];
+	NDIS_802_11_MAC_ADDRESS Entry[24 /*MAX_NUM_OF_WDS_LINK */];
 	unsigned long KeyLength;
 	u8 KeyMaterial[32];
 };
--
1.7.2.1

