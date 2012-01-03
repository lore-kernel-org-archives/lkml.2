Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab2ACAZJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 19:25:09 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44159 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486Ab2ACAZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 19:25:08 -0500
From: Paulo Alcantara <pcacjr@gmail.com>
To: hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, Paulo Alcantara <pcacjr@gmail.com>
Subject: [PATCH] x86: edd: fix wrong return type for read_mbr_sig() function
Date: Mon,  2 Jan 2012 21:23:26 -0300
Message-Id: <1325550206-29606-1-git-send-email-pcacjr@gmail.com>
X-Mailer: git-send-email 1.7.7.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paulo Alcantara <pcacjr@gmail.com>
---
 arch/x86/boot/edd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/boot/edd.c b/arch/x86/boot/edd.c
index c501a5b..7209b2d 100644
--- a/arch/x86/boot/edd.c
+++ b/arch/x86/boot/edd.c
@@ -36,7 +36,7 @@ static int read_mbr(u8 devno, void *buf)
 	return -(oreg.eflags & X86_EFLAGS_CF); /* 0 or -1 */
 }
 
-static u32 read_mbr_sig(u8 devno, struct edd_info *ei, u32 *mbrsig)
+static int read_mbr_sig(u8 devno, struct edd_info *ei, u32 *mbrsig)
 {
 	int sector_size;
 	char *mbrbuf_ptr, *mbrbuf_end;
-- 
1.7.7.4

