Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760229Ab0JZRvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 13:51:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55612
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760176Ab0JZRvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 13:51:43 -0400
Date: Tue, 26 Oct 2010 10:52:06 -0700 (PDT)
Message-Id: <20101026.105206.15244527.davem@davemloft.net>
To: tomoya-linux@dsn.okisemi.com
Cc: wg@grandegger.com, w.sang@pengutronix.de, chripell@fsfe.org,
        21cnbao@gmail.com, sameo@linux.intel.com,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        andrew.chih.howe.khor@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, morinaga526@dsn.okisemi.com,
        masa-korg@dsn.okisemi.com, margie.foster@intel.com
Subject: Re: [PATCH net-next-2.6 v2] can: Topcliff: PCH_CAN driver: Fix
 build warnings
From: David Miller <davem@davemloft.net>
In-Reply-To: <4CC61B1B.3090602@dsn.okisemi.com>
References: <4CC61B1B.3090602@dsn.okisemi.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomoya <tomoya-linux@dsn.okisemi.com>
Date: Tue, 26 Oct 2010 09:04:43 +0900

> Hi David,
> 
>> This patch has been corrupted by your email client.
> 
> Sorry, it seems my e-mail client setting was reset to default.

There are still problems.

This is beyond frustrating.

> index 55ec324..2889e11 100755

Why does the pch_can.c file have execute permission in your tree?
It doesn't in net-next-2.6 and that is what you should be generating
patches against.
