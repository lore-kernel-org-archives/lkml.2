Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759664Ab0FJTBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 15:01:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41725 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759600Ab0FJTBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 15:01:39 -0400
Date: Thu, 10 Jun 2010 20:01:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Neil Brown <neilb@suse.de>, Felipe Contreras <felipe.contreras@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Brian Swetland <swetland@google.com>, Arve Hj?nnev?g <arve@android.com>,
       Arjan van de Ven <arjan@infradead.org>, tytso@mit.edu,
       Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] suspend blockers & Android integration
Message-ID: <20100610190136.GD17945@opensource.wolfsonmicro.com>
References: <20100603193045.GA7188@elte.hu> <201006101059.44411.rjw@sisk.pl> <20100610135714.GA27848@sirena.org.uk> <201006101746.47035.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006101746.47035.rjw@sisk.pl>
X-Cookie: Avoid gunfire in the bathroom tonight.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 05:46:46PM +0200, Rafael J. Wysocki wrote:
> On Thursday, June 10, 2010, Mark Brown wrote:
> > On Thu, Jun 10, 2010 at 10:59:43AM +0200, Rafael J. Wysocki wrote:

> > > So, for a phone-like system, where you'd generally want to simplify user space,
> > > having a "power manager" in the kernel seems to make sense to me.

> > I'm not clear where this requirement to simplify user space specifically
> > for phones comes from

> This isn't a requirement, but something that IMO is reasonable.

> > - phones do have pretty substantial software stacks that aren't that far away
> > to PCs.

> That doesn't seem to be relevant here.

Sure, that's my point - you seem to be suggesting that phones have a
different requirement here.
