Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab0J3NSE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 09:18:04 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:25460 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab0J3NSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 09:18:02 -0400
Date: Sat, 30 Oct 2010 15:07:46 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Dan Williams <dcbw@redhat.com>
cc: libertas-dev@lists.infradead.org, linux-kernel@vger.kernel.org,
        Holger Schurig <hs4233@mail.mn-solutions.de>
Subject: [PATCH] libertas - remove duplicate header inclusions from cfg
Message-ID: <alpine.LNX.2.00.1010301501430.7979@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

drivers/net/wireless/libertas/cfg.c manages to include both 
'linux/wait.h' and 'linux/sched.h' twice. Once is enough for both headers.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 cfg.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index 5046a00..73b2bee 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -9,8 +9,6 @@
 #include <linux/sched.h>
 #include <linux/wait.h>
 #include <linux/slab.h>
-#include <linux/sched.h>
-#include <linux/wait.h>
 #include <linux/ieee80211.h>
 #include <net/cfg80211.h>
 #include <asm/unaligned.h>


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

