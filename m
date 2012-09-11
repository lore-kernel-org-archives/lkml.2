Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab2IKRvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 13:51:52 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58413 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab2IKRvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 13:51:51 -0400
Date: Tue, 11 Sep 2012 18:51:26 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Turquette <mturquette@ti.com>, Greg Ungerer <gerg@uclinux.org>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Artem Bityutskiy <dedekind1@gmail.com>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: Make the managed clk functions generically
	available
Message-ID: <20120911175125.GR13739@n2100.arm.linux.org.uk>
References: <1347202862-1617-1-git-send-email-lars@metafoo.de> <20120909235059.GA2643@sirena.org.uk> <20120910001524.GL13739@n2100.arm.linux.org.uk> <20120910002020.GB16249@opensource.wolfsonmicro.com> <20120910003913.GM13739@n2100.arm.linux.org.uk> <504F4E36.20309@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504F4E36.20309@metafoo.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 04:44:06PM +0200, Lars-Peter Clausen wrote:
> On 09/10/2012 02:39 AM, Russell King - ARM Linux wrote:
> > On Mon, Sep 10, 2012 at 08:20:21AM +0800, Mark Brown wrote:
> >>[...]
> >> OK, that's what I'd thought was going on - it was the fact that you'd
> >> just acked the patch rather than asked for it to go to the patch tracker
> >> or something which made me wonder if things had changed.
> > 
> > I kind'a forgot because it's been soo long since I took any of those
> > patches...
> 
> Ok, what's the plan? Should I add this patch to the patch tracker?

Yes please.
