Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab1FTXma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 19:42:30 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11821 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981Ab1FTXm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 19:42:27 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6383"; a="98765676"
From: David Brown <davidb@codeaurora.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] msm fixes for 3.0-rc4
Date: Mon, 20 Jun 2011 16:42:27 -0700
Message-ID: <8yar56onk7w.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 2c53b436a30867eb6b47dd7bab23ba638d1fb0d2:

  Linux 3.0-rc3 (2011-06-13 15:29:59 -0700)

are available in the git repository at:
  git://codeaurora.org/quic/kernel/davidb/linux-msm.git msm-fix

Jeff Ohlstein (1):
      msm: timer: compensate for timer shift in msm_read_timer_count

Stephen Boyd (2):
      msm: timer: Fix SMP build error
      msm: timer: Fix DGT rate on 8960 and 8660

 arch/arm/mach-msm/timer.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
