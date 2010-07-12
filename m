Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab0GLCrE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 22:47:04 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60672 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490Ab0GLCrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 22:47:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=pOcTC80b2mHtg/4YKxAliqYWUzXX81Dw19sNOwyeopTEirpjEG1ST7kxdEicNdV/cw
         qeaJfm6jNl/pAqHXkAOrEeKNGzkVOPL2GloSkskK0uDOFQ6LS6CGE3LbWkPJIzPJsp1D
         GSSGHmz8LWgWaaXDdP2arc3m3GJPM1w1WK16I=
Message-ID: <4C3A8220.6040707@gmail.com>
Date: Sun, 11 Jul 2010 21:46:56 -0500
From: Neal B <nealb001@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Artem.Bityutskiy@nokia.com
CC: dwmw2@infradead.org, rmk+kernel@arm.linux.org.uk, cascardo@holoscopio.com,
        mohanlaljangir@gmail.com, maximlevitsky@gmail.com,
        Julia Lawall <julia@diku.dk>, jkosina@suse.cz,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] Mtd: fixed coding style indent errors
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From f4301b9c13f65d173d67759d53acaf3e8d2331c6 Mon Sep 17 00:00:00 2001
From: Neal Buckendahl <nealb001@gmail.com>
Date: Sun, 11 Jul 2010 16:58:24 -0500
Subject: [PATCH 1/6] Mtd: fixed coding style indent errors found by the 
checkpatch.pl tool
  Signed-off-by: Neal Buckendahl <nealb001@gmail.com>

---
  drivers/mtd/afs.c |    4 ++--
  1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/afs.c b/drivers/mtd/afs.c
index cec7ab9..2bea681 100644
--- a/drivers/mtd/afs.c
+++ b/drivers/mtd/afs.c
@@ -162,8 +162,8 @@ afs_read_iis(struct mtd_info *mtd, struct 
image_info_struct *iis, u_int ptr)
  }

  static int parse_afs_partitions(struct mtd_info *mtd,
-                         struct mtd_partition **pparts,
-                         unsigned long origin)
+			struct mtd_partition **pparts,
+			unsigned long origin)
  {
  	struct mtd_partition *parts;
  	u_int mask, off, idx, sz;
-- 
1.7.1


