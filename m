Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab0KSNiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 08:38:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:40588 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab0KSNiP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 08:38:15 -0500
Subject: Re: [PATCH 0/2] Generic hardware error reporting support
From: Peter Zijlstra <peterz@infradead.org>
To: huang ying <huang.ying.caritas@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>
In-Reply-To: <AANLkTim0mq8Pyyi+9cAmHBct5OXH+PG7G1mQ5aneEwZV@mail.gmail.com>
References: <1290154233-28695-1-git-send-email-ying.huang@intel.com>
	 <1290165768.2109.1537.camel@laptop>
	 <AANLkTik3ujs7-tMNUuk33wuMXFm+iusspMcR=yjPXtn_@mail.gmail.com>
	 <1290168173.2109.1565.camel@laptop>
	 <AANLkTinrk8XN9XQeM-pmqhiz=tSw4x01JaGMjdRG52dF@mail.gmail.com>
	 <1290171315.2109.1577.camel@laptop>
	 <AANLkTikRwZzyCcNGoi0JWeDkCP71qgzUi=UvqYvdffR6@mail.gmail.com>
	 <1290172713.2109.1587.camel@laptop>
	 <AANLkTim0mq8Pyyi+9cAmHBct5OXH+PG7G1mQ5aneEwZV@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 19 Nov 2010 14:37:54 +0100
Message-ID: <1290173874.2109.1597.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 21:28 +0800, huang ying wrote:
> 
> > Instead you present your work as a fait accompli, not a work in flux and
> > subject to change. You ask for it to be merged -- this does not come
> > across like a discussion, much less a request for co-operation.
> 
> I heard about that LKML likes talk with code instead of idea. Am I wrong? 

No, its your presentation of said code that's wrong.

You're missing the [RFC] tags and open questions in your Changelogs
like: EDAC could use it like so and so, does that sound acceptable
Mauro? 

There is no mention you actually did talk to Mauro and Tony and what its
outcome was.



