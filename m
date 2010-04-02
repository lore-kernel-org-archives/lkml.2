Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab0DBBO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 21:14:29 -0400
Received: from p01c12o147.mxlogic.net ([208.65.145.70]:51096 "EHLO
	p01c12o147.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab0DBBO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 21:14:26 -0400
X-MXL-Hash: 4bb544f20a75871d-645eac95c32af5805c1fca9ccf5f5bf7564ee09a
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: linux kernel <linux-kernel@vger.kernel.org>
Date: Thu, 1 Apr 2010 20:13:27 -0500
Subject: [PATCH] printk.c: remove duplicate const
Thread-Topic: [PATCH] printk.c: remove duplicate const
Thread-Index: AcrSAbLMcjPHTyK7TBaBzxGgv6T/Og==
Message-ID: <0D753D10438DA54287A00B0270842697636A7E956D@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010040101)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [(unknown)]
X-AnalysisOut: [v=1.0 c=1 a=Klh1gqnEtN0A:10 a=VphdPIyG4kEA:10 a=IkcTkHD0fZ]
X-AnalysisOut: [MA:10 a=zbe46bahRtDx8aUBN1lPzQ==:17 a=i00gxMtYAAAA:8 a=2Zc]
X-AnalysisOut: [NpXYnvsNK2rkpGDgA:9 a=2G50DejR2eyTPpaEtKUlaHVA5FUA:4 a=QEX]
X-AnalysisOut: [dDO2ut3YA:10 a=x1WnkoZAwusA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o321EdmE026634

Noticed during a sparse build.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/kernel/printk.c b/kernel/printk.c
index 75077ad..9abc79c 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1457,7 +1457,7 @@ int kmsg_dump_unregister(struct kmsg_dumper *dumper)
 }
 EXPORT_SYMBOL_GPL(kmsg_dump_unregister);
 
-static const char const *kmsg_reasons[] = {
+static const char *kmsg_reasons[] = {
 	[KMSG_DUMP_OOPS]	= "oops",
 	[KMSG_DUMP_PANIC]	= "panic",
 	[KMSG_DUMP_KEXEC]	= "kexec",
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
