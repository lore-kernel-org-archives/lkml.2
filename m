Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353Ab2KPK7u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 05:59:50 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39752 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab2KPK7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 05:59:49 -0500
MIME-Version: 1.0
In-Reply-To: <CAHTX3dLdGie9gtxbPq_gb8BLao7YYohqQWZFg3LzyNHxu=imdg@mail.gmail.com>
References: <CAHTX3dLdGie9gtxbPq_gb8BLao7YYohqQWZFg3LzyNHxu=imdg@mail.gmail.com>
Date: Fri, 16 Nov 2012 11:59:47 +0100
X-Google-Sender-Auth: 699cpdB4Z4-Xoz4W3X_PT_kaJUM
Message-ID: <CAHTX3dLijLK45ddZQVYHcrs6QQbmdRmQbPmTKada9nXx3ZAe3w@mail.gmail.com>
Subject: [GIT PULL] arm-soc: Xilinx zynq changes for v3.8
From: Michal Simek <michal.simek@xilinx.com>
To: Arnd Bergmann <arnd@arndb.de>, arm@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>,
        Nick Bowler <nbowler@elliptictech.com>
Cc: Josh Cartwright <josh.cartwright@ni.com>, John Linn <John.Linn@xilinx.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd and Olof,

I have 7 new follow up patches for zynq. They are based on previous patches
(arm-soc zynq/cleanup branch).
The branch is still based on rc3 but I have also tried to merged it
with the v3.7-rc5 and there is no issue.

It should be the last pull request for v3.8.

Thanks for pulling.
Michal



The following changes since commit f58007762f537ba13674a3138b3f4c20fff1cba9:
  Josh Cartwright (1):
        zynq: move static peripheral mappings

are available in the git repository at:

  git://git.xilinx.com/linux-xlnx.git arm-next

Josh Cartwright (6):
      ARM: zynq: move arm-specific sys_timer out of ttc
      ARM: zynq: dts: add description of the second uart
      ARM: zynq: dts: split up device tree
      clk: Add support for fundamental zynq clks
      ARM: zynq: use zynq clk bindings
      ARM: zynq: add clk binding support to the ttc

Nick Bowler (1):
      ARM: zynq: Allow UART1 to be used as DEBUG_LL console.

 .../devicetree/bindings/clock/zynq-7000.txt        |   55 +++
 arch/arm/Kconfig                                   |    1 +
 arch/arm/Kconfig.debug                             |   17 +
 arch/arm/boot/dts/Makefile                         |    1 +
 arch/arm/boot/dts/zynq-7000.dtsi                   |  166 +++++++++
 arch/arm/boot/dts/zynq-ep107.dts                   |   63 ----
 arch/arm/boot/dts/zynq-zc702.dts                   |   44 +++
 arch/arm/mach-zynq/common.c                        |   33 ++-
 arch/arm/mach-zynq/common.h                        |    4 +-
 arch/arm/mach-zynq/include/mach/zynq_soc.h         |   16 +-
 arch/arm/mach-zynq/timer.c                         |  297 +++++++++-------
 drivers/clk/Makefile                               |    1 +
 drivers/clk/clk-zynq.c                             |  383 ++++++++++++++++++++
 include/linux/clk/zynq.h                           |   24 ++
 14 files changed, 899 insertions(+), 206 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/zynq-7000.txt
 create mode 100644 arch/arm/boot/dts/zynq-7000.dtsi
 delete mode 100644 arch/arm/boot/dts/zynq-ep107.dts
 create mode 100644 arch/arm/boot/dts/zynq-zc702.dts
 create mode 100644 drivers/clk/clk-zynq.c
 create mode 100644 include/linux/clk/zynq.h
