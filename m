Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab1KCBc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:32:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50230 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164Ab1KCBcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:32:17 -0400
Date: Wed, 2 Nov 2011 18:30:12 -0700
From: Greg KH <gregkh@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, miche@google.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        virtualization@lists.linux-foundation.org,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Amit Shah <amit.shah@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: Regression: patch " hvc_console: display printk messages on
 console." causing infinite loop with 3.2-rc0 + Xen.
Message-ID: <20111103013012.GB3449@suse.de>
References: <20111027053007.GA32765@phenom.dumpdata.com>
 <20111027054806.GA1377@suse.de>
 <20111102121309.4dbb0d2ac90d2879130820dd@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111102121309.4dbb0d2ac90d2879130820dd@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 12:13:09PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Thu, 27 Oct 2011 07:48:06 +0200 Greg KH <gregkh@suse.de> wrote:
> >
> > On Thu, Oct 27, 2011 at 01:30:08AM -0400, Konrad Rzeszutek Wilk wrote:
> > > Hey Miche.
> > > 
> > > The git commit 361162459f62dc0826b82c9690a741a940f457f0:
> > > 
> > >     hvc_console: display printk messages on console.
> > > 
> > > is causing an infinite loop when booting Linux under Xen, as so:
> > 
> > Ick, not good, thanks for letting us know.
> 
> Indeed. I am wondering why it was put in a tree and sent to Linus without
> any Acks or even being replied to by anyone.  It appeared in the tty tree
> between Oct 14 and Oct 25 (while I was unfortunately on vacation).  If
> anyone had tried to boot this on any PowerPC server, it would have been
> immediately obvious (as it was when I booted Linus' tree last night).
> 
> And the original author expressed doubts as to his understanding of how
> it should all work anyway.
> 
> Just a little more care, please.
> 
> I would vote for reverting the original and having it resubmitted with
> corrections at some later date.

You are right, I will go do that, sorry for the problems.

greg k-h
