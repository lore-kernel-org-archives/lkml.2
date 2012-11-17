Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776Ab2KQNyy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 08:54:54 -0500
Received: from londo.lunn.ch ([80.238.139.98]:37271 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585Ab2KQNyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 08:54:53 -0500
Date: Sat, 17 Nov 2012 14:54:35 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Andrew Lunn <andrew@lunn.ch>, linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] clk: mvebu: armada 370/XP add clock gating control
 provider for DT
Message-ID: <20121117135435.GA13479@lunn.ch>
References: <1353014906-31566-6-git-send-email-andrew@lunn.ch>
 <1353088920-17458-1-git-send-email-gregory.clement@free-electrons.com>
 <1353088920-17458-2-git-send-email-gregory.clement@free-electrons.com>
 <20121117082602.GF24569@lunn.ch>
 <50A75BB4.4070003@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A75BB4.4070003@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > What is the ddr clock for? Does bad things happen if you turn it off?
> > Kirkwood has a similar clock, dunit, which i decided not to export,
> > since when you turn it off, the whole SoC locks up.
> 
> Well of course if you code run in DDR then it could be a problem. But
> I think it could be useful to turn it off when going to suspend, it
> the DDR can do self-refresh. In this case it should be possible to run
> the code from SRAM or L2 Cache.

O.K. Just watch out for the lateinit call in the clock framework.

     Andrew
