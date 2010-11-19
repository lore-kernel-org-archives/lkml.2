Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab0KSNtl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 08:49:41 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59297 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab0KSNti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 08:49:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=jn0fTbvzzc+7kN8Me/oVum3L1TjrfW1u2xXB3sVGJy1GTJBBcFrETWu0KOxOfSmpsw
         5CB2EGNWygf8fDjTCDeTLDVCILYe16ym/oCpOH/H2dvo1X/pvf+Bqk4emASz+ylQX8wR
         OEWD59fe8tCod+0EHSSSGFZv/tKEQWyCw0r1M=
MIME-Version: 1.0
In-Reply-To: <1290173874.2109.1597.camel@laptop>
References: <1290154233-28695-1-git-send-email-ying.huang@intel.com>
	<1290165768.2109.1537.camel@laptop>
	<AANLkTik3ujs7-tMNUuk33wuMXFm+iusspMcR=yjPXtn_@mail.gmail.com>
	<1290168173.2109.1565.camel@laptop>
	<AANLkTinrk8XN9XQeM-pmqhiz=tSw4x01JaGMjdRG52dF@mail.gmail.com>
	<1290171315.2109.1577.camel@laptop>
	<AANLkTikRwZzyCcNGoi0JWeDkCP71qgzUi=UvqYvdffR6@mail.gmail.com>
	<1290172713.2109.1587.camel@laptop>
	<AANLkTim0mq8Pyyi+9cAmHBct5OXH+PG7G1mQ5aneEwZV@mail.gmail.com>
	<1290173874.2109.1597.camel@laptop>
Date: Fri, 19 Nov 2010 21:49:37 +0800
Message-ID: <AANLkTikeVk5F1sFmdYKjyFggrCsgNRQ0Vebm7GVQL-EK@mail.gmail.com>
Subject: Re: [PATCH 0/2] Generic hardware error reporting support
From: huang ying <huang.ying.caritas@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 9:37 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-11-19 at 21:28 +0800, huang ying wrote:
>>
>> > Instead you present your work as a fait accompli, not a work in flux and
>> > subject to change. You ask for it to be merged -- this does not come
>> > across like a discussion, much less a request for co-operation.
>>
>> I heard about that LKML likes talk with code instead of idea. Am I wrong?
>
> No, its your presentation of said code that's wrong.
>
> You're missing the [RFC] tags and open questions in your Changelogs
> like: EDAC could use it like so and so, does that sound acceptable
> Mauro?

Maybe. We can not talk with code without that tag?

> There is no mention you actually did talk to Mauro and Tony and what its
> outcome was.

The main outcome is that we need a generic hardware error reporting
interface, that can be used by all hardware error reporting
mechanisms.

Best Regards,
Huang Ying
