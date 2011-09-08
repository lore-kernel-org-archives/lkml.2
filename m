Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784Ab1IHB3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 21:29:25 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:54420 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757704Ab1IHB3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 21:29:24 -0400
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Jerome Marchand <jmarchan@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5 v2] zram: minor features and cleanups
Date: Thu,  8 Sep 2011 08:29:12 +0700
Message-Id: <1315445357-14338-1-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(applies to staging-next)

Changes since v1:
 - Fixed a sparse warning (make zram_slot_free_notify static)
 - Remove check for zero disksize since we now set it to
   some default size during initialization.

These changes address many of the issues list at:
http://code.google.com/p/compcache/issues/list

Thanks to Jerome Marchand for reviews.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>

Nitin Gupta (5):
  Fix sparse warnings
  Kernel config option for number of devices
  Make gobal variables use unique names
  Simplify zram disk resizing interface
  Set initial disksize to some default value

 drivers/staging/zram/Kconfig      |    9 ++++
 drivers/staging/zram/zram_drv.c   |   95 ++++++++++++++++---------------------
 drivers/staging/zram/zram_drv.h   |    6 +-
 drivers/staging/zram/zram_sysfs.c |    4 +-
 4 files changed, 55 insertions(+), 59 deletions(-)

-- 
1.7.6

