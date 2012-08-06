Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199Ab2HFP6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 11:58:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41931 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756396Ab2HFP6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 11:58:08 -0400
Date: Mon, 6 Aug 2012 16:58:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: sameo@linux.intel.com, rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org, Bergmann Arnd <arnd@arndb.de>,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH 0/5] mfd: replace IORESOURCE_IO by IORESOURCE_MEM
Message-ID: <20120806155805.GR16861@opensource.wolfsonmicro.com>
References: <1344184373-9670-1-git-send-email-haojian.zhuang@gmail.com>
 <20120806143016.GK16861@opensource.wolfsonmicro.com>
 <CAN1soZwCr=L3Xdi7HS9dQMxo4DzzbQv2kXo9R_U6QAf7v=B10Q@mail.gmail.com>
 <20120806154619.GO16861@opensource.wolfsonmicro.com>
 <CAN1soZzytOwxnS8oNMhFs1rfwVPwFnZoVsXeaMUc4Kf_TnunkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN1soZzytOwxnS8oNMhFs1rfwVPwFnZoVsXeaMUc4Kf_TnunkA@mail.gmail.com>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 11:56:47PM +0800, Haojian Zhuang wrote:
> On Mon, Aug 6, 2012 at 11:46 PM, Mark Brown

> > Right, but _MEM isn't terribly relevant either.  If anything _IO is a
> > bit better as ioports are *somewhat* similar to registers.

> The problem is that each bit is already used in 32-bit IORESOURCE. I can't
> find a empty bit to define the new IORESOURCE.

That's one reason why I've not attacked this problem myself, but frankly
I'm totally happy with using _IO here so I've not looked particularly
closely.
