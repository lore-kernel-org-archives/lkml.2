Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab2INX4X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 19:56:23 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33387 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab2INX4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 19:56:21 -0400
Date: Sat, 15 Sep 2012 00:56:07 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, Nicolas Pitre <nico@linaro.org>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 24/24] net: seeq: use __iomem pointers for MMIO
Message-ID: <20120914235607.GF12245@n2100.arm.linux.org.uk>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de> <1347658492-11608-25-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347658492-11608-25-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 11:34:52PM +0200, Arnd Bergmann wrote:
> ARM is moving to stricter checks on readl/write functions,
> so we need to use the correct types everywhere.

Same comment as for eesox.  const void __iomem * is not a problem on
x86, so it should not be a problem on ARM.
