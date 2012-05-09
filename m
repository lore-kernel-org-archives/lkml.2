Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384Ab2EINVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 09:21:54 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64732 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757899Ab2EINVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 09:21:53 -0400
MIME-Version: 1.0
In-Reply-To: <20120509070710.GA29981@gmail.com>
References: <1336004953.4240.9.camel@mop> <CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com>
 <1336475689.1179.12.camel@mop> <CA+55aFwbQTq_f7p2j-eu8-hVpiZ1Uf2MCU7R+DDWHimiVbcScg@mail.gmail.com>
 <CA+1xoqcAjEh5LT42NpjoE0998KUecY6EWQp4FM0_CY8MPyLmbQ@mail.gmail.com>
 <CA+55aFzVs0GLpNVUBHtLRuc8uQc=WKd8ajeVWsffbNvxSQvB4Q@mail.gmail.com>
 <CA+55aFzgXzFs9z-5ViQ4=4hhtOtK=CBHGxNX_dsXQV9mn1qANg@mail.gmail.com> <20120509070710.GA29981@gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 9 May 2012 15:21:32 +0200
Message-ID: <CAPXgP12G+KgqN43BQjzADAPtz2zhZs-0+AHC+YnHZc2JYqwAEA@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sasha Levin <levinsasha928@gmail.com>,
        Greg Kroah-Hartmann <greg@kroah.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 9:07 AM, Ingo Molnar <mingo@kernel.org> wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>> [...]
>>
>> So it's like a defibrillator: it is good to *have* one, but
>> it's really bad to have to *use* one.

I rather teach the people with known heart problems to only slap their
shocks at people who wear a sign that they are prepared to get
treated, instead of just letting them "help" the healthy random next
guy. :)

> /me nominates this for LWN quote of the week!
>
> Thanks for bringing sanity into printk,

Sounds like the view of sanity of the guys with heart problems, not so
much of the healthy guys. :)

In other words:
Isolation of risk-takers from non-risk-takers is usually a good thing.

Explicit annotation of exceptions almost every time beats expressions
which need heuristics to construct the context.

We use typed pointer instead of void too, even when we don't need it
most of the time. :)

Kay
