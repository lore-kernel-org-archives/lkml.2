Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab1H3Wvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 18:51:42 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15409 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab1H3Wvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 18:51:41 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6454"; a="113939912"
Date: Tue, 30 Aug 2011 15:51:39 -0700
From: David Brown <davidb@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] msm: initial devicetree support
Message-ID: <20110830225139.GA7093@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit c6a389f123b9f68d605bb7e0f9b32ec1e3e14132:

  Linux 3.1-rc4 (2011-08-28 21:16:01 -0700)

are available in the git repository at:
  git://codeaurora.org/quic/kernel/davidb/linux-msm.git msm-dt

David Brown (3):
      msm_serial: Use relative resources for iomem
      msm_serial: Add devicetree support
      ARM: msm: Add devicetree support for msm8660-surf

 .../devicetree/bindings/tty/serial/msm_serial.txt  |   27 +++++++++
 arch/arm/boot/dts/msm8660-surf.dts                 |   24 ++++++++
 arch/arm/mach-msm/board-msm8x60.c                  |   58 +++++++++++++++++---
 drivers/tty/serial/msm_serial.c                    |   30 +++++++----
 4 files changed, 122 insertions(+), 17 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/tty/serial/msm_serial.txt
 create mode 100644 arch/arm/boot/dts/msm8660-surf.dts

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
