Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab2IJAjd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 20:39:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56782 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846Ab2IJAjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 20:39:32 -0400
Date: Mon, 10 Sep 2012 01:39:13 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Mike Turquette <mturquette@ti.com>,
        Greg Ungerer <gerg@uclinux.org>, Julia Lawall <julia.lawall@lip6.fr>,
        Artem Bityutskiy <dedekind1@gmail.com>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: Make the managed clk functions generically
	available
Message-ID: <20120910003913.GM13739@n2100.arm.linux.org.uk>
References: <1347202862-1617-1-git-send-email-lars@metafoo.de> <20120909235059.GA2643@sirena.org.uk> <20120910001524.GL13739@n2100.arm.linux.org.uk> <20120910002020.GB16249@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120910002020.GB16249@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 08:20:21AM +0800, Mark Brown wrote:
> On Mon, Sep 10, 2012 at 01:15:24AM +0100, Russell King - ARM Linux wrote:
> > Note that the patch system doesn't always return error messages anymore
> > (it used to do that reliably, but as it's now a favourite target for
> > spammers and was creating soo much backscatter, which was then filling
> > my mailbox with bounces... that had to change.)
> 
> Hrm, that's not ideal.  It'd be nice if it were able to do something
> like always reply if there were patch contents, or if it found things
> like the KernelVersion line in there.  Obviously e-mail is also not time
> guaranteed so deciding it's not responded (and then working out why it
> did that) is going to be unreliable too.

It tries to - if it finds what it thinks is a patch in the right place
in the email.  If it doesn't think it found a patch then it won't reply.
In other words, if you include a patch without a PATCH FOLLOWS or the ---
commit message/diffstat break marker preceding it, it will ignore you.

> I do recall seeing the patch in the database but it's not showing up any
> more so perhaps I was thinking of a different patch.

Well, no patch ever gets deleted from the database... the only way even I
can do that is to manually issue the SQL.

> OK, that's what I'd thought was going on - it was the fact that you'd
> just acked the patch rather than asked for it to go to the patch tracker
> or something which made me wonder if things had changed.

I kind'a forgot because it's been soo long since I took any of those
patches...
