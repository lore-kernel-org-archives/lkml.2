Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab1AJWH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 17:07:27 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:38570 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754325Ab1AJWH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 17:07:26 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+8Lx0Sq2q8L51TrJZ79XxlHca/A/D8Lj1Q1L5mkL
	OhZQ8+I0w+3Chb
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Arun Thomas <arun.thomas@gmail.com>, Kulikov Vasiliy <segooon@gmail.com>,
        Javier Martinez Canillas <martinez.javier@gmail.com>,
        Gustavo Silva <silvagustavo@users.sourceforge.net>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] staging/comedi/me4000: fix sparse warning "obsolete struct initializer"
Date: Mon, 10 Jan 2011 23:07:16 +0100
Message-Id: <1294697236-12016-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.2.2
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the sparse warnings in me4000.c:
me4000.c:122:1: warning: obsolete struct initializer, use C99 syntax
me4000.c:123:1: warning: obsolete struct initializer, use C99 syntax
me4000.c:124:1: warning: obsolete struct initializer, use C99 syntax
me4000.c:125:1: warning: obsolete struct initializer, use C99 syntax
by converting the struct to use C99 syntax

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/comedi/drivers/me4000.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/me4000.c b/drivers/staging/comedi/drivers/me4000.c
index e6825c2..75511ba 100644
--- a/drivers/staging/comedi/drivers/me4000.c
+++ b/drivers/staging/comedi/drivers/me4000.c
@@ -119,10 +119,10 @@ static int me4000_attach(struct comedi_device *dev,
 			 struct comedi_devconfig *it);
 static int me4000_detach(struct comedi_device *dev);
 static struct comedi_driver driver_me4000 = {
-driver_name: "me4000",
-module : THIS_MODULE,
-attach : me4000_attach,
-detach : me4000_detach,
+	.driver_name = "me4000",
+	.module = THIS_MODULE,
+	.attach = me4000_attach,
+	.detach = me4000_detach,
 };
 
 /*-----------------------------------------------------------------------------
-- 
1.7.2.2

