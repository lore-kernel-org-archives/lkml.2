Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138Ab0LBVRD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 16:17:03 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51503
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757599Ab0LBVRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 16:17:02 -0500
Date: Thu, 02 Dec 2010 13:17:28 -0800 (PST)
Message-Id: <20101202.131728.245392719.davem@davemloft.net>
To: tomoya-linux@dsn.okisemi.com
Cc: wg@grandegger.com, w.sang@pengutronix.de, chripell@fsfe.org,
        21cnbao@gmail.com, sameo@linux.intel.com,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        andrew.chih.howe.khor@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, margie.foster@intel.com
Subject: Re: [PATCH net-next-2.6 v6 06/20] can: EG20T PCH: Fix endianness
 issue
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101202.131551.179934201.davem@davemloft.net>
References: <4CF47BAA.2090209@dsn.okisemi.com>
	<20101202.131551.179934201.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Thu, 02 Dec 2010 13:15:51 -0800 (PST)

> 
> This patch and the rest I cannot apply because they have
> dependencies upon patch #4 which I've stated is not
> implemented correctly.

Also please make sure that you add proper CONFIG_PM checks to your
driver in order to fix these warnings:

drivers/net/can/pch_can.c:249:13: warning: 'pch_can_set_int_custom' defined but not used
drivers/net/can/pch_can.c:260:13: warning: 'pch_can_get_int_enables' defined but not used
drivers/net/can/pch_can.c:363:12: warning: 'pch_can_get_rxtx_ir' defined but not used
drivers/net/can/pch_can.c:393:13: warning: 'pch_can_set_rx_buffer_link' defined but not used
drivers/net/can/pch_can.c:413:13: warning: 'pch_can_get_rx_buffer_link' defined but not used

Thanks.
d
