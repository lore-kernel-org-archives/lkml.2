Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab0KSN2j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 08:28:39 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36773 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab0KSN2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 08:28:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=pFZPa+ijcL7ggNPAJjBf/0x1oLqoteCl8mJ7sMYCcZuUsoJ769c4QS0301ofxHgy30
         MfX816FD6G+v09sgJvtfWL0LIlTfSlYk3nx8ttntpCS2zTDasrxSnfy0Rjmpe20ctb2l
         o0qf1NjaZV6soJoVGfCSJT6uFzCbTcDOke7pM=
MIME-Version: 1.0
In-Reply-To: <1290172713.2109.1587.camel@laptop>
References: <1290154233-28695-1-git-send-email-ying.huang@intel.com>
	<1290165768.2109.1537.camel@laptop>
	<AANLkTik3ujs7-tMNUuk33wuMXFm+iusspMcR=yjPXtn_@mail.gmail.com>
	<1290168173.2109.1565.camel@laptop>
	<AANLkTinrk8XN9XQeM-pmqhiz=tSw4x01JaGMjdRG52dF@mail.gmail.com>
	<1290171315.2109.1577.camel@laptop>
	<AANLkTikRwZzyCcNGoi0JWeDkCP71qgzUi=UvqYvdffR6@mail.gmail.com>
	<1290172713.2109.1587.camel@laptop>
Date: Fri, 19 Nov 2010 21:28:36 +0800
Message-ID: <AANLkTim0mq8Pyyi+9cAmHBct5OXH+PG7G1mQ5aneEwZV@mail.gmail.com>
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

On Fri, Nov 19, 2010 at 9:18 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-11-19 at 21:06 +0800, huang ying wrote:
>>
>> I lists the requirements and my solutions in my patch description of
>> [1/2] and [2/2]. If you have any question, please let me know.
>
> Those talk about _your_ requirements, it does not touch upon any of the
> concerns of the other parties, it doesn't even mention them beyond
> listing their existence.

They are welcome to talk about their requirement and opinion in the thread.

> It also, very specifically, does not mention if you did talk to any of
> those parties and what their thought on the matter was, nor does it ask
> them about their opinion.

Again opinion is welcome. I just want to talk with code.

> Instead you present your work as a fait accompli, not a work in flux and
> subject to change. You ask for it to be merged -- this does not come
> across like a discussion, much less a request for co-operation.

I heard about that LKML likes talk with code instead of idea. Am I wrong?

Best Regards,
Huang Ying
