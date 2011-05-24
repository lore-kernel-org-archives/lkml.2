Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830Ab1EXXtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 19:49:49 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:44308 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753659Ab1EXXts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 19:49:48 -0400
Date: Wed, 25 May 2011 01:47:09 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] i7core_edac: use bitwise operator instead of logical one
Message-ID: <20110525014709.71cf74ee@absol.kitzblitz>
Organization: -
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwAQMAAABtzGvEAAAAAXNSR0IArs4c6QAAAAZQTFRF
 AJnV/f/88sgWwwAAAKNJREFUGNM10LENwyAQheFHKCgZgTVSRHI2gy5reROTDSiREvnyHhdXnwXS+
 T+ACJgBYTiGSmDDOTdR7XDeTi9ksxEcoKFcTOCJLO7kC5SWFjPZCR69nI9+x5u6OJM1RN5UYUiNKa
 ZRpHHUoqh1v8hKEZ1FSGCrYOvgVmxd9DIXcSJwLTycm7bj0e4wkJGB48w/FckAwUKl/OGDZAcqItk
 BU+wHXLqKsjYyPeMAAAAASUVORK5CYII=
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like a typo?

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/edac/i7core_edac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 465cbc2..ab5080e 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -1670,7 +1670,7 @@ static void i7core_mce_output_error(struct mem_ctl_info *mci,
 	char *type, *optype, *err, *msg;
 	unsigned long error = m->status & 0x1ff0000l;
 	u32 optypenum = (m->status >> 4) & 0x07;
-	u32 core_err_cnt = (m->status >> 38) && 0x7fff;
+	u32 core_err_cnt = (m->status >> 38) & 0x7fff;
 	u32 dimm = (m->misc >> 16) & 0x3;
 	u32 channel = (m->misc >> 18) & 0x3;
 	u32 syndrome = m->misc >> 32;
-- 
1.7.5.rc3
