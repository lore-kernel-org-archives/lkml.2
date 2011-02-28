Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab1B1Klv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 05:41:51 -0500
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:49193 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753155Ab1B1Klv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 05:41:51 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <dan.j.williams@intel.com>, <linus.walleij@stericsson.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Viresh Kumar <viresh.kumar@st.com>, <shiraz.hashim@st.com>,
        <amit.goel@st.com>, <armando.visconti@st.com>
Subject: [PATCH 0/8 resend] dw_dmac: Extending support & minor fixes
Date: Mon, 28 Feb 2011 16:11:15 +0530
Message-ID: <cover.1298889267.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following set of patches extends dw_dmac support and fixes minor bugs.

This patch series has earlier been posted to linux-kernel@vger.kernel.org.
Didn't get any review there, so including linux-arm-kernel@lists.infradead.org.

Viresh Kumar (8):
  dw_dmac: Remove compilation dependency from AVR32
  dw_dmac: Move single descriptor from dwc->queue to dwc->active_list
    in dwc_complete_all
  dw_dmac: call dwc_scan_descriptor from dwc_issue_pending only if
    active list is empty
  dw_dmac: calling dwc_scan_descriptors from dwc_tx_status() after
    taking lock
  dw_dmac: adding support for 64 bit access width for memcpy xfers
  dw_dmac: Mark all tx_descriptors with DMA_CRTL_ACK after xfer finish
  dw_dmac.c: Pass Channel Allocation Order from platform_data
  dw_dmac.c: Pass Channel Priority from platform_data

 drivers/dma/Kconfig        |    1 -
 drivers/dma/dw_dmac.c      |   52 ++++++++++++++++++++++++++++++-------------
 drivers/dma/dw_dmac_regs.h |    3 ++
 include/linux/dw_dmac.h    |    7 +++++-
 4 files changed, 45 insertions(+), 18 deletions(-)

-- 
1.7.2.2

