Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab1HXBfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 21:35:06 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61219 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab1HXBfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 21:35:02 -0400
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Jerome Marchand <jmarchan@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] zram: minor features and cleanups
Date: Wed, 24 Aug 2011 08:34:46 +0700
Message-Id: <1314149690-3177-1-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These changes address many of the issues list at:
http://code.google.com/p/compcache/issues/list

Signed-off-by: Nitin Gupta <ngupta@vflare.org>

Nitin Gupta (4):
  Kernel config option for number of devices
  Make gobal variables use unique names
  Simplify zram disk resizing interface
  Set initial disksize to some default value

 drivers/staging/zram/Kconfig      |    9 ++++
 drivers/staging/zram/zram_drv.c   |   93 ++++++++++++++++--------------------
 drivers/staging/zram/zram_drv.h   |    6 +-
 drivers/staging/zram/zram_sysfs.c |    4 +-
 4 files changed, 55 insertions(+), 57 deletions(-)

-- 
1.7.6

