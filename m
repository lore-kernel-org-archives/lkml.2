Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397Ab2FRLMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:12:39 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:56246 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750786Ab2FRLMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:12:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am4CADoM309bdWObgWdsb2JhbABFhVewBCIBARYmJ4JCDwFGNQImAmCIIaVykgWBII9AgRIDlSSSXw
X-IronPort-AV: E=Sophos;i="4.77,430,1336341600"; 
   d="scan'208";a="1004339225"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 0/8] Homogenize application output and fix sparse warnings.
Date: Mon, 18 Jun 2012 13:11:58 +0200
Message-Id: <cover.1340016625.git.magomez@igalia.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This serie of patches mailnly try to homogenize module's output by removing some
custom macros and printk calls, and using pr_* and dev_* functions instead.
Also, they fix the definition of a fuction only in debug mode and fix some
sparse warnings.

Miguel Gómez (8):
  Staging: xgifb: reformat module parameter descriptions.
  Staging: xgifb: remove DEBUGPRN() macro and its uses.
  Staging: xgifb: remove DPRINTK() macro and replace it with pr_debug.
  Staging: xgifb: define real dumpVGAReg() content only in DEBUG mode.
  Staging: xgifb: Remove XGIFAIL() macro and its calls.
  Staging: xgifb: Remove printk usage.
  Staging: xgifb: Fix sparse warnings.
  Staging: xgifb: Replace pr_* with dev_* when possible.

 drivers/staging/xgifb/XGI_main.h    |    2 -
 drivers/staging/xgifb/XGI_main_26.c |  189 ++++++++++++++++-------------------
 drivers/staging/xgifb/vb_init.c     |   48 +--------
 drivers/staging/xgifb/vb_setmode.c  |    2 +-
 drivers/staging/xgifb/vb_util.c     |    1 +
 5 files changed, 92 insertions(+), 150 deletions(-)

-- 
1.7.9.5

