Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab2K2WVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 17:21:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39944 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868Ab2K2WVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 17:21:45 -0500
Date: Thu, 29 Nov 2012 14:21:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay@vrfy.org>,
        "Jan H." =?ISO-8859-1?Q?Sch=F6nherr?= <schnhrr@cs.tu-berlin.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 00/23] printk: refactoring
Message-Id: <20121129142143.22886573.akpm@linux-foundation.org>
In-Reply-To: <1354226895.1700.12.camel@joe-AO722>
References: <cover.1351135988.git.joe@perches.com>
	<1351864140.3537.1.camel@joe-AO722>
	<1352760850.18715.8.camel@joe-AO722>
	<20121112152621.eb14d7f0.akpm@linux-foundation.org>
	<1354226895.1700.12.camel@joe-AO722>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2012 14:08:15 -0800
Joe Perches <joe@perches.com> wrote:

> On Mon, 2012-11-12 at 15:26 -0800, Andrew Morton wrote:
> > On Mon, 12 Nov 2012 14:54:10 -0800
> > Joe Perches <joe@perches.com> wrote:
> > 
> > > On Fri, 2012-11-02 at 06:49 -0700, Joe Perches wrote:
> > > > On Wed, 2012-10-24 at 20:43 -0700, Joe Perches wrote:
> > > > > Make printk a bit more readable.
> > > > 
> > > > Andrew?  Are you going to apply this again for -next?
> > > 
> > > Andrew?  Any answer?
> > 
> > Backlogged, not lost.  Hopefully this week or next week.
> > 
> > I trust it has had more thorough compilation coverage testing
> > than v1?
> 
> Well, it's getting to be too late for this series.

Yeah sorry, stuff got in the way, then people patched printk.c.

> When would be the best time to resubmit and get this
> into -next?

I think at rc1.  Then if all is OK I'd aim at a merge for rc2 or rc3
because these patches are rather a pain to keep alive.

