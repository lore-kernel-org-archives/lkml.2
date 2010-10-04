Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab0JDOgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 10:36:53 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:60019 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752532Ab0JDOgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 10:36:52 -0400
Date: Mon, 4 Oct 2010 16:35:39 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Sjur Braendeland <sjur.brandeland@stericsson.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] caif: remove duplicated include
Message-ID: <20101004163539.5e879211@absol.kitzblitz>
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

Remove duplicated include.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 net/caif/caif_socket.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
index 8ce9047..7a09fb6 100644
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -15,7 +15,6 @@
 #include <linux/poll.h>
 #include <linux/tcp.h>
 #include <linux/uaccess.h>
-#include <linux/mutex.h>
 #include <linux/debugfs.h>
 #include <linux/caif/caif_socket.h>
 #include <asm/atomic.h>
-- 
1.7.2.2
