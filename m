Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964878Ab1FWXLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 19:11:51 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:25396 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932724Ab1FWXLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 19:11:50 -0400
Date: Fri, 24 Jun 2011 01:02:55 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: LKML <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Nishanth Menon <nm@ti.com>, devel@driverdev.osuosl.org
Subject: [PATCH 33/37] Remove unneeded version.h include from
 drivers/staging/tidspbridge/include/dspbridge/host_os.h
In-Reply-To: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1106240101520.17688@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was pointed out by 'make versioncheck' that include of
linux/version.h is not needed in
drivers/staging/tidspbridge/include/dspbridge/host_os.h
This patch removes it.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 .../tidspbridge/include/dspbridge/host_os.h        |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/host_os.h b/drivers/staging/tidspbridge/include/dspbridge/host_os.h
index b1b8acb..1a38896 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/host_os.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/host_os.h
@@ -24,7 +24,6 @@
 #include <linux/irq.h>
 #include <linux/io.h>
 #include <linux/syscalls.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/stddef.h>
-- 
1.7.5.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

