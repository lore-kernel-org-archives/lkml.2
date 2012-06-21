Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760622Ab2FUXAo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 19:00:44 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12085 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760566Ab2FUXAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 19:00:43 -0400
Date: Fri, 22 Jun 2012 01:00:41 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Oleksij Rempel <bug-track@fisher-privat.net>,
        Edwin Rong <edwin_rong@realsil.com.cn>,
        wwang <wei_wang@realsil.com.cn>, trivial@kernel.org
Subject: [PATCH][Trivial] staging: rts5139: Remove duplicate include of
 rts51x.h
Message-ID: <alpine.LNX.2.00.1206220058050.7671@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The header "rts51x.h" is included unconditionally at the start of the
file and then again once more under "#ifdef SUPPORT_FILE_OP".  Once is
enough, so remove the conditional include and just keep the
unconditional one.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/rts5139/rts51x_fop.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/rts5139/rts51x_fop.c b/drivers/staging/rts5139/rts51x_fop.c
index ef893c8..e1200fe 100644
--- a/drivers/staging/rts5139/rts51x_fop.c
+++ b/drivers/staging/rts5139/rts51x_fop.c
@@ -36,7 +36,6 @@
 #include "rts51x_card.h"
 #include "rts51x_fop.h"
 #include "sd_cprm.h"
-#include "rts51x.h"
 
 #define RTS5139_IOC_MAGIC		0x39
 
-- 
1.7.11


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

