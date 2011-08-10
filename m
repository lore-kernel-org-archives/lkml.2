Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab1HJPSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 11:18:47 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47871 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187Ab1HJPSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 11:18:44 -0400
From: <pavan_savoy@ti.com>
To: <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
CC: <pavan_savoy@sify.com>, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 0/8] drivers:misc: ti-st: fixes
Date: Wed, 10 Aug 2011 10:18:29 -0500
Message-ID: <1312989517-28604-1-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>


resending with fixed up commit messages.

Pavan Savoy (7):
  drivers:misc: ti-st: avoid a misleading dbg msg
  drivers:misc:ti-st: platform hooks for chip states
  drivers:misc: ti-st: reinit completion on ver read
  drivers:misc: ti-st: reinit completion before send
  drivers:misc: ti-st: wait for completion at fail
  drivers:misc: ti-st: free skb on firmware download
  drivers:misc: ti-st: fix unexpected UART close

Vijay Badawadagi (1):
  drivers:misc: ti-st: fail-safe on wrong pkt type

 drivers/misc/ti-st/st_core.c |   10 +++++++++-
 drivers/misc/ti-st/st_kim.c  |   33 +++++++++++++++++++++++++++++++++
 drivers/misc/ti-st/st_ll.c   |   19 +++++++++++++++++++
 include/linux/ti_wilink_st.h |   27 ++++++++++++++++++++++++++-
 4 files changed, 87 insertions(+), 2 deletions(-)

-- 
1.7.4.1

