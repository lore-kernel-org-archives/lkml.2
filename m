Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932628Ab0IIWcL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:32:11 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:36303 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756911Ab0IIW3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:29:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=V5sucpiUK9KHjhOaLyZEJ/YkHwu7WAsZdyNOe1TM4KVCTOHTWLEydJ84lJo9GMJEOG
         TBcccv58wNa1U7KmDY5LXcoowgxn03Edb2WcvmxDzu2pEI81Md4M3DKvM6VGl9573euX
         yQaeR6ws5CenrbgKLWUiclheg2cXAAE1F0iwc=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 081/223]drivers/mtd/chips/cfi_cmdset_0002.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:29:25 -0700
Message-Id: <1284071374-7867-6-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071374-7867-1-git-send-email-justinmattock@gmail.com>
References: <1284071374-7867-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/mtd/chips/cfi_cmdset_0002.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
index 3e6c47b..17f5305 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -418,8 +418,7 @@ struct mtd_info *cfi_cmdset_0002(struct map_info *map, int primary)
 
 			/*
 			 * Valid primary extension versions are: 1.0, 1.1, 1.2, 1.3, 1.4
-			 * see: http://www.amd.com/us-en/assets/content_type/DownloadableAssets/cfi_r20.pdf, page 19
-			 *      http://www.amd.com/us-en/assets/content_type/DownloadableAssets/cfi_100_20011201.pdf
+			 * see: http://www.amd.com/
 			 *      http://www.spansion.com/Support/Datasheets/s29ws-p_00_a12_e.pdf
 			 */
 			if (extp->MajorVersion != '1' ||
-- 
1.7.2.1

