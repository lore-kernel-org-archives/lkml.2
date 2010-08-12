Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760900Ab0HLTwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 15:52:31 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12488 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab0HLTw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 15:52:28 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6072"; a="50815857"
X-IronPort-AV: E=Sophos;i="4.55,359,1278313200"; 
   d="scan'208";a="3500498"
Subject: [GIT PULL] MSM mmc_sdcc updates for 2.6.36
From: Daniel Walker <c_dwalke@quicinc.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Aug 2010 12:52:17 -0700
Message-ID: <1281642737.26041.23.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

I know another MSM pull request ;( .. I'll merge all my trees for the
next merge window, which I planned to do this time but I had some issues
that prevented it.

Anyway, here are a few trivial fixes for the MSM mmc_sdcc driver.
Nothing at all earth shattering..

Please pull, and thanks for all the hard work!

Daniel

The following changes since commit 7e27d6e778cd87b6f2415515d7127eba53fe5d02:

  Linux 2.6.35-rc3 (2010-06-11 19:14:04 -0700)

are available in the git repository at:
  git://codeaurora.org/quic/kernel/dwalker/linux-msm.git msm-mmc_sdcc

Daniel Walker (1):
      mmc: msm: fix up build breakage on !PM

Sahitya Tummala (2):
      mmc: msm_sdcc: Compile the driver for msm7x30
      mmc: msm_sdcc: Rename config MMC_MSM7X00A to MMC_MSM

 drivers/mmc/host/Kconfig    |    9 ++++---
 drivers/mmc/host/Makefile   |    2 +-
 drivers/mmc/host/msm_sdcc.c |   51 +++++++++++++++++++-----------------------
 3 files changed, 29 insertions(+), 33 deletions(-)


