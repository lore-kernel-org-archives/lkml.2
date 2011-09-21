Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab1IUCz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 22:55:59 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44245 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab1IUCz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 22:55:58 -0400
Date: Tue, 20 Sep 2011 19:55:45 -0700
From: Kent Overstreet <kent.overstreet@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, rdunlap@xenotime.net, axboe@kernel.dk,
        akpm@linux-foundation.org, neilb@suse.de
Subject: Re: [GIT] Bcache version 12
Message-ID: <20110921025545.GB5521@moria>
References: <20110910064531.GA32536@moria>
 <CAOJsxLFPODubVEB3Tjg54C7jDKM8H-RCM_u5kvO1D0kKyjUYXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLFPODubVEB3Tjg54C7jDKM8H-RCM_u5kvO1D0kKyjUYXQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 10:28:03AM +0300, Pekka Enberg wrote:
> Hi Kent,
> 
> On Sat, Sep 10, 2011 at 9:45 AM, Kent Overstreet
> <kent.overstreet@gmail.com> wrote:
> > bcache, n.: a cache for arbitrary block devices that uses an SSD
> >
> > It's probably past time I started poking people to see about getting
> > this stuff in. It's synced up with mainline, the documentation is for
> > once relatively up to date, and it looks just about production ready.
> >
> > Suggestions are more than welcome on how to make it easier to review -
> > it's entirely too much code, I know (near 10k lines now). I'll be
> > emailing the patches that touch other parts of the kernel separately.
> >
> > Short overview:
> > Bcache does both writethrough and writeback caching. It presents itself
> > as a new block device, a bit like say md. You can cache an arbitrary
> > number of block devices with a single cache device, and attach and
> > detach things at runtime - it's quite flexible.
> 
> The changelog is pretty useless for people like myself who have never
> heard of bcache before because it lacks any explanation why bcache is
> useful (i.e. a real-world use case).
> 
>                         Pekka

Well, I think you'll want the documentation for that -
Documentation/bcache.txt is somewhat up to date and should answer that
decently.

Short version: bcache is for making IO faster.
