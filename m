Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab2KELJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 06:09:14 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44100 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab2KELJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 06:09:12 -0500
MIME-Version: 1.0
Date: Mon, 5 Nov 2012 12:09:10 +0100
X-Google-Sender-Auth: Q2zCks-dcvDm5mHL2X8S2Um9YPg
Message-ID: <CAHTX3dLdGie9gtxbPq_gb8BLao7YYohqQWZFg3LzyNHxu=imdg@mail.gmail.com>
Subject: [GIT PULL] arm-soc: Xilinx zynq changes for v3.8
From: Michal Simek <michal.simek@xilinx.com>
To: Arnd Bergmann <arnd@arndb.de>, arm@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Cc: Josh Cartwright <josh.cartwright@ni.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd and Olof,

please add these patches to your arm-soc trees. All these patches are
for xilinx zynq arm platform.
You shouldn't have any problem to merge it there are no conficts with v3.7-rc4.

Please let me know if you find out any problem.

Thanks,
Michal

The following changes since commit 8f0d8163b50e01f398b14bcd4dc039ac5ab18d64:
  Linus Torvalds (1):
        Linux 3.7-rc3

are available in the git repository at:

  git://git.xilinx.com/linux-xlnx.git arm-next

Josh Cartwright (4):
      zynq: use GIC device tree bindings
      zynq: use pl310 device tree bindings
      zynq: remove use of CLKDEV_LOOKUP
      zynq: move static peripheral mappings

 arch/arm/Kconfig                           |    1 -
 arch/arm/Makefile                          |    1 -
 arch/arm/boot/dts/zynq-ep107.dts           |   19 +++++++++++++---
 arch/arm/mach-zynq/common.c                |   23 ++++++++-----------
 arch/arm/mach-zynq/include/mach/clkdev.h   |   32 ----------------------------
 arch/arm/mach-zynq/include/mach/zynq_soc.h |   31 +++++++++++++--------------
 6 files changed, 40 insertions(+), 67 deletions(-)
 delete mode 100644 arch/arm/mach-zynq/include/mach/clkdev.h
