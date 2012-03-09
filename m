Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab2CIRwn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 12:52:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:24611 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349Ab2CIRwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 12:52:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="136317449"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Feng Tang <feng.tang@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Subject: [PATCH 5/5] pch_uart: Add module parameter descriptions
Date: Fri,  9 Mar 2012 09:51:52 -0800
Message-Id: <9a91979402f0c57f607d1608432caff1199be164.1331315372.git.dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <ae0029b9e1131467232389e4dfa630f50e159de0.1331315372.git.dvhart@linux.intel.com>
References: <ae0029b9e1131467232389e4dfa630f50e159de0.1331315372.git.dvhart@linux.intel.com>
In-Reply-To: <cover.1331315372.git.dvhart@linux.intel.com>
References: <cover.1331315372.git.dvhart@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document default_baud and user_uartclk module parameters.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
CC: Tomoya MORINAGA <tomoya.rohm@gmail.com>
CC: Feng Tang <feng.tang@intel.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Alan Cox <alan@linux.intel.com>
CC: linux-serial@vger.kernel.org
---
 drivers/tty/serial/pch_uart.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index cca742b..332f2eb 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1864,4 +1864,8 @@ module_exit(pch_uart_module_exit);
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("Intel EG20T PCH UART PCI Driver");
 module_param(default_baud, uint, S_IRUGO);
+MODULE_PARM_DESC(default_baud,
+                 "Default BAUD for initial driver state and console (default 9600)");
 module_param(user_uartclk, uint, S_IRUGO);
+MODULE_PARM_DESC(user_uartclk,
+                 "Override UART default or board specific UART clock");
-- 
1.7.6.5

