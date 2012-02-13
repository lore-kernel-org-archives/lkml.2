Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab2BMWvt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 17:51:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754809Ab2BMWvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 17:51:33 -0500
Date: Mon, 13 Feb 2012 17:51:15 -0500
From: Don Zickus <dzickus@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        torvalds@linux-foundation.org, kexec@lists.infradead.org,
        vgoyal@redhat.com, ebiederm@xmission.com, akpm@linux-foundation.org,
        tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/debug] x86/kdump: No need to disable ioapic/ lapic in
 crash path
Message-ID: <20120213225115.GT9751@redhat.com>
References: <tip-d9bc9be89629445758670220787683e37c93f6c1@git.kernel.org>
 <CAE9FiQWRjvu_uNcx_bJXYHeg4D4k6YzHHmSudsq7EyubLi7+nw@mail.gmail.com>
 <20120213152808.GD9751@redhat.com>
 <CAE9FiQXX7BXKuVHZ9NRCEmeTnPj4zVJL5gf5eSp6b+4e3jN3EA@mail.gmail.com>
 <20120213221258.GP9751@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120213221258.GP9751@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 05:12:58PM -0500, Don Zickus wrote:
> On Mon, Feb 13, 2012 at 08:52:19AM -0800, Yinghai Lu wrote:
> > On Mon, Feb 13, 2012 at 7:28 AM, Don Zickus <dzickus@redhat.com> wrote:
> > > On Sat, Feb 11, 2012 at 05:04:15PM -0800, Yinghai Lu wrote:
> > >> >
> > >> > v2: removed the disable lapic code too
> > >>
> > >> with this commit, kdump is not working anymore on my setups with
> > >> Nehalem, Westmere, sandbridge.
> > >> these setup all have VT-d enabled.
> > >
> > > Hi Yinghai,
> > >
> > > Thanks for the report.  Can you attach the .config you were using and what
> > > vendor you were using for Nehalem, Westmere and Sandybridge.  I'll try to
> > > reproduce it in my lab.
> > 
> > Sure, please check attached one
> 
> Looks like I can reproduce the hang with my original patch and things work
> when we stick the disable_local_APIC() back in there.  I'll keep poking.

Hmm, my config worked fine in both cases, hence why I didn't catch it (its
based on a bloated Fedora config).  I'll look at the differences to see if
something pops out.

Cheers,
Don
