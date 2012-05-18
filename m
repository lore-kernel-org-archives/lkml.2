Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031029Ab2ERNtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 09:49:52 -0400
Received: from mta115.f1.k8.com.br ([187.73.32.187]:40689 "EHLO
	mta115.f1.k8.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933714Ab2ERNtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 09:49:51 -0400
X-Greylist: delayed 1420 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 May 2012 09:49:51 EDT
Message-ID: <1337347563.2784.6.camel@Thor>
Subject: [PATCH 1/1] rc-loopback: remove duplicate line
From: Michel Machado <michel@digirati.com.br>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Date: Fri, 18 May 2012 09:26:03 -0400
Organization: Digirati Internet
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch just removes the second assignment "rc->priv = &loopdev;"
that happens a fews lines after the first one.

Signed-off-by: Michel Machado <michel@digirati.com.br>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: "David Härdeman" <david@hardeman.nu>
---

diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
index efc6a51..fae1615 100644
--- a/drivers/media/rc/rc-loopback.c
+++ b/drivers/media/rc/rc-loopback.c
@@ -221,7 +221,6 @@ static int __init loop_init(void)
 	rc->s_idle		= loop_set_idle;
 	rc->s_learning_mode	= loop_set_learning_mode;
 	rc->s_carrier_report	= loop_set_carrier_report;
-	rc->priv		= &loopdev;
 
 	loopdev.txmask		= RXMASK_REGULAR;
 	loopdev.txcarrier	= 36000;


