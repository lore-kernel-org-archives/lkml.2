Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab1DRWkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 18:40:21 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36880 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab1DRWkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 18:40:19 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6320"; a="86522093"
From: David Brown <davidb@codeaurora.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL for 39-rc4] msm: minor fixes
Date: Mon, 18 Apr 2011 15:40:18 -0700
Message-ID: <8ya8vv7xjxp.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are some minor fixes to ARM's MSM.  I would have sent them
earlier, but was on vacation.

The following changes since commit 0ce790e7d736cedc563e1fb4e998babf5a4dbc3d:

  Linux 2.6.39-rc1 (2011-03-29 12:09:47 -0700)

are available in the git repository at:
  git://codeaurora.org/quic/kernel/davidb/linux-msm.git for-39-rc4

David Brown (2):
      msm: Remove extraneous ffa device check
      msm: timer: fix missing return value

 arch/arm/mach-msm/board-qsd8x50.c |    5 +----
 arch/arm/mach-msm/timer.c         |    2 +-
 2 files changed, 2 insertions(+), 5 deletions(-)

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
