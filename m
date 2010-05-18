Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408Ab0ERVkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 17:40:22 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33782 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab0ERVkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 17:40:20 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,5986"; a="41883180"
Subject: [GIT PULL] MSM frambuffer driver update
From: Daniel Walker <dwalker@codeaurora.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-msm@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 May 2010 14:40:10 -0700
Message-ID: <1274218810.29811.75.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are a couple of updates to get the MSM framebuffer driver to
compile, and make it turned off by default.

Daniel

The following changes since commit c81eddb0e3728661d1585fbc564449c94165cc36:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git390.marist.edu/pub/scm/linux-2.6

are available in the git repository at:

  git://codeaurora.org/quic/kernel/dwalker/linux-msm.git msm-video

Daniel Walker (2):
      drivers: video: msm: default to no
      drivers: video: msm: add include msm_mdp.h

 drivers/video/Kconfig   |    1 -
 include/linux/msm_mdp.h |   78 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/msm_mdp.h


