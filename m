Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab0KMWc3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 17:32:29 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63310 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab0KMWc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 17:32:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=d+bDnLMn7meLFkK7TgsLX2skbhJbMq/y7NMmYffUSNaBOfwC9k50t8w5194073pJsq
         C7mdc05raa4IqxpNOMGH4fXkzfWrtnDo0TUOL8GVSvI03fRJ/daGbgR7TrlsvHTDXYO4
         3WqxB9Gf1MPDommJVVSy4R6lscB7mExmq4RO0=
MIME-Version: 1.0
From: Clay Carpenter <claycarpenter@gmail.com>
Date: Sat, 13 Nov 2010 17:31:47 -0500
Message-ID: <AANLkTi=jqpmPqTr0EAhNNS0C0faFCEy2-x6J8OUnK48z@mail.gmail.com>
Subject: [PATCH] acerhdf: Add support for Aspire 1410 BIOS v1.3314
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Feuerer <peter@piie.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Clay Carpenter <claycarpenter@gmail.com>

Andrew: Peter has asked that this patch be submitted and applied to
your mm-tree.  Thanks!

Add support for Aspire 1410 BIOS v1.3314.  Fixes the following error:

acerhdf: unknown (unsupported) BIOS version Acer/Aspire 1410/v1.3314,
please report, aborting!

Signed-off-by: Clay Carpenter <claycarpenter@gmail.com>
Signed-off-by: Peter Feuerer <peter@piie.net>
---

 drivers/platform/x86/acerhdf.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index 60f9cfc..73df4c5 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -163,6 +163,7 @@ static const struct bios_settings_t bios_tbl[] = {
 	{"Acer", "Aspire 1410", "v1.3303", 0x55, 0x58, {0x9e, 0x00} },
 	{"Acer", "Aspire 1410", "v1.3308", 0x55, 0x58, {0x9e, 0x00} },
 	{"Acer", "Aspire 1410", "v1.3310", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1410", "v1.3314", 0x55, 0x58, {0x9e, 0x00} },
 	/* Acer 1810xx */
 	{"Acer", "Aspire 1810TZ", "v0.3108", 0x55, 0x58, {0x9e, 0x00} },
 	{"Acer", "Aspire 1810T",  "v0.3108", 0x55, 0x58, {0x9e, 0x00} },
