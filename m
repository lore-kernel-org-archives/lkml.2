Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020Ab0JXVmv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 17:42:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40340
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932938Ab0JXVmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 17:42:49 -0400
Date: Sun, 24 Oct 2010 14:43:12 -0700 (PDT)
Message-Id: <20101024.144312.104048720.davem@davemloft.net>
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
In-Reply-To: <4CB8506C.3060600@dsn.okisemi.com>
References: <4CB8506C.3060600@dsn.okisemi.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
Date: Fri, 15 Oct 2010 22:00:28 +0900

> CAN driver of Topcliff PCH
> 
> Topcliff PCH is the platform controller hub that is going to be used in
> Intel's upcoming general embedded platform. All IO peripherals in
> Topcliff PCH are actually devices sitting on AMBA bus. 
> Topcliff PCH has CAN I/F. This driver enables CAN function.
> 
> Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>

Applied, thanks.
