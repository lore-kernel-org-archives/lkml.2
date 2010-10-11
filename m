Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab0JKSbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 14:31:51 -0400
Received: from kroah.org ([198.145.64.141]:39340 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755758Ab0JKSbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 14:31:50 -0400
Date: Mon, 11 Oct 2010 11:32:36 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: stable cc's in linux -next was Re: [BUG] x86: bootmem broken
	on SGI UV
Message-ID: <20101011183236.GA8704@kroah.com>
References: <AANLkTinyA=bSeSe7eavUb7fuSgM8m=QQFGqCrNtCGqKa@mail.gmail.com> <AANLkTikCHzaovYy+g8GBE7zwBOa-=pXk=WwQ_5ts1u5m@mail.gmail.com> <20101009235141.GB15564@kroah.com> <AANLkTikBGsO9wy3z-z6_pTKq0vrYme0fEhE8KcXj_Si3@mail.gmail.com> <20101011173141.GB7116@kroah.com> <AANLkTikKNHp85iHNunSnC6EJkS5P3M5-OEN3yzzFw_Q8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikKNHp85iHNunSnC6EJkS5P3M5-OEN3yzzFw_Q8@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 11:21:20AM -0700, Linus Torvalds wrote:
> On Mon, Oct 11, 2010 at 10:31 AM, Greg KH <greg@kroah.com> wrote:
> > Not that I'm trying to say, "it could be worse", just that, "what could
> > be done better?"
> 
> I really don't know. I suspect that a certain amount of problems are
> always going to be inevitable. It's not like you can avoid regressions
> entirely, at least not unless you take the "it's dead, Jim" approach
> to stable.

Yeah, I do feel I keep some of the stable trees around longer then I
should, I've been working to keep that from happening any more in the
future.

thanks,

greg k-h
