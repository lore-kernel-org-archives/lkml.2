Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab1HHPxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 11:53:14 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:35346 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751583Ab1HHPxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 11:53:13 -0400
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/2] bnx2x: Logging message cleanups
Date: Mon,  8 Aug 2011 08:53:03 -0700
Message-Id: <cover.1312818707.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches (2):
  bnx2x: Remove local defines for %pM and mac address
  bnx2x: Coalesce pr_cont uses and fix DP typos

 drivers/net/bnx2x/bnx2x.h      |    4 -
 drivers/net/bnx2x/bnx2x_cmn.c  |   42 ++++++-----
 drivers/net/bnx2x/bnx2x_cmn.h  |    4 +-
 drivers/net/bnx2x/bnx2x_dcb.c  |    2 +-
 drivers/net/bnx2x/bnx2x_link.c |  155 +++++++++++++++++++++-------------------
 drivers/net/bnx2x/bnx2x_main.c |   47 ++++++-------
 drivers/net/bnx2x/bnx2x_sp.c   |   64 ++++++++---------
 7 files changed, 158 insertions(+), 160 deletions(-)

-- 
1.7.6.405.gc1be0

