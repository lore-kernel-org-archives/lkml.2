Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab2GDOX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 10:23:59 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:20191 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753410Ab2GDOX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 10:23:27 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Zynq ZC702 bringup
Date: Wed,  4 Jul 2012 10:13:32 -0400
Message-Id: <1341411215-3617-1-git-send-email-nbowler@elliptictech.com>
X-Mailer: git-send-email 1.7.8.6
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This short series allows use of the UART on the Zynq ZC702 for early
printk, and then fixes some problems that occur during early boot.

While a lot of things are still not working with this board, these
changes in addition to the GIC OF initialization patch posted last
month allow me to bring the system up to a busybox shell.

Nick Bowler (3):
  ARM: zynq: Allow UART1 to be used as DEBUG_LL console.
  ARM: zynq: Add compatible entry for the ZC702 board.
  ARM: zynq: Map DEBUG_LL UARTs in vmalloc space.

 arch/arm/Kconfig.debug                     |   17 +++++++++++++++++
 arch/arm/mach-zynq/common.c                |    5 +++--
 arch/arm/mach-zynq/include/mach/zynq_soc.h |   17 ++++++++++++-----
 3 files changed, 32 insertions(+), 7 deletions(-)

-- 
1.7.8.6


