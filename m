Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294Ab0JVVcl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 17:32:41 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:54898 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757176Ab0JVVck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 17:32:40 -0400
X-IronPort-AV: E=Sophos;i="4.58,225,1286150400"; 
   d="scan'208";a="2484614"
Date: Fri, 22 Oct 2010 22:32:02 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Yinghai Lu <yinghai@kernel.org>,
        Gianluca Guida <gianluca.guida@citrix.com>
Subject: Re: [Xen-devel] Re: linux-next: manual merge of the xen tree with
 the tip tree
In-Reply-To: <4CC1DA58.8000606@goop.org>
Message-ID: <alpine.DEB.2.00.1010222153250.1407@kaball-desktop>
References: <20101022140335.c4a3a48f.sfr@canb.auug.org.au> <20101022080129.GA8474@elte.hu> <4CC1DA58.8000606@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Oct 2010, Jeremy Fitzhardinge wrote:
> > Crap like that is just _NOT_ acceptable, and you know that perfectly well - if you 
> > do this to arch/x86/ i'll be forced to ask for the Xen tree to be removed from 
> > linux-next and be done via the x86 tree again.
> 
> Hey, hey, hold your horses.  This is a wildly obsolete patch that we
> were discussing a few weeks ago, but Yinghai did a proper alternative
> for the memblock universe.
> 
> It was never in linux-next, and never intended to be.  I'm not sure why
> it has appeared in linux-next now; it isn't in my branch.  I wonder if
> it appeared in another Xen-related branch.  Let me investigate.

I think I merged in my tree a snapshot of Jeremy's upstream/xen that
apparently was not meant for upstream at all.
And I did that just to solve a trivial 5 lines conflict because my patch
series don't actually depend on any of Jeremy's patches.

I solved the problem taking the radical approach: I removed the
merge with upstream/xen altogether and also removed the commit that
conflicts with one of Jeremy's commits.
There shouldn't be any more conflicts now, and surely there shouldn't be
any more unwanted old commits.

I apologize for any problems caused but none of this was intentional.


