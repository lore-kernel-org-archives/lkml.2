Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab0LQMXB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 07:23:01 -0500
Received: from casper.infradead.org ([85.118.1.10]:56083 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913Ab0LQMW7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 07:22:59 -0500
Subject: Re: [PATCH -mm -v8 0/3] Lockless memory allocator and list
From: Peter Zijlstra <peterz@infradead.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@alien8.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Dirk Hohndel <Dirk.Hohndel@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Brown,Len" <len.brown@intel.com>, "Luck,Tony" <tony.luck@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <1292545232.12648.1236.camel@yhuang-dev>
References: <1292482744-12953-1-git-send-email-ying.huang@intel.com>
	 <1292491467.6803.4327.camel@twins> <1292545232.12648.1236.camel@yhuang-dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 17 Dec 2010 13:22:35 +0100
Message-ID: <1292588555.2266.165.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-17 at 08:20 +0800, Huang Ying wrote:
> On Thu, 2010-12-16 at 17:24 +0800, Peter Zijlstra wrote:
> > On Thu, 2010-12-16 at 14:59 +0800, Huang Ying wrote:
> > > This patchset adds a lockless memory allocator and a lock-less
> > > list.
> > 
> > Still no users the allocator, and no attempt to unify the existing
> > lockless list implementations.
> > 
> > I'm getting very tired of this Huang.
> 
> I just want to do that in the next step after merging the data structure
> itself. The first user of the allocator is APEI, which will go ACPI
> tree, lockless list in irq_work will go tip tree, lockless list in xlist
> will go net tree.
> 
> We must merge the data structure with its users together?

Yes -- that's how new infrastructure gets merged. Because if we don't
agree with the users (I don't) there is no point in merging these things
either.

I would really like you to stop posting code and talk to the EDAC guys.
You just keep on posting the same crap over and over again without
making any kind of progress what so ever.

So stop pushing your crap, _please_, and talk to the EDAC and other RAS
guys and come up with something together.

I haven't heard a single other RAS guy agree with your approach, and I'm
getting really sick of you just pushing your stuff without even wanting
to talk to them.

I don't want to see a single line of code from you until you've talked
with other RAS folks and they agree that your bits make sense.

So let me put it in simple words: unless there's a non-Intel RAS guy
signing off on your patches I'm objecting to them.

The thing is, a unified RAS infrastructure is much more useful for
admins, it means they can use the same tools regardless of what platform
they're running on.

Now I know creating such a thing seems daunting, but at least give it a
try, its better to have tried and failed that not attempted at all, at
worst you'll learn what you did wrong and can try to do better the
second time around.

