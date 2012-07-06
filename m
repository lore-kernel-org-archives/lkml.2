Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933137Ab2GFKlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:41:17 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:29884 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932928Ab2GFKlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:41:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAHC/9k9bdWOb/2dsb2JhbABFhWSxVIEHghkBBSMPAUYQJQImAgJXB4ghpzmTA4Egjy2BEgOVN5ADgmE
X-IronPort-AV: E=Sophos;i="4.77,537,1336341600"; 
   d="scan'208";a="940130604"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 00/19 v2] Several cleanings and style fixes
Date: Fri,  6 Jul 2012 12:40:35 +0200
Message-Id: <cover.1341569486.git.magomez@igalia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1341498465.git.magomez@igalia.com>
References: <cover.1341498465.git.magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Second version of the patches round containing suggestions made
to the first version:

* patch 0001:
** keep some useful comments.
** format a couple of multiline comments
** don't remove empty lines in vb_util.h and vb_init.h

* patch 0005:
** remove exclamation marks from a string

* patch 0015
** simplify a bit more by joining another couple of conditions

* patch 0017
** replace do-while with gotos

* patch 0018
** move some comments to previous line instead of modifying them

Also, I'm sending all of the patches again because they were encoded in
base64 instead of 8bit.

Regards!

Miguel Gómez (19):
  Staging: xgifb: Comment cleaning.
  Staging: xgifb: Remove unneeded XGI_LCD_TYPE enumeration.
  Staging: xgifb: Remove LCDA detection in xgifb_probe().
  Staging: xgifb: Remove unused struct _chswtable.
  Staging: xgifb: Improve debug strings.
  Staging: xgifb: Remove useless switch in XGIfb_detect_VB().
  Staging: xgifb: Simplify XGIfb_GetXG21DefaultLVDSModeIdx().
  Staging: xgifb: Remove unneeded var and condition in
    XGIfb_search_vesamode().
  Staging: xgifb: Remove useless always true condition.
  Staging: xgifb: Rework conditions in XGI_SetATTRegs().
  Staging: xgifb: Refactor XGI_AjustCRT2Rate().
  Staging: xgifb: Refactor XGI_GetVBType().
  Staging: xgifb: Rework conditions in XGI_GetVBInfo().
  Staging: xgifb: Refactor XGI_GetCRT2ResInfo().
  Staging: xgifb: Rework conditions in XGI_SetLockRegs().
  Staging: xgifb: Rework conditions in XGI_EnableBridge().
  Staging: xgifb: Rework some conditions in XGI_SetCRT2ModeRegs().
  Staging: xgifb: Fix coding style.
  Staging: xgifb: Remove useless condition.

 drivers/staging/xgifb/XGI_main.h    |   14 -
 drivers/staging/xgifb/XGI_main_26.c |  247 +++---------
 drivers/staging/xgifb/XGIfb.h       |    8 +-
 drivers/staging/xgifb/vb_def.h      |    3 -
 drivers/staging/xgifb/vb_init.c     |  166 +-------
 drivers/staging/xgifb/vb_setmode.c  |  747 ++++++++++++++++-------------------
 drivers/staging/xgifb/vb_struct.h   |    3 -
 drivers/staging/xgifb/vb_table.h    |   65 ++-
 drivers/staging/xgifb/vgatypes.h    |   34 --
 9 files changed, 455 insertions(+), 832 deletions(-)

-- 
1.7.9.5

