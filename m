Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab1I1GoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 02:44:24 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:39861 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab1I1GoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 02:44:23 -0400
Date: Wed, 28 Sep 2011 16:44:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the moduleh tree with the staging tree
Message-Id: <20110928164419.372feaa0c5554687403a9af5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Today's linux-next merge of the moduleh tree got a conflict in
drivers/staging/iio/accel/adis16201_ring.c between commit 779921683e6d
("staging:iio:accel header housekeeping - remove unecessary includes")
from the staging tree and commit 15f310ea9641 ("staging: Add export.h for
THIS_MODULE/EXPORT_SYMBOL to drivers/staging users") from the moduleh
tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/iio/accel/adis16201_ring.c
index 4b433c5,52ab4f0..0000000
--- a/drivers/staging/iio/accel/adis16201_ring.c
+++ b/drivers/staging/iio/accel/adis16201_ring.c
@@@ -3,10 -4,15 +3,11 @@@
  #include <linux/kernel.h>
  #include <linux/spi/spi.h>
  #include <linux/slab.h>
 -#include <linux/sysfs.h>
+ #include <linux/export.h>
  
  #include "../iio.h"
 -#include "../sysfs.h"
  #include "../ring_sw.h"
 -#include "accel.h"
 -#include "../trigger.h"
 +#include "../trigger_consumer.h"
  #include "adis16201.h"
  
  
