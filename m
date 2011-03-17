Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab1CQUR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 16:17:26 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:50076 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755375Ab1CQURX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 16:17:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=K3BSTa83NmUylzIh2ZyuT0UgvWrgXbT54a+yDFmtJAMYAa1uuY3I7nAFBBGI7XSOTCxXYZs1VA8n1PDLVvSxSlTf6O7o2MnJF7I9iemgWicvJOEoAuziIIdeFCTkIVt1;
Date: Thu, 17 Mar 2011 13:17:21 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        devel@linuxdriverproject.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] STAGING patches for .39
Message-Id: <20110317131721.0c439788.rdunlap@xenotime.net>
In-Reply-To: <20110317200448.GA17827@kroah.com>
References: <20110316210300.GA3311@kroah.com>
	<AANLkTim13aZ0Mr5RrOeQizHGY3jhf97x8v9mznY8RqgE@mail.gmail.com>
	<20110317002818.GA19812@kroah.com>
	<AANLkTikEEDDFxZQtvV46JJRU1NAtiXh_N4onJ1jwKHaF@mail.gmail.com>
	<AANLkTinznDAXuxv8AU=tZpTq81f_S8vTyAqRMm=nfAKS@mail.gmail.com>
	<20110317015239.GB31754@kroah.com>
	<20110317020212.GA2115@kroah.com>
	<20110317125538.791c26d9.rdunlap@xenotime.net>
	<20110317200448.GA17827@kroah.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 173.50.240.230 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Mar 2011 13:04:48 -0700 Greg KH wrote:

> On Thu, Mar 17, 2011 at 12:55:38PM -0700, Randy Dunlap wrote:
> > On Wed, 16 Mar 2011 19:02:12 -0700 Greg KH wrote:
> > 
> > > On Wed, Mar 16, 2011 at 06:52:39PM -0700, Greg KH wrote:
> > > > On Wed, Mar 16, 2011 at 05:34:08PM -0700, Linus Torvalds wrote:
> > > > > On Wed, Mar 16, 2011 at 5:32 PM, Linus Torvalds
> > > > > <torvalds@linux-foundation.org> wrote:
> > > > > >
> > > > > > The one with inifinite errors was vt6655.
> > > > > 
> > > > > vt6656 had same/similar issues. In fact, maybe it's simply because I
> > > > > built both of them in, and get infinite "multiple definitions" because
> > > > > they are the same driver with small differences?
> > > > 
> > > > Ah, probably, if they are both built into the kernel that might happen
> > > > due to the global symbols in them.  Actually that's odd, Randy's usual
> > > > 'randconfig' tester usually catches these, I'll make the Kconfig files
> > > > force them to be modules to keep this from happening in the future.
> > > 
> > > Yes, that looks like the problem, as building them as modules in your
> > > tree right now works just fine.
> > > 
> > > This patch below should solve your build issue, let me know if it
> > > doesn't.
> > 
> > Thanks for the patch.  You had suggested 1-2 months ago that someone do
> > this, so I was waiting to see if someone would actually do it.
> 
> Ah, sorry about that, I forgot about it.
> 
> > I was hoping that a staging developer would do it (not the staging
> > maintainer).
> 
> Heh, well, these drivers are just "placeholders" as the "real" in-kernel
> drivers are being developed for this hardware, so I don't expect to see
> much, if any development happening on them.

oh well, rm -rf them then.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
