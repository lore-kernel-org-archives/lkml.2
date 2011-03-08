Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338Ab1CHUQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 15:16:13 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:58611 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072Ab1CHUQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 15:16:12 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 00/15] staging: xgifb: misc cleanups
Date: Tue,  8 Mar 2011 22:16:05 +0200
Message-Id: <1299615380-22922-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Here's again some miscellaneous xgifb cleanups mainly to remove unused
code.

No compilation warnings from GCC 4.5.2, also checked that framebuffer
console works with Z9 on ARM.

Aaro Koskinen (15):
  staging: xgifb: delete HW cursor memory allocation
  staging: xgifb: delete command queue selection/init
  staging: xgifb: delete offscreen memory management
  staging: xgifb: delete unused fields from xgi_hw_device_info
  staging: xgifb: delete bSkipSense
  staging: xgifb: delete bIntegratedMMEnabled
  staging: xgifb: delete nomax module parameter
  staging: xgifb: vb_setmode: make internal functions static
  staging: xgifb: vb_setmode: include the .h file
  staging: xgifb: vb_ext: delete redundant declarations
  staging: xgifb: vb_ext: delete unused functions
  staging: xgifb: vb_ext: make internal functions static
  staging: xgifb: vb_init: delete redundant declarations
  staging: xgifb: vb_init: delete unused functions
  staging: xgifb: vb_init: make internal functions static

 drivers/staging/xgifb/XGI_main.h    |  104 ----
 drivers/staging/xgifb/XGI_main_26.c |  573 ------------------
 drivers/staging/xgifb/XGIfb.h       |    1 -
 drivers/staging/xgifb/vb_ext.c      |  472 +--------------
 drivers/staging/xgifb/vb_ext.h      |    6 -
 drivers/staging/xgifb/vb_init.c     | 1135 ++---------------------------------
 drivers/staging/xgifb/vb_setmode.c  |  417 ++++++--------
 drivers/staging/xgifb/vb_setmode.h  |    4 -
 drivers/staging/xgifb/vgatypes.h    |   33 -
 9 files changed, 235 insertions(+), 2510 deletions(-)

