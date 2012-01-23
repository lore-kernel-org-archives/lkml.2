Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab2AWAtF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 19:49:05 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47038 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab2AWAtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 19:49:03 -0500
From: Sam Hansen <solid.se7en@gmail.com>
To: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sam Hansen <solid.se7en@gmail.com>
Subject: [PATCH V2 0/3] xgifb: patch set
Date: Sun, 22 Jan 2012 16:48:50 -0800
Message-Id: <1327279733-3350-1-git-send-email-solid.se7en@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <originalemailid>
References: <originalemailid>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is still some cleanup to do for printk, but mainly in the debug code.  I
noticed the bulk of it is commented out and suspect the rest will follow suit.

$ make modules
make[1]: Nothing to be done for `all'.
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CC [M]  drivers/staging/xgifb/XGI_main_26.o
  LD [M]  drivers/staging/xgifb/xgifb.o
  Building modules, stage 2.
  MODPOST 6 modules
  LD [M]  drivers/staging/xgifb/xgifb.ko

Sam Hansen (3):
  xgifb: checkpatch cleanup braces
  xgifb: checkpatch cleanup __func__
  xgifb: checkpatch cleanup printk() -> pr_lvl()

 drivers/staging/xgifb/XGI_main_26.c |   98 ++++++++++++++++------------------
 1 files changed, 46 insertions(+), 52 deletions(-)

-- 
1.7.5.4

