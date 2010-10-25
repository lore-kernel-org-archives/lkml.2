Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab0JYCHw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 22:07:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38423
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751407Ab0JYCHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 22:07:51 -0400
Date: Sun, 24 Oct 2010 19:08:14 -0700 (PDT)
Message-Id: <20101024.190814.193707678.davem@davemloft.net>
To: tomoya-linux@dsn.okisemi.com
Cc: wg@grandegger.com, w.sang@pengutronix.de, chripell@fsfe.org,
        21cnbao@gmail.com, sameo@linux.intel.com,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        andrew.chih.howe.khor@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, morinaga526@dsn.okisemi.com,
        masa-korg@dsn.okisemi.com, margie.foster@intel.com
Subject: Re: [PATCH net-next-2.6 v2] can: Topcliff: Update PCH_CAN driver
 to 2.6.36
From: David Miller <davem@davemloft.net>
In-Reply-To: <4CC4E32F.5000608@dsn.okisemi.com>
References: <4CC4E32F.5000608@dsn.okisemi.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomoya <tomoya-linux@dsn.okisemi.com>
Date: Mon, 25 Oct 2010 10:53:51 +0900

> Hi David,
> 
> I have modified for your indications.
>  - Warning issue when "CONFIG_PM" is disabled.

I said to send me a relative patch to your previous one.

I already added the driver to the tree, so sending me a complete
new patch adding the driver isn't going to work.
