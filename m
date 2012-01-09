Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933541Ab2AIXe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 18:34:57 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5169 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933498Ab2AIXe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 18:34:56 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6584"; a="153564441"
Date: Mon, 9 Jan 2012 15:34:39 -0800
From: David Brown <davidb@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] msm fix for v3.2-rc.
Message-ID: <20120109233439.GA13911@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small fix that prevented msm7201 from building.

The following changes since commit 805a6af8dba5dfdd35ec35dc52ec0122400b2610:

  Linux 3.2 (2012-01-04 15:55:44 -0800)

are available in the git repository at:
  git://codeaurora.org/quic/kernel/davidb/linux-msm.git msm-fix

there is a signed tag 'davidb-msm-fix'.

David Brown (1):
      ARM: msm: vreg is a module and so needs module.h

 arch/arm/mach-msm/vreg.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
