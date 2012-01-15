Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810Ab2AOSWb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 13:22:31 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:40628 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751183Ab2AOSWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 13:22:30 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18H1tpRv5gH+mhE6twB5FbsZCHEFE5ivxDH1N42aA
	8vN3PlDL4sOhX/
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: staging/xgifb: Use sis headers and remove duplicated structs and defines
Date: Sun, 15 Jan 2012 19:22:09 +0100
Message-Id: <1326651733-9242-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the xgifb driver used the sis driver as a template for development,
a lot of defines and structs were redefined with only slightly different names.
This patchset tries to remove some of these duplicates by including the sis headers
and replacing any xgi struct/define by its identical twin from the sis headers.

The patches should not change any behavior of the driver, with the possible
exception of patch [PATCH 1/4] staging/xgifb: Remove unsupported mode LCD_320x480

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

git diff --stat origin
drivers/staging/xgifb/XGI_main.h    |   78 ++++------------------------
drivers/staging/xgifb/XGI_main_26.c |   95 ++++++++++++++++++-----------------
drivers/staging/xgifb/XGIfb.h       |    2 +-
drivers/staging/xgifb/vb_init.c     |    2 +-
drivers/staging/xgifb/vb_setmode.c  |   22 ++++----
drivers/staging/xgifb/vb_struct.h   |   79 +++--------------------------
drivers/staging/xgifb/vb_table.h    |   10 ++--
drivers/staging/xgifb/vgatypes.h    |    9 +++
8 files changed, 94 insertions(+), 203 deletions(-)



