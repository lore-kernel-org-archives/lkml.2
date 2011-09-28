Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308Ab1I1Gs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 02:48:28 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:53967 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab1I1Gs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 02:48:26 -0400
Date: Wed, 28 Sep 2011 16:48:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, Greg KH <greg@kroah.com>
Subject: Re: linux-next: manual merge of the moduleh tree with the staging
 tree
Message-Id: <20110928164824.29edfa867dfe583ff5b982e8@canb.auug.org.au>
In-Reply-To: <20110928164419.372feaa0c5554687403a9af5@canb.auug.org.au>
References: <20110928164419.372feaa0c5554687403a9af5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Wed, 28 Sep 2011 16:44:19 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Today's linux-next merge of the moduleh tree got a conflict in
> drivers/staging/iio/accel/adis16201_ring.c between commit 779921683e6d
> ("staging:iio:accel header housekeeping - remove unecessary includes")
> from the staging tree and commit 15f310ea9641 ("staging: Add export.h for
> THIS_MODULE/EXPORT_SYMBOL to drivers/staging users") from the moduleh
> tree.

Also drivers/staging/iio/accel/adis16203_ring.c,
drivers/staging/iio/accel/adis16204_ring.c,
drivers/staging/iio/accel/adis16209_ring.c,
drivers/staging/iio/accel/adis16240_ring.c,
drivers/staging/iio/gyro/adis16260_ring.c and
drivers/staging/iio/meter/ade7758_ring.c
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/iio/accel/adis16203_ring.c
index 993e239,ce23f4a..0000000
--- a/drivers/staging/iio/accel/adis16203_ring.c
+++ b/drivers/staging/iio/accel/adis16203_ring.c
@@@ -3,10 -6,16 +3,11 @@@
  #include <linux/kernel.h>
  #include <linux/spi/spi.h>
  #include <linux/slab.h>
 -#include <linux/sysfs.h>
 -#include <linux/list.h>
+ #include <linux/export.h>
  
  #include "../iio.h"
 -#include "../sysfs.h"
  #include "../ring_sw.h"
 -#include "accel.h"
 -#include "../trigger.h"
 +#include "../trigger_consumer.h"
  #include "adis16203.h"
  
  /**
diff --cc drivers/staging/iio/accel/adis16204_ring.c
index 847f438,0d0da0c..0000000
--- a/drivers/staging/iio/accel/adis16204_ring.c
+++ b/drivers/staging/iio/accel/adis16204_ring.c
@@@ -3,10 -6,16 +3,11 @@@
  #include <linux/kernel.h>
  #include <linux/spi/spi.h>
  #include <linux/slab.h>
 -#include <linux/sysfs.h>
 -#include <linux/list.h>
+ #include <linux/export.h>
  
  #include "../iio.h"
 -#include "../sysfs.h"
  #include "../ring_sw.h"
 -#include "accel.h"
 -#include "../trigger.h"
 +#include "../trigger_consumer.h"
  #include "adis16204.h"
  
  /**
diff --cc drivers/staging/iio/accel/adis16209_ring.c
index f889fe7,c7f9d59..0000000
--- a/drivers/staging/iio/accel/adis16209_ring.c
+++ b/drivers/staging/iio/accel/adis16209_ring.c
@@@ -3,10 -6,16 +3,11 @@@
  #include <linux/kernel.h>
  #include <linux/spi/spi.h>
  #include <linux/slab.h>
 -#include <linux/sysfs.h>
 -#include <linux/list.h>
+ #include <linux/export.h>
  
  #include "../iio.h"
 -#include "../sysfs.h"
  #include "../ring_sw.h"
 -#include "accel.h"
 -#include "../trigger.h"
 +#include "../trigger_consumer.h"
  #include "adis16209.h"
  
  /**
diff --cc drivers/staging/iio/accel/adis16240_ring.c
index 051ba64,a5033b9..0000000
--- a/drivers/staging/iio/accel/adis16240_ring.c
+++ b/drivers/staging/iio/accel/adis16240_ring.c
@@@ -3,10 -6,16 +3,11 @@@
  #include <linux/kernel.h>
  #include <linux/spi/spi.h>
  #include <linux/slab.h>
 -#include <linux/sysfs.h>
 -#include <linux/list.h>
+ #include <linux/export.h>
  
  #include "../iio.h"
 -#include "../sysfs.h"
  #include "../ring_sw.h"
 -#include "accel.h"
 -#include "../trigger.h"
 +#include "../trigger_consumer.h"
  #include "adis16240.h"
  
  /**
diff --cc drivers/staging/iio/gyro/adis16260_ring.c
index 10f8a66,85e6fac..0000000
--- a/drivers/staging/iio/gyro/adis16260_ring.c
+++ b/drivers/staging/iio/gyro/adis16260_ring.c
@@@ -3,10 -6,16 +3,11 @@@
  #include <linux/kernel.h>
  #include <linux/spi/spi.h>
  #include <linux/slab.h>
 -#include <linux/sysfs.h>
 -#include <linux/list.h>
+ #include <linux/export.h>
  
  #include "../iio.h"
 -#include "../sysfs.h"
  #include "../ring_sw.h"
 -#include "../accel/accel.h"
 -#include "../trigger.h"
 +#include "../trigger_consumer.h"
  #include "adis16260.h"
  
  /**
diff --cc drivers/staging/iio/meter/ade7758_ring.c
index 1e2a096,88805b2..0000000
--- a/drivers/staging/iio/meter/ade7758_ring.c
+++ b/drivers/staging/iio/meter/ade7758_ring.c
@@@ -9,6 -9,14 +9,7 @@@
  #include <linux/kernel.h>
  #include <linux/spi/spi.h>
  #include <linux/slab.h>
 -#include <linux/sysfs.h>
 -#include <linux/list.h>
+ #include <linux/export.h>
  #include <asm/unaligned.h>
  
  #include "../iio.h"
