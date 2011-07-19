Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751067Ab1GSSUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 14:20:16 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:44259 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab1GSSUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 14:20:14 -0400
From: Bojan Prtvar <prtvar.b@gmail.com>
To: gregkh@suse.de, lucas.demarchi@profusion.mobi, abbotti@mev.co.uk
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Bojan Prtvar <prtvar.b@gmail.com>
Subject: [PATCH] Staging: comedi: fix initialization of static to 0 in ni_pcidio.c
Date: Tue, 19 Jul 2011 20:19:39 +0200
Message-Id: <1311099579-5582-1-git-send-email-prtvar.b@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes initialization of static to 0 or NULL error found
by checkpatch.pl tool

Signed-off-by: Bojan Prtvar <prtvar.b@gmail.com>
---
 drivers/staging/comedi/drivers/ni_pcidio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_pcidio.c b/drivers/staging/comedi/drivers/ni_pcidio.c
index 8dd3a01..045a4c0 100644
--- a/drivers/staging/comedi/drivers/ni_pcidio.c
+++ b/drivers/staging/comedi/drivers/ni_pcidio.c
@@ -688,7 +688,7 @@ static void ni_pcidio_print_status(unsigned int flags)
 static void debug_int(struct comedi_device *dev)
 {
 	int a, b;
-	static int n_int = 0;
+	static int n_int;
 	struct timeval tv;
 
 	do_gettimeofday(&tv);
-- 
1.7.1

