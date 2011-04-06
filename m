Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab1DFJtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 05:49:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755263Ab1DFJtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 05:49:42 -0400
Message-ID: <4D9C3719.1040502@redhat.com>
Date: Wed, 06 Apr 2011 12:49:13 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Gleb Natapov <gleb@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
        Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        aarcange@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        joro@8bytes.org, penberg@cs.helsinki.fi, asias.hejun@gmail.com,
        gorcunov@gmail.com
Subject: Re: [ANNOUNCE] Native Linux KVM tool
References: <1301592656.586.15.camel@jaguar> <4D982E89.8070502@redhat.com> <BANLkTinbCAUqaKfmKaj-7GXTh9F2if0x+Q@mail.gmail.com> <4D9847BC.9060906@redhat.com> <4D98716D.9040307@codemonkey.ws> <4D9873CD.3080207@redhat.com> <20110406093333.GB6465@elte.hu> <20110406093635.GE25626@redhat.com> <20110406094612.GA19943@elte.hu>
In-Reply-To: <20110406094612.GA19943@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2011 12:46 PM, Ingo Molnar wrote:
> * Gleb Natapov<gleb@redhat.com>  wrote:
>
> >  On Wed, Apr 06, 2011 at 11:33:33AM +0200, Ingo Molnar wrote:
> >
> >  >  So no, your kind of cynical, defeatist sentiment about code quality is by
> >  >  no means true in my experience. Projects become ugly gooballs once
> >  >  maintainers stop caring enough.
> >
> >  In case of Qemu it was other way around. Maintainers started caring too late.
>
> Nah, i do not think it's ever too late to care.
>
> Example: arch/i386 - arch/x86_64/ was very messy for many, many years and we
> turned it around and can be proud of arch/x86/ today - but i guess i'm somewhat
> biased there ;-)
>
> In my experience it's entirely possible to turn a messy gooball into something
> you can be proud of - it's all reversible. Start small, with the core bits you
> care about most - then extend those concepts to other areas of the code base,
> gradually. There might be subsystems that will never turn around before
> becoming obsolete - that's not a big problem.

That is what we're trying to do with qemu.

-- 
error compiling committee.c: too many arguments to function

