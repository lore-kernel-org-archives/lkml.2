Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831Ab0HEWSL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:18:11 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:59510 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab0HEWSJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:18:09 -0400
MIME-Version: 1.0
In-Reply-To: <1281042665.3405.15.camel@localhost.localdomain>
References: <1280926108-24668-1-git-send-email-virtuoso@slind.org> 
	<1280937526.28884.21.camel@work-vm> <AANLkTin_5RVQo8qbJp=naN6WHdA39JM81Y+003E0SLOq@mail.gmail.com> 
	<1281042665.3405.15.camel@localhost.localdomain>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 6 Aug 2010 00:17:52 +0200
Message-ID: <AANLkTi=Gxk7FwmyCqNwXQEg7OsvDh4p2Mg3Fhiy1g5pv@mail.gmail.com>
Subject: Re: [PATCH] [RFC] notify userspace about time changes
To: john stultz <johnstul@us.ibm.com>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 5, 2010 at 23:11, john stultz <johnstul@us.ibm.com> wrote:
> On Thu, 2010-08-05 at 15:33 +0300, Alexander Shishkin wrote:
>> On 4 August 2010 18:58, john stultz <johnstul@us.ibm.com> wrote:
>> > Is there a actual use case that you need this for?  I don't really have
>> > an issue with the code I just really want to make sure the feature would
>> > be useful enough to justify the API and code maintenance going forward.

Basically everything that schedules an action based on an absolute
time specification, like at 3pm today, and not in 3 hours from now,
needs to track such system time changes. Otherwise it has to do
nonsense like cron does, to wake up every minute to check the current
time.

Kay
