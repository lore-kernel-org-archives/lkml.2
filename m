Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab2B0St0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 13:49:26 -0500
Received: from que21.charter.net ([209.225.8.22]:47719 "EHLO que21.charter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754608Ab2B0StY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 13:49:24 -0500
X-Authority-Analysis: v=1.1 cv=rvNqJbVGdbt4egs52VbhtoJZG7AoPDG9H2iogr/sNfs=
 c=1 sm=1 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=XhpBBPqgebOpJt4NlbQA:9 a=9qnmV1HwArN0s36HDI0A:7
 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
To: sgruszka@redhat.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [PATCH 0/4] iwlegacy cleanups
Date: Mon, 27 Feb 2012 12:25:29 -0600
Message-Id: <1330367133-26465-1-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first two patches reorganize the Kconfig for the iwlegacy drivers. This is
intended to make the debug options appear in a more logical manner.

The second two patches remove some unused code from the iwlegacy driver.

These patches are based on the wireless-next tree.

Greg Dietsche (4):
  iwlegacy: Kconfig: Move Debugging Options
  iwlegacy: Kconfig: Change Debug Option to be more clear
  iwlegacy: remove enum iw_calib and related code
  iwlegacy: remove unused enum il4965_calib_enabled_state

 drivers/net/wireless/iwlegacy/4965-calib.c |   12 ----
 drivers/net/wireless/iwlegacy/4965-mac.c   |    1 -
 drivers/net/wireless/iwlegacy/4965.h       |    1 -
 drivers/net/wireless/iwlegacy/Kconfig      |   78 ++++++++++++++--------------
 drivers/net/wireless/iwlegacy/common.h     |   23 --------
 5 files changed, 39 insertions(+), 76 deletions(-)

-- 
1.7.6.4

