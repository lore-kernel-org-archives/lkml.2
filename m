Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab2AWNSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 08:18:08 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63734 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab2AWNSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 08:18:07 -0500
Date: Mon, 23 Jan 2012 06:18:08 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Ohad Ben-Cohen <ohad@wizery.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tony Lindgren <tony@atomide.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Brian Swetland <swetland@google.com>
Subject: Re: Linux 3.3-1 out - merge window closed
Message-ID: <20120123131808.GC23571@ponder.secretlab.ca>
References: <CA+55aFwWEhobGDzkuRoXaS37y3tMU41ExhiR+vCa68cUNRehKg@mail.gmail.com>
 <CADMYwHxhyExw8jzAVT6PEdfXT-vCSLxg_eGbbqCwRNh0q3Q6eQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CADMYwHxhyExw8jzAVT6PEdfXT-vCSLxg_eGbbqCwRNh0q3Q6eQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 11:17:46AM +0200, Ohad Ben-Cohen wrote:
> Hi Linus,
> 
> On Fri, Jan 20, 2012 at 1:58 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > There are a couple of trees I haven't merged on purpose, and there may
> > be a few trees I overlooked by mistake. The "on purpose" ones were
> > things that looked unfamiliar and I felt I didn't have the bandwidth
> > to check. The "mistake" ones would just be things I missed due to
> > being busy.
> 
> I guess that the remoteproc/rpmsg tree belongs to the "on purpose" department :)
> 
> > So if you felt that your pull request was overlooked by mistake (or
> > intentionally, but really not so scary that you think I should have a
> > really easy time checking it), you have a couple of days to marshal
> > your arguments for why I should pull it after all.
> 
> I realize there's a slim chance to get it merged at this point, but I
> do think that both remoteproc and rpmsg are not so scary:
> 
> * The code is completely self contained, and the only few external
> places it changes amount to grabbing a new virtio id (which is
> Acked-by Rusty) and some OMAP init platform code (which is Acked-by
> Tony). People who aren't explicitly using it won't notice it's there;
> even its Kconfig entries get selected automatically when relevant
> (i.e. only on OMAP4 at this point) and would never show up otherwise.

Hi Linus,

I'd also like to see this merged.  Rather than going off and inventing
something completely new, Ohad has built on the existing virtio
infrastructure to implement IPC between CPUs and DSPs running
different operating environments.  This is a strong step in the
RightDirection(tm) in my opinion and such behaviour should be
encouraged.  :-)

g.

