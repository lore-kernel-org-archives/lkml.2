Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab1JXXRZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 19:17:25 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:36361 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752660Ab1JXXRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 19:17:24 -0400
Message-ID: <1319498243.2094.9.camel@Joe-Laptop>
Subject: Re: [PATCH] SCSI, pmcraid: Fix kmalloc() argument order in
 pmcraid_chr_ioctl()
From: Joe Perches <joe@perches.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 24 Oct 2011 16:17:23 -0700
In-Reply-To: <alpine.LNX.2.00.1110250047430.19795@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1110250036370.19795@swampdragon.chaosbits.net>
	 <1319496149.2094.3.camel@Joe-Laptop>
	 <alpine.LNX.2.00.1110250047430.19795@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-25 at 00:51 +0200, Jesper Juhl wrote:
> On Mon, 24 Oct 2011, Joe Perches wrote:
> > On Tue, 2011-10-25 at 00:38 +0200, Jesper Juhl wrote:
> > > The first argument to kmalloc() is the size, the second is
> > > flags. pmcraid_chr_ioctl() gets this wrong and swaps the
> > > arguments. This patch corrects the mistake.
[]
> > James seems to be uninterested in picking up
> > obvious and trivially correct patches.
> I've been getting that impression as well..
> For example: 
> http://git.kernel.org/?p=linux/kernel/git/next/linux-next-history.git;a=commitdiff;h=2abe1b25e56b7c8e65f101fb22282dafeb5ec4ef 
> which I've been sumbitting numerous times over a long period of time 
> (these days akpm has picked it up and sends it on repeatedly, so I don't 
> really bother myself any more)... 
> > >From a year ago...
> > https://lkml.org/lkml/2010/10/31/123
> Ok, so you obviously got there first

That doesn't matter at all to me.

What matters is getting the defects fixed
and not dropping patches on the floor.

Maybe that means there should be a different
or an additional scsi maintainer.

