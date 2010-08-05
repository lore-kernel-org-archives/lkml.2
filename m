Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934423Ab0HEVjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 17:39:05 -0400
Received: from cantor.suse.de ([195.135.220.2]:57638 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932988Ab0HEVjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 17:39:00 -0400
Date: Thu, 5 Aug 2010 14:38:51 -0700
From: Greg KH <gregkh@suse.de>
To: john stultz <johnstul@us.ibm.com>
Cc: Alexander Shishkin <virtuoso@slind.org>, lkml@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, John Kacur <jkacur@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] notify userspace about time changes
Message-ID: <20100805213851.GA13868@suse.de>
References: <1280926108-24668-1-git-send-email-virtuoso@slind.org>
 <1280937526.28884.21.camel@work-vm>
 <AANLkTin_5RVQo8qbJp=naN6WHdA39JM81Y+003E0SLOq@mail.gmail.com>
 <1281042665.3405.15.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281042665.3405.15.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 02:11:05PM -0700, john stultz wrote:
> On Thu, 2010-08-05 at 15:33 +0300, Alexander Shishkin wrote:
> > On 4 August 2010 18:58, john stultz <johnstul@us.ibm.com> wrote:
> > > Is there a actual use case that you need this for?  I don't really have
> > > an issue with the code I just really want to make sure the feature would
> > > be useful enough to justify the API and code maintenance going forward.
> > 
> > Yes. What we have here is an application which takes care of different means
> > of time synchronization (trusted time servers, different GSM operators, etc)
> > and also different kinds of time-based events/notifications (like "dentist
> > appointment next thursday"). When it encounters a time change that is
> > made by some other application, it basically wants to disable automatic
> > time adjustment and trigger the events/notifications which are due at this
> > (new) time.
> 
> Ok. Something specific is always more helpful then theoretical uses.
> 
> I think the filtering is still a bit controversial, so you might want to
> respin it without that. But otherwise I'm ok with it as long as no one
> else objects to any of the minor details of the interface 
> 
> GregKH: Does /sys/kernel/time_notify seem ok by you?

Um, it depends, what is that file going to do?  I don't see a
Documentation/ABI/ entry here that describes it fully :)

thanks,

greg k-h
