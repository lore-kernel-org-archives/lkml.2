Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933024Ab0JXVzQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 17:55:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51813
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932938Ab0JXVzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 17:55:14 -0400
Date: Sun, 24 Oct 2010 14:55:37 -0700 (PDT)
Message-Id: <20101024.145537.112602993.davem@davemloft.net>
To: masa-korg@dsn.okisemi.com
Cc: wg@grandegger.com, w.sang@pengutronix.de, chripell@fsfe.org,
        21cnbao@gmail.com, sameo@linux.intel.com,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        andrew.chih.howe.khor@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, morinaga526@dsn.okisemi.com,
        margie.foster@intel.com
Subject: Re: [PATCH net-next-2.6 v1] can: Topcliff: Update PCH_CAN driver
 to 2.6.35
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101024.144312.104048720.davem@davemloft.net>
References: <4CB8506C.3060600@dsn.okisemi.com>
	<20101024.144312.104048720.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please send a patch against the current driver which will fix these
build warnings that occur when CONFIG_PM is disabled:

drivers/net/can/pch_can.c:258:13: warning: 'pch_can_set_int_custom' defined but not used
drivers/net/can/pch_can.c:269:13: warning: 'pch_can_get_int_enables' defined but not used
drivers/net/can/pch_can.c:420:13: warning: 'pch_can_get_rx_enable' defined but not used
drivers/net/can/pch_can.c:438:13: warning: 'pch_can_get_tx_enable' defined but not used
drivers/net/can/pch_can.c:462:13: warning: 'pch_can_set_rx_buffer_link' defined but not used
drivers/net/can/pch_can.c:480:13: warning: 'pch_can_get_rx_buffer_link' defined but not used

Thank you.

