Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab2HPCQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 22:16:48 -0400
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:56724 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751235Ab2HPCQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 22:16:47 -0400
From: Chao Xie <xiechao.mail@gmail.com>
To: haojian.zhuang@gmail.com, mturquette@linaro.org, viresh.linux@gmail.com,
        s.hauer@pengutronix.de, chao.xie@marvell.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.or,
        arnd@arndb.de
Subject: [PATCH V2 0/5] clk: mmp: add clock framework for mmp
Date: Thu, 16 Aug 2012 10:20:20 +0800
Message-Id: <1345083625-3041-1-git-send-email-xiechao.mail@gmail.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 16 Aug 2012 02:16:33.0298 (UTC) FILETIME=[27C08F20:01CD7B55]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chao Xie <chao.xie@marvell.com>

v1->v2:
replace __raw_xxx with xxx_relax
use ioremap to remap the registers. Finaly it will use device tree to
get the physical address.
do not use macro to register clocks, and directly call the functions.

Chao Xie (5):
  clk: mmp: add mmp specific clocks
  clk: mmp: add clock definition for pxa168
  clk: mmp: add clock definition for pxa910
  clk: mmp: add clock definition for mmp2
  arm: mmp: make all SOCs use common clock by default

 arch/arm/mach-mmp/Kconfig    |    3 +
 drivers/clk/Makefile         |    3 +
 drivers/clk/mmp/Makefile     |    9 +
 drivers/clk/mmp/clk-apbc.c   |  152 ++++++++++++
 drivers/clk/mmp/clk-apmu.c   |   97 ++++++++
 drivers/clk/mmp/clk-frac.c   |  153 ++++++++++++
 drivers/clk/mmp/clk-mmp2.c   |  544 ++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/mmp/clk-pxa168.c |  414 ++++++++++++++++++++++++++++++++
 drivers/clk/mmp/clk-pxa910.c |  361 ++++++++++++++++++++++++++++
 drivers/clk/mmp/clk.h        |   35 +++
 10 files changed, 1771 insertions(+), 0 deletions(-)
 create mode 100644 drivers/clk/mmp/Makefile
 create mode 100644 drivers/clk/mmp/clk-apbc.c
 create mode 100644 drivers/clk/mmp/clk-apmu.c
 create mode 100644 drivers/clk/mmp/clk-frac.c
 create mode 100644 drivers/clk/mmp/clk-mmp2.c
 create mode 100644 drivers/clk/mmp/clk-pxa168.c
 create mode 100644 drivers/clk/mmp/clk-pxa910.c
 create mode 100644 drivers/clk/mmp/clk.h

