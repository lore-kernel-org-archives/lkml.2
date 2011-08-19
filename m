Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab1HSTkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 15:40:33 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:55630 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904Ab1HSTka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 15:40:30 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: apatard@mandriva.com, gregkh@suse.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 00/12] staging: xgifb: misc cleanups
Date: Fri, 19 Aug 2011 22:40:18 +0300
Message-Id: <1313782830-31461-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here's some miscellaneous cleanups for the xgifb staging driver. There
are no functional changes, except one printk() message is gone.

The patch number 8 will give you checkpatch warnings, but those are not
introduced by these changes. The actual change is very simple as can be
seen with "diff -w".

Testing:
	- compile-tested with GCC 4.6.1, no warnings.
	- tested with Z9 (XG21) on ARM, framebuffer console works

Aaro Koskinen (12):
  staging: xgifb: eliminate #ifdef NewScratch
  staging: xgifb: eliminate XGIINITSTATIC
  staging: xgifb: delete duplicate #defines
  staging: xgifb: delete unused definitions
  staging: xgifb: vb_table: delete unused data
  staging: xgifb: delete unused structs
  staging: xgifb: eliminate #ifdef XGIFB_PAN
  staging: xgifb: probe: delete checks for mode "none"
  staging: xgifb: replace video_type with FB_TYPE_PACKED_PIXELS
  staging: xgifb: delete write-only variables
  staging: xgifb: delete driver version information
  staging: xgifb: delete an empty string

 drivers/staging/xgifb/XGI_main.h    |  110 ------
 drivers/staging/xgifb/XGI_main_26.c |  518 ++++++++++++-------------
 drivers/staging/xgifb/XGIfb.h       |   12 -
 drivers/staging/xgifb/vb_def.h      |  590 +----------------------------
 drivers/staging/xgifb/vb_ext.h      |   20 -
 drivers/staging/xgifb/vb_setmode.c  |    3 -
 drivers/staging/xgifb/vb_struct.h   |   71 ----
 drivers/staging/xgifb/vb_table.h    |  729 -----------------------------------
 drivers/staging/xgifb/vgatypes.h    |    5 -
 9 files changed, 242 insertions(+), 1816 deletions(-)

-- 
1.7.2.5

