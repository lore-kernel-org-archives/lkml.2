Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab2KZFya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 00:54:30 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:36319 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab2KZFy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 00:54:28 -0500
From: Matt Phillips <mathewrphillips@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Matt Phillips <mathewrphillips@gmail.com>
Subject: [PATCH] staging: comedi: ni_tio.h fixed coding style issue with pointer variables
Date: Sun, 25 Nov 2012 23:53:21 -0600
Message-Id: <1353909201-29667-1-git-send-email-mathewrphillips@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issues with pointers

Signed-off-by: Matt Phillips <mathewrphillips@gmail.com>
---
 drivers/staging/comedi/drivers/ni_tio.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_tio.h b/drivers/staging/comedi/drivers/ni_tio.h
index b058820..8572996 100644
--- a/drivers/staging/comedi/drivers/ni_tio.h
+++ b/drivers/staging/comedi/drivers/ni_tio.h
@@ -120,9 +120,9 @@ struct ni_gpct {
 
 struct ni_gpct_device {
 	struct comedi_device *dev;
-	void (*write_register) (struct ni_gpct * counter, unsigned bits,
+	void (*write_register) (struct ni_gpct *counter, unsigned bits,
 				enum ni_gpct_register reg);
-	unsigned (*read_register) (struct ni_gpct * counter,
+	unsigned (*read_register) (struct ni_gpct *counter,
 				   enum ni_gpct_register reg);
 	enum ni_gpct_variant variant;
 	struct ni_gpct *counters;
-- 
1.7.10.4

