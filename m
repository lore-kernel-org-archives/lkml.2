Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933844Ab0HEWfd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:35:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39869 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760877Ab0HEWfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:35:11 -0400
Message-ID: <4C5B3C65.8060703@zytor.com>
Date: Thu, 05 Aug 2010 15:34:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Greg KH <gregkh@suse.de>, john stultz <johnstul@us.ibm.com>,
        Alexander Shishkin <virtuoso@slind.org>, lkml@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        John Kacur <jkacur@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] notify userspace about time changes
References: <1280926108-24668-1-git-send-email-virtuoso@slind.org> 	<1280937526.28884.21.camel@work-vm> <AANLkTin_5RVQo8qbJp=naN6WHdA39JM81Y+003E0SLOq@mail.gmail.com> 	<1281042665.3405.15.camel@localhost.localdomain> <20100805213851.GA13868@suse.de> <AANLkTimYmtXZe1Ue-z2D_5512RXz3xUSRWPiUUUY6rrz@mail.gmail.com>
In-Reply-To: <AANLkTimYmtXZe1Ue-z2D_5512RXz3xUSRWPiUUUY6rrz@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2010 03:22 PM, Kay Sievers wrote:
> 
> I think that's really awkward interface, to pass file descriptor
> numbers around and write them to magic sysfs files.
> 
> I would very much prefer a file that contains the current time, and
> wakes up possible users with a POLL_ERR on changes caused by some
> other process. That works very well for things like /proc/mounts, is
> easy to get, and does not need a full page of weird instructions to
> get stuff done. :)
> 

Okay, what's wrong with having a file descriptor that gets *written to*
on a notification?  Why POLL_ERR?

	-hpa
