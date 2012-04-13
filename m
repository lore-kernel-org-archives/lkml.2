Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab2DMROE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 13:14:04 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:50786 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab2DMROB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 13:14:01 -0400
Date: Fri, 13 Apr 2012 13:13:51 -0400 (EDT)
Message-Id: <20120413.131351.1360677415220330018.davem@davemloft.net>
To: lars@metafoo.de
Cc: linux-kernel@vger.kernel.org, juhosg@openwrt.org, frdrc66@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH 4/4] net: Remove redundant spi driver bus initialization
From: David Miller <davem@davemloft.net>
In-Reply-To: <1334091089-10138-4-git-send-email-lars@metafoo.de>
References: <1334091089-10138-1-git-send-email-lars@metafoo.de>
	<1334091089-10138-4-git-send-email-lars@metafoo.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 13 Apr 2012 10:13:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>
Date: Tue, 10 Apr 2012 22:51:29 +0200

> In ancient times it was necessary to manually initialize the bus field of an
> spi_driver to spi_bus_type. These days this is done in spi_driver_register() so
> we can drop the manual assignment.
> 
> The patch was generated using the following coccinelle semantic patch:
> // <smpl>
> @@
> identifier _driver;
> @@
> struct spi_driver _driver = {
> 	.driver = {
> -		.bus = &spi_bus_type,
> 	},
> };
> // </smpl>
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Applied to net-next, thanks.
