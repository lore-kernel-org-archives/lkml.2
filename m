Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab2JRJ3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 05:29:13 -0400
Received: from us02smtp1.synopsys.com ([198.182.60.75]:37229 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678Ab2JRJ3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 05:29:12 -0400
From: Mischa Jonker <mischa.jonker@synopsys.com>
To: dmitry.torokhov@gmail.com, m.d.s.x.jonker@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        arc-linux-dev@synopsys.com
Cc: Mischa Jonker <mischa.jonker@synopsys.com>
Subject: [PATCH v4 0/1] Input: serio - Add ARC PS/2 driver
Date: Thu, 18 Oct 2012 11:28:57 +0200
Message-Id: <1350552538-24343-1-git-send-email-mischa.jonker@synopsys.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

main changes for v4:
* add timeout for arc_ps2_check_rx() in case of
  non responding hardware

main changes for v3:
* proper __iomem annotation
* correct return values in case of error

main changes for v2:
* dev_* instead of pr_*
* ioread32/iowrite32 instead of inl/outl
* use module_platform_driver macro
* disabling interrupt twice was unnecessary

New patch has been tested on our own architecture (ARC) and
builds cleanly on x86-64.

Mischa Jonker (1):
  Input: serio - Add ARC PS/2 driver

 drivers/input/serio/Kconfig   |    9 ++
 drivers/input/serio/Makefile  |    1 +
 drivers/input/serio/arc_ps2.c |  275 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 285 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/serio/arc_ps2.c

