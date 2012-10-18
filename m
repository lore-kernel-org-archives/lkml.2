Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab2JRTen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 15:34:43 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:34515 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab2JRTek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 15:34:40 -0400
Date: Thu, 18 Oct 2012 21:34:38 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: linux-kernel@vger.kernel.org, Scott H Kilau <Scott_Kilau@digi.com>,
        devel@driverdev.osuosl.org, Bill Pemberton <wfp5p@virginia.edu>
Subject: [PATCH] staging: remove version.h include from dgrp/dgrp_sysfs.c
Message-ID: <alpine.LNX.2.00.1210182129570.17217@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file uses nothing from linux/version.h, so the include is
pointless - remove it.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/dgrp/dgrp_sysfs.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/dgrp/dgrp_sysfs.c b/drivers/staging/dgrp/dgrp_sysfs.c
index e5a3c88..a13318c 100644
--- a/drivers/staging/dgrp/dgrp_sysfs.c
+++ b/drivers/staging/dgrp/dgrp_sysfs.c
@@ -17,7 +17,6 @@
 #include "dgrp_common.h"
 
 #include <linux/kernel.h>
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/ctype.h>
 #include <linux/string.h>
-- 
1.7.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

