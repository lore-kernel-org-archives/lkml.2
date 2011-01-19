Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab1ASWgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 17:36:24 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36501 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134Ab1ASWgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 17:36:23 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6231"; a="71145525"
X-Hashcash: 1:20:110119:torvalds@linux-foundation.org::xP/+jW6RaQdMXn4d:000000000000000000000000000000001OC8
X-Hashcash: 1:20:110119:linux-arm-msm@vger.kernel.org::WlOucNAErkyVhjdD:000000000000000000000000000000000O4a
X-Hashcash: 1:20:110119:linux-kernel@vger.kernel.org::3Gj3ulqNYgpi90GP:0000000000000000000000000000000006ERY
X-Hashcash: 1:20:110119:linux-arm-kernel@lists.infradead.org::Frb2v/aanKN5+3IO:00000000000000000000000000sfl
X-Hashcash: 1:20:110119:sboyd@codeaurora.org::r2+IxrhlUQvd2qiq:000000000000000000000000000000000000000006Qmg
From: David Brown <davidb@codeaurora.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [GIT PULL for 38-rc2] msm: initdata fix
Date: Wed, 19 Jan 2011 14:36:22 -0800
Message-ID: <8ya8vygo715.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I seem to have missed this fix for the rc1.  Without it, access to
/sys entries for the ethernet access freed memory.

Thanks,
David

The following changes since commit c56eb8fb6dccb83d9fe62fd4dc00c834de9bc470:

  Linux 2.6.38-rc1 (2011-01-18 15:14:02 -0800)

are available in the git repository at:
  git://codeaurora.org/quic/kernel/davidb/linux-msm.git for-38-rc2

Stephen Boyd (1):
      msm: qsd8x50: Platform data isn't init data

 arch/arm/mach-msm/board-qsd8x50.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
