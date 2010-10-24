Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933071Ab0JXWIn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 18:08:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43901
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933047Ab0JXWIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 18:08:42 -0400
Date: Sun, 24 Oct 2010 15:09:05 -0700 (PDT)
Message-Id: <20101024.150905.39179588.davem@davemloft.net>
To: mkl@pengutronix.de
Cc: masa-korg@dsn.okisemi.com, andrew.chih.howe.khor@intel.com,
        sameo@linux.intel.com, margie.foster@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, socketcan-core@lists.berlios.de,
        kok.howg.ewe@intel.com, wg@grandegger.com, morinaga526@dsn.okisemi.com,
        joel.clark@intel.com, yong.y.wang@intel.com, chripell@fsfe.org,
        qi.wang@intel.com
Subject: Re: [PATCH net-next-2.6 v1] can: Topcliff: Update PCH_CAN driver
 to 2.6.35
From: David Miller <davem@davemloft.net>
In-Reply-To: <4CC4ADA5.8@pengutronix.de>
References: <4CB8506C.3060600@dsn.okisemi.com>
	<20101024.144312.104048720.davem@davemloft.net>
	<4CC4ADA5.8@pengutronix.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>
Date: Mon, 25 Oct 2010 00:05:25 +0200

> On 10/24/2010 11:43 PM, David Miller wrote:
>> From: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
>> Date: Fri, 15 Oct 2010 22:00:28 +0900
>> 
>>> CAN driver of Topcliff PCH
>>>
>>> Topcliff PCH is the platform controller hub that is going to be used in
>>> Intel's upcoming general embedded platform. All IO peripherals in
>>> Topcliff PCH are actually devices sitting on AMBA bus. 
>>> Topcliff PCH has CAN I/F. This driver enables CAN function.
>>>
>>> Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
>> 
>> Applied, thanks.
> 
> IMHO this driver needs some improvements. There are some open points
> from Wolfgangs and my review. On the other side, it's a new driver and
> there's some time left before it hits mainline.

When people have more than a week to review and provide feedback,
and don't, I have zero sympathy especially this early in the
release cycle.

So if adding it to the tree is what I have to do to get you guys to
post your comments and suggest fixes, then that's what I am going to
(continue) to do. :-)

