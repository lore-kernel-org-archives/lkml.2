Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760085Ab0JIMWg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 08:22:36 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:34459 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755593Ab0JIMWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 08:22:35 -0400
Date: Sat, 9 Oct 2010 14:19:46 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] watchdog/MachZ: fix debug macro
Message-ID: <20101009141946.5fc4399f@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix debug macro line wrapping.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/watchdog/machzwd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/machzwd.c b/drivers/watchdog/machzwd.c
index edffe68..9280350 100644
--- a/drivers/watchdog/machzwd.c
+++ b/drivers/watchdog/machzwd.c
@@ -143,7 +143,7 @@ static unsigned long next_heartbeat;
 #ifndef ZF_DEBUG
 #	define dprintk(format, args...)
 #else
-#	define dprintk(format, args...) printk(KERN_DEBUG PFX
+#	define dprintk(format, args...) printk(KERN_DEBUG PFX \
 				":%s:%d: " format, __func__, __LINE__ , ## args)
 #endif
 
-- 
1.7.2.2
