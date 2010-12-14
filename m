Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab0LNK53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 05:57:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531Ab0LNK52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 05:57:28 -0500
Message-ID: <4D074D87.4010208@redhat.com>
Date: Tue, 14 Dec 2010 12:57:11 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Andi Kleen <andi@firstfloor.org>, mst@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] [104/223] KVM: Write protect memory after slot swap
References: <201012131244.547034648@firstfloor.org>	<20101212234644.B05DAB27BF@basil.firstfloor.org>	<4D05DC98.40105@redhat.com>	<044a861a2279c7e3e328c73e6694fbf3.squirrel@www.firstfloor.org>	<4D05E096.6060307@redhat.com>	<74ff92a8c4cf72e42e7559de72e77b52.squirrel@www.firstfloor.org>	<4D05E2A5.8070204@redhat.com>	<20101213091254.GA999@basil.fritz.box>	<4D05E483.1000106@redhat.com>	<AANLkTinOWHcyjXsY3Xhe6pxi3gyQ3tJMr2qCpRPuyBW4@mail.gmail.com>	<4D0652FB.2090208@redhat.com> <AANLkTikNp=mOBK9JNiNj2BC6eg=X13N-85+VWL-wiWh4@mail.gmail.com>
In-Reply-To: <AANLkTikNp=mOBK9JNiNj2BC6eg=X13N-85+VWL-wiWh4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2010 07:36 PM, Paul Gortmaker wrote:
> >>  the
> >>  same thing for 34-lt (i.e. you generating a 34 specific, pre-tested
> >>  patchset
> >>  instead of me doing the backports from other stable trees?)
> >
> >  Wait, there's a 34-lt too?
>
> There is also a 32-lt.

Luckily no 33-lt.

> >
> >  I'd like to have all stable kvms pass some minimum acceptance test, but
> >  that's quiet a lot of trees to maintain.  Why do we have to have both 34-lt
> >  and 35-lt?
>
> Well, ideally we'd all be aligned on one release, but that requires that it be
> chosen somewhat in advance and communicated well, so that people have
> time to align to it.  Without getting into details, different people had already
> based projects and products off of 34, many months ago, at a point where
> 35 was not yet even being considered for extended maintenance.

Something's got to give.  Either you burden the subsystem maintainers 
with maintaining lots of longterm kernels, or you cherry pick the 
patches yourself, and risk regressions in a stable series.  I don't 
think this is viable.

> Or you can go with Greg's shorter justification.  It is harder to
> argue against. :)

I think Greg's confusing cause and effect.

-- 
error compiling committee.c: too many arguments to function

