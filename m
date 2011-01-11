Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363Ab1AKX0B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 18:26:01 -0500
Received: from mail160.messagelabs.com ([216.82.253.99]:39906 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960Ab1AKXZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 18:25:59 -0500
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-160.messagelabs.com!1294788357!8471470!1
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.72]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 11 Jan 2011 17:19:30 -0600
Subject: [PATCH] mm/memblock: local functions should be static
Thread-Topic: [PATCH] mm/memblock: local functions should be static
Thread-Index: Acux5f/Zj8ZSI1VgRKipgT7ICZXz2Q==
Message-ID: <0D753D10438DA54287A00B027084269764CE0E545D@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p0BNQ9Gk022669

The function memblock_overlaps_region() is only used in this file and should
be marked static.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/mm/memblock.c b/mm/memblock.c
index 400dc62..69702ef 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -80,7 +80,8 @@ static long __init_memblock memblock_regions_adjacent(struct memblock_type *type
 	return memblock_addrs_adjacent(base1, size1, base2, size2);
 }
 
-long __init_memblock memblock_overlaps_region(struct memblock_type *type, phys_addr_t base, phys_addr_t size)
+static long __init_memblock memblock_overlaps_region(struct memblock_type *type,
+				phys_addr_t base, phys_addr_t size)
 {
 	unsigned long i;
 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
