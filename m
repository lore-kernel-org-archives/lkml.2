Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750877Ab2IOEBD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 00:01:03 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34601 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab2IOEBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 00:01:01 -0400
Date: Sat, 15 Sep 2012 00:00:59 -0400 (EDT)
Message-Id: <20120915.000059.636218745264773259.davem@davemloft.net>
To: linux@arm.linux.org.uk
Cc: arnd@arndb.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, will.deacon@arm.com, nico@linaro.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 24/24] net: seeq: use __iomem pointers for MMIO
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120914235607.GF12245@n2100.arm.linux.org.uk>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
	<1347658492-11608-25-git-send-email-arnd@arndb.de>
	<20120914235607.GF12245@n2100.arm.linux.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date: Sat, 15 Sep 2012 00:56:07 +0100

> On Fri, Sep 14, 2012 at 11:34:52PM +0200, Arnd Bergmann wrote:
>> ARM is moving to stricter checks on readl/write functions,
>> so we need to use the correct types everywhere.
> 
> Same comment as for eesox.  const void __iomem * is not a problem on
> x86, so it should not be a problem on ARM.

Agreed.
