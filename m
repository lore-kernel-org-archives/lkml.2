Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab2BEAjn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 19:39:43 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:10990 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab2BEAjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 19:39:42 -0500
Date: Sun, 5 Feb 2012 01:40:09 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: devel@driverdev.osuosl.org
cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH] Staging: The header linux/module.h is included twice in
 drivers/staging/iio/dac/ad5686.c
Message-ID: <alpine.LNX.2.00.1202050138250.30244@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the unneeded duplicate.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/iio/dac/ad5686.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/iio/dac/ad5686.c b/drivers/staging/iio/dac/ad5686.c
index ce2d619..2415a6e 100644
--- a/drivers/staging/iio/dac/ad5686.c
+++ b/drivers/staging/iio/dac/ad5686.c
@@ -15,7 +15,6 @@
 #include <linux/slab.h>
 #include <linux/sysfs.h>
 #include <linux/regulator/consumer.h>
-#include <linux/module.h>
 
 #include "../iio.h"
 #include "../sysfs.h"
-- 
1.7.9


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

