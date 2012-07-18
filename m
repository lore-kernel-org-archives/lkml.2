Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab2GRMH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 08:07:27 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:29668 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754173Ab2GRMHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 08:07:18 -0400
From: Roland Stigge <stigge@antcom.de>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com, aletes.xgr@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 0/4] ARM: LPC32xx specific updates for next, third set
Date: Wed, 18 Jul 2012 14:06:47 +0200
Message-Id: <1342613211-13190-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the third round of patches for mach-lpc32xx, for v3.6. This time,
patches from Alexandre, for PWM support and CPU ID.

If no objections surface, I'll provide pull requests for arm-soc branches
shortly.

Signed-off-by: Roland Stigge <stigge@antcom.de>

--
Alexandre Pereira da Silva (4):
 ARM: LPC32xx: Set system serial based on cpu unique id
 ARM: LPC32xx: Add PWM clock
 ARM: LPC32xx: Add PWM support
 ARM: LPC32xx: Add PWM to base dts file

 arch/arm/Kconfig               |    1 +
 arch/arm/boot/dts/lpc32xx.dtsi |   11 +++++++++++
 arch/arm/mach-lpc32xx/clock.c  |   14 ++++++++++++++
 arch/arm/mach-lpc32xx/common.c |   10 ++++++++--
 4 files changed, 34 insertions(+), 2 deletions(-)

