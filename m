Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab2KPSCW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 13:02:22 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:46042 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab2KPSCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 13:02:21 -0500
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: [PATCH 0/2] Add clock gating support for Armada 370/XP
Date: Fri, 16 Nov 2012 19:01:58 +0100
Message-Id: <1353088920-17458-1-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353014906-31566-6-git-send-email-andrew@lunn.ch>
References: <1353014906-31566-6-git-send-email-andrew@lunn.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

With this 2 patches I added clock gating support for Armada 370 and
Armada XP. I compiled and tested on the boards, and managed to see the
new clock using debugfs.

Feel free to squash them in your series if you want.

Regards,

Gregory CLEMENT (2):
  clk: mvebu: armada 370/XP add clock gating control provider for DT
  arm: mvebu: armada 370/XP adding clock gating support: dt binding

 .../bindings/clock/mvebu-gated-clock.txt           |   43 ++++++++++++++
 arch/arm/boot/dts/armada-370.dtsi                  |    8 +++
 arch/arm/boot/dts/armada-xp.dtsi                   |    7 +++
 arch/arm/mach-mvebu/Kconfig                        |    1 +
 drivers/clk/mvebu/clk-gating-ctrl.c                |   61 ++++++++++++++++++++
 5 files changed, 120 insertions(+)

-- 
1.7.9.5

