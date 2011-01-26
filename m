Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab1AZLsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 06:48:43 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54458 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab1AZLsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 06:48:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=sKEr0kjSY4Zo02oNodVZHzVTirApvY0vfEQfZ0gu2b/vDOUb8A7kOMJLqAZhT+QeGU
         J3YVBW2asORRkBbxmmCIsdUnZxzXAxGt50c4UBYJRY541h2IHVF5Oed0e/VY1Pr5L3/6
         JwWPt4kG7+v9OqIL9T3LxdwyhLjJuqUt0c++g=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 1/5] staging: ft1000: Remove unused variables.
Date: Wed, 26 Jan 2011 12:49:11 +0100
Message-Id: <1296042555-29145-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove variables which was defined and assigned
but never used in function.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index 05f3e22..9e9709a 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -492,9 +492,7 @@ static u32 write_blk (struct ft1000_device *ft1000dev, u16 **pUsFile, u8 **pUcFi
 {
    u32 Status = STATUS_SUCCESS;
    u16 dpram;
-   long temp_word_length;
    int loopcnt, i, j;
-   u16 *pTempFile;
    u16 tempword;
    u16 tempbuffer[64];
    u16 resultbuffer[64];
@@ -513,8 +511,6 @@ static u32 write_blk (struct ft1000_device *ft1000dev, u16 **pUsFile, u8 **pUcFi
    word_length--;
    tempword = (u16)word_length;
    word_length = (word_length / 16) + 1;
-   pTempFile = *pUsFile;
-   temp_word_length = word_length;
    for (; word_length > 0; word_length--) /* In words */
    {
 	   loopcnt = 0;
-- 
1.7.1

