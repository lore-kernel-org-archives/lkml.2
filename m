Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab1EWWld (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 18:41:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53873 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777Ab1EWWla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 18:41:30 -0400
Date: Mon, 23 May 2011 15:21:21 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, DRI <dri-devel@lists.freedesktop.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: (Short?) merge window reminder
Message-ID: <20110523222121.GD12777@suse.de>
References: <BANLkTi=PLuZhx1=rCfOtg=aOTuC1UbuPYg@mail.gmail.com>
 <20110523192056.GC23629@elte.hu>
 <BANLkTikdgM+kSvaEYuQkgCYJZELnvwfetg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikdgM+kSvaEYuQkgCYJZELnvwfetg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 01:33:48PM -0700, Linus Torvalds wrote:
> On Mon, May 23, 2011 at 12:20 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > I really hope there's also a voice that tells you to wait until .42 before
> > cutting 3.0.0! :-)
> 
> So I'm toying with 3.0 (and in that case, it really would be "3.0",
> not "3.0.0" - the stable team would get the third digit rather than
> the fourth one.

I like that, it would make things much easier for me to keep track of
stuff.

> But no, it wouldn't be for 42. Despite THHGTTG, I think "40" is a
> fairly nice round number.
> 
> There's also the timing issue - since we no longer do version numbers
> based on features, but based on time, just saying "we're about to
> start the third decade" works as well as any other excuse.

That sounds reasonable as well.

greg k-h
