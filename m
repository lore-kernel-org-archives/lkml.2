Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549Ab2KACjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 22:39:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56309 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab2KACjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 22:39:09 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 2/3] staging/comedi: fix the initialize statics issue in drivers/ni_mio_cs.c
Date: Thu,  1 Nov 2012 11:39:03 +0900
Message-Id: <1351737543-7684-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351737466-7650-1-git-send-email-yamanetoshi@gmail.com>
References: <1351737466-7650-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch error.
- ERROR: do not initialise statics to 0 or NULL

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/comedi/drivers/ni_mio_cs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/ni_mio_cs.c b/drivers/staging/comedi/drivers/ni_mio_cs.c
index 69a42c5..f844684 100644
--- a/drivers/staging/comedi/drivers/ni_mio_cs.c
+++ b/drivers/staging/comedi/drivers/ni_mio_cs.c
@@ -251,7 +251,7 @@ static void mio_cs_config(struct pcmcia_device *link);
 static void cs_release(struct pcmcia_device *link);
 static void cs_detach(struct pcmcia_device *);
 
-static struct pcmcia_device *cur_dev = NULL;
+static struct pcmcia_device *cur_dev;
 
 static int cs_attach(struct pcmcia_device *link)
 {
-- 
1.7.9.5

