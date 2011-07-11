Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079Ab1GKQVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 12:21:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758052Ab1GKQVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 12:21:53 -0400
Date: Mon, 11 Jul 2011 12:21:45 -0400
From: Dave Jones <davej@redhat.com>
To: lirc@bartelmus.de
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, greg@kroah.com
Subject: staging/lirc_parallel: remove pointless prototypes.
Message-ID: <20110711162145.GA26241@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, lirc@bartelmus.de,
	Linux Kernel <linux-kernel@vger.kernel.org>, greg@kroah.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are right before the actual definitions, so redundant.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/staging/lirc/lirc_parallel.c b/drivers/staging/lirc/lirc_parallel.c
index 50724c4..3a9337a 100644
--- a/drivers/staging/lirc/lirc_parallel.c
+++ b/drivers/staging/lirc/lirc_parallel.c
@@ -615,9 +615,6 @@ static struct platform_driver lirc_parallel_driver = {
 	},
 };
 
-static int pf(void *handle);
-static void kf(void *handle);
-
 static int pf(void *handle)
 {
 	parport_disable_irq(pport);
