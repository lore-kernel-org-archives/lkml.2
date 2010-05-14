Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593Ab0ENL06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 07:26:58 -0400
Received: from mail.gmx.net ([213.165.64.20]:32976 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756003Ab0ENL0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 07:26:55 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+S59AVQFuSK640sL/xQqIuyqz+E7pbh94uukr0Hj
	NM4CwgyXY/QPGC
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: linux-next@vger.kernel.org
Subject: Re: [PATCH] media/IR: Add missing include file to rc-map.c
Date: Fri, 14 May 2010 13:26:51 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.33.2; KDE/4.3.5; x86_64; ; )
Cc: Paul Mundt <lethal@linux-sh.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>, linuxppc-dev@ozlabs.org,
       "David H?rdeman" <david@hardeman.nu>, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
       linux-mips@linux-mips.org, linux-m68k@vger.kernel.org
References: <201005051720.22617.PeterHuewe@gmx.de> <201005112042.14889.PeterHuewe@gmx.de> <20100514060240.GD12002@linux-sh.org>
In-Reply-To: <20100514060240.GD12002@linux-sh.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005141326.52099.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

This patch adds a missing include linux/delay.h to prevent
build failures[1-5]

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
Forwarded to linux-next mailing list - 
breakage still exists in linux-next of 20100514 - please apply

KernelVersion: linux-next-20100505

References:
[1] http://kisskb.ellerman.id.au/kisskb/buildresult/2571452/
[2] http://kisskb.ellerman.id.au/kisskb/buildresult/2571188/
[3] http://kisskb.ellerman.id.au/kisskb/buildresult/2571479/
[4] http://kisskb.ellerman.id.au/kisskb/buildresult/2571429/
[5] http://kisskb.ellerman.id.au/kisskb/buildresult/2571432/

drivers/media/IR/rc-map.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/IR/rc-map.c b/drivers/media/IR/rc-map.c
index caf6a27..46a8f15 100644
--- a/drivers/media/IR/rc-map.c
+++ b/drivers/media/IR/rc-map.c
@@ -14,6 +14,7 @@
 
 #include <media/ir-core.h>
 #include <linux/spinlock.h>
+#include <linux/delay.h>
 
 /* Used to handle IR raw handler extensions */
 static LIST_HEAD(rc_map_list);
-- 
1.6.4.4
