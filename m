Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751107Ab1ARMV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 07:21:26 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36797 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab1ARMV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 07:21:26 -0500
Date: Tue, 18 Jan 2011 12:21:16 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Ben Herrenchmidt <benh@kernel.crashing.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 1/2] Add a common struct clk
Message-ID: <20110118122116.GD9719@n2100.arm.linux.org.uk>
References: <1294199462.347935.472473715866.0.gpush@pororo> <1294199462.348449.192344022926.1.gpush@pororo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294199462.348449.192344022926.1.gpush@pororo>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 11:51:02AM +0800, Jeremy Kerr wrote:
> ---
>  arch/Kconfig        |    3 
>  include/linux/clk.h |  164 +++++++++++++++++++++++++++++++++++++++++---
>  kernel/Makefile     |    1 
>  kernel/clk.c        |  102 +++++++++++++++++++++++++++
>  4 files changed, 261 insertions(+), 9 deletions(-)

As we already have drivers/clk/, does it really make sense to spread this
far and wide around the kernel tree by putting it in kernel/ ?
