Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933996Ab1IIXBM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 19:01:12 -0400
Received: from mail-vw0-f43.google.com ([209.85.212.43]:56761 "EHLO
	mail-vw0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933974Ab1IIXBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 19:01:11 -0400
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Jerome Marchand <jmarchan@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5 v3] zram: minor cleanups and features
Date: Fri,  9 Sep 2011 19:00:59 -0400
Message-Id: <1315609264-13632-1-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog: v3 vs v2:
 - Provide proper summary for patch 1/5 (fix for sparse warnings)
 
Changelog: v2 vs v1:
 - Fixed a sparse warning (make zram_slot_free_notify static)
 - Remove check for zero disksize since we now set it to
   some default size during initialization.

These changes address many of the issues list at:
http://code.google.com/p/compcache/issues/list

Thanks to Jerome Marchand for reviews.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>

Nitin Gupta (5):
  zram: Fix sparse warnings
  zram: Kernel config option for number of devices
  zram: Make gobal variables use unique names
  zram: Simplify zram disk resizing interface
  zram: Set initial disksize to some default value

 drivers/staging/zram/Kconfig      |    9 ++++
 drivers/staging/zram/zram_drv.c   |   95 ++++++++++++++++---------------------
 drivers/staging/zram/zram_drv.h   |    6 +-
 drivers/staging/zram/zram_sysfs.c |    4 +-
 4 files changed, 55 insertions(+), 59 deletions(-)

-- 
1.7.6

