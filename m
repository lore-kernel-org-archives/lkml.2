Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933211Ab2GEOtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 10:49:42 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:44523 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932530Ab2GEOqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 10:46:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EANqn9U9bdWOb/2dsb2JhbABFhV+xR4EHgkIPAUY1AiYCYIghpnqSVoEgj0WBEgOVN5ADgmE
X-IronPort-AV: E=Sophos;i="4.77,531,1336341600"; 
   d="scan'208";a="926562635"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 00/19] Several cleanings and style fixes
Date: Thu,  5 Jul 2012 16:45:43 +0200
Message-Id: <cover.1341498465.git.magomez@igalia.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

The goal of this round of patches is to perform a cleaning of the code and
to remove the style problems found on it.

The first patch removes a lot of comments and commented code, leaving only
those that seem interesting to understand the code.
Then there are some patches removing useless structures and pieces of code
that I found during the comment revision.
And also a patch improving some debug strings that I had pending from my
previous round of patches.

Patches 10 to 17 rework some conditions in some places of the code to fix
style errors related to excessive indentation. And patch 18 fixes the remaining
style errors.

Finally patch 19 removes a useless condition.

After this round of pathches, there are no style errors in the code that
are reported by checkpatch.

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
 drivers/staging/xgifb/XGI_main_26.c |  245 ++----------
 drivers/staging/xgifb/XGIfb.h       |    8 +-
 drivers/staging/xgifb/vb_def.h      |    3 -
 drivers/staging/xgifb/vb_init.c     |  166 +-------
 drivers/staging/xgifb/vb_init.h     |    1 -
 drivers/staging/xgifb/vb_setmode.c  |  742 ++++++++++++++++-------------------
 drivers/staging/xgifb/vb_struct.h   |    3 -
 drivers/staging/xgifb/vb_table.h    |   55 +--
 drivers/staging/xgifb/vb_util.h     |    1 -
 drivers/staging/xgifb/vgatypes.h    |   37 --
 11 files changed, 437 insertions(+), 838 deletions(-)

-- 
1.7.9.5

