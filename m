Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964795Ab2AEQhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 11:37:20 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54277 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932488Ab2AEQhS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 11:37:18 -0500
MIME-Version: 1.0
In-Reply-To: <20120105072217.7ce7943f@tlielax.poochiereds.net>
References: <CAHFgRy_AdA7iKzCwNvXiE3pR1dqdkuKPgT0soWjw8E_TcLjJtA@mail.gmail.com>
	<4EFAAFEF.6070503@linux.vnet.ibm.com>
	<201112282303.26978.rjw@sisk.pl>
	<20120105115330.GA29569@atrey.karlin.mff.cuni.cz>
	<3BA6B994-29A1-44E6-AF10-C9331F3BB521@gmail.com>
	<20120105072217.7ce7943f@tlielax.poochiereds.net>
Date: Thu, 5 Jan 2012 11:37:16 -0500
Message-ID: <CAHFgRy-rDsfuheS-MksgVE=Tw_Ma4JG71N-bYU9AraP7VtEYjw@mail.gmail.com>
Subject: Re: Freezing of tasks failed after 20.01 seconds in 3.2.0-rc4+ (Linus
 GIT af968e2)
From: Miles Lane <miles.lane@gmail.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 7:22 AM, Jeff Layton <jlayton@redhat.com> wrote:
> On Thu, 5 Jan 2012 07:11:21 -0500
> Miles Lane <miles.lane@gmail.com> wrote:
>
>>
>> On Jan 5, 2012, at 6:53 AM, Pavel Machek <pavel@ucw.cz> wrote:
>>
>> > Hi!
>> >>>
>> >>> Miles Lane (in CC) hit freezing failures in 3.2.0-rc4+ (Linus GIT af968e2)
>> >>> while trying to suspend the machine.
>> >>
>> >> Well, ext3 seems to be involved.  I don't see any problems with suspending
>> >> those kernels on my test machines, but I don't use ext3 on them any more.
>> >>
>> >> It would be good to rule out ext3 somehow.
>> >
>> > I still use ext3 here, and suspend works in recent kernels.
>> >
>> > Is it reproducible for Miles?
>>
>> It was a one time event, sorry.
>>
>> All the best.
>
> From looking at the stack traces, it really just looks like the ext3
> code was waiting for requests to come back from the underlying storage.
> I don't know ext3 that well, but could something have offlined the
> storage while these tasks were waiting for their requests to come back?
>
> Another hypothesis...could those requests require kthreads that got
> frozen while processing these requests?

FWIW, I only hit this one time.

    Miles
