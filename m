Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728Ab1CBVQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 16:16:13 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63848 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757460Ab1CBVQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 16:16:10 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6273"; a="77638175"
X-IronPort-AV: E=Sophos;i="4.62,253,1297065600"; 
   d="scan'208";a="56218981"
From: Carl Vanderlip <carlv@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        Dima Zavin <dima@android.com>, Carl Vanderlip <carlv@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: [PATCH 0/4] Initial patches for MSM display update
Date: Wed,  2 Mar 2011 13:15:42 -0800
Message-Id: <1299100542-11120-1-git-send-email-carlv@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are the first series of a set of patches to update the MSM display
drivers to support newer MDP versions and display modes (while also providing
a base for future display development). The original source for these patches
is the Google Android kernel tree located here:
http://android.git.kernel.org/kernel/msm.git

Arve Hjønnevåg (1):
  [ARM] msm_fb: Fix framebuffer console

Dima Zavin (3):
  video: msmfb: Put the partial update magic value into the fix_screen
    struct.
  [ARM] msm: mdp: Add support for RGBX 8888 image format.
  [ARM] msm: mdp: Set the correct pack pattern for XRGB/ARGB

 drivers/video/msm/mdp_hw.h  |   11 +++++++++--
 drivers/video/msm/mdp_ppp.c |    1 +
 drivers/video/msm/msm_fb.c  |   16 ++++++++++++++--
 include/linux/msm_mdp.h     |    1 +
 4 files changed, 25 insertions(+), 4 deletions(-)

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

