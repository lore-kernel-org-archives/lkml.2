Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760936Ab0HEWbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:31:42 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:43332 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757485Ab0HEWan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:30:43 -0400
Subject: Re: [PATCH] [RFC] notify userspace about time changes
From: john stultz <johnstul@us.ibm.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alexander Shishkin <virtuoso@slind.org>, gregkh@suse.de,
        lkml@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, John Kacur <jkacur@redhat.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1281047390.3405.22.camel@localhost.localdomain>
References: <1280926108-24668-1-git-send-email-virtuoso@slind.org>
	 <1280937526.28884.21.camel@work-vm>
	 <AANLkTin_5RVQo8qbJp=naN6WHdA39JM81Y+003E0SLOq@mail.gmail.com>
	 <1281042665.3405.15.camel@localhost.localdomain>
	 <AANLkTi=Gxk7FwmyCqNwXQEg7OsvDh4p2Mg3Fhiy1g5pv@mail.gmail.com>
	 <1281047390.3405.22.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 15:30:30 -0700
Message-ID: <1281047430.3405.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-05 at 15:29 -0700, john stultz wrote:
> On Fri, 2010-08-06 at 00:17 +0200, Kay Sievers wrote:
> > On Thu, Aug 5, 2010 at 23:11, john stultz <johnstul@us.ibm.com> wrote:
> > > On Thu, 2010-08-05 at 15:33 +0300, Alexander Shishkin wrote:
> > >> On 4 August 2010 18:58, john stultz <johnstul@us.ibm.com> wrote:
> > >> > Is there a actual use case that you need this for?  I don't really have
> > >> > an issue with the code I just really want to make sure the feature would
> > >> > be useful enough to justify the API and code maintenance going forward.
> > 
> > Basically everything that schedules an action based on an absolute
> > time specification, like at 3pm today, and not in 3 hours from now,
> > needs to track such system time changes. Otherwise it has to do
> > nonsense like cron does, to wake up every minute to check the current
> > time.
> 
> time_create(CLOCK_REALTIME,...) creates absolute (not relative) timers

Sorry, *timer_create*.

thanks
-john


