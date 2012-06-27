Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597Ab2F0UBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 16:01:20 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20168 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219Ab2F0UBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 16:01:19 -0400
Date: Wed, 27 Jun 2012 22:01:18 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: devel@driverdev.osuosl.org, Marcos Paulo de Souza <marcos.mage@gmail.com>,
        trivial@kernel.org, Forest Bond <forest@alittletooquiet.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] staging: vt6656: int.c: Put comment about DEBUG print
 define on same line as code
In-Reply-To: <alpine.LNX.2.00.1206272158130.6908@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1206272200460.6908@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1206242209570.30361@swampdragon.chaosbits.net> <20120625174709.GA3789@kroah.com> <alpine.LNX.2.00.1206272158130.6908@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A small comment at the end of the line, mentioning the debug level, is
enough - no need to repeat the entire line of code just for that.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/vt6656/int.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index 36ed234..286ac3e 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -41,8 +41,7 @@
 #include "usbpipe.h"
 
 /*---------------------  Static Definitions -------------------------*/
-/* static int msglevel = MSG_LEVEL_DEBUG; */
-static int msglevel = MSG_LEVEL_INFO;
+static int msglevel = MSG_LEVEL_INFO; /* MSG_LEVEL_DEBUG */
 
 /*---------------------  Static Classes  ----------------------------*/
 
-- 
1.7.11.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

