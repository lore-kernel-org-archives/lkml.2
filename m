Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab1BBJLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 04:11:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019Ab1BBJK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 04:10:58 -0500
Message-ID: <4D491F94.6070803@redhat.com>
Date: Wed, 02 Feb 2011 11:10:44 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: Sedat Dilek <sedat.dilek@googlemail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, riel@redhat.com,
        gleb@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: Fix section mismatch derived from kvm_guest_cpu_online()
References: <1294009289-28802-1-git-send-email-sedat.dilek@gmail.com>	<20110104210307.GB6130@amt.cnet> <AANLkTi=V6PvG42bBmE=7qcm=5vvk=SeUJ6a8oMKOcihb@mail.gmail.com>
In-Reply-To: <AANLkTi=V6PvG42bBmE=7qcm=5vvk=SeUJ6a8oMKOcihb@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2011 09:55 AM, Sedat Dilek wrote:
> On Tue, Jan 4, 2011 at 10:03 PM, Marcelo Tosatti<mtosatti@redhat.com>  wrote:
> >  On Mon, Jan 03, 2011 at 12:01:29AM +0100, Sedat Dilek wrote:
> >>  > From my build.log:
> >>
> >>  WARNING: arch/x86/built-in.o(.text+0x1bb74): Section mismatch in reference from the function kvm_guest_cpu_online() to the function .cpuinit.text:kvm_guest_cpu_init()
> >>  The function kvm_guest_cpu_online() references
> >>  the function __cpuinit kvm_guest_cpu_init().
> >>  This is often because kvm_guest_cpu_online lacks a __cpuinit
> >>  annotation or the annotation of kvm_guest_cpu_init is wrong.
> >>
> >>  This patch fixes the warning.
> >>
> >>  Tested with linux-next (next-20101231)
> >>
> >>  Signed-off-by: Sedat Dilek<sedat.dilek@gmail.com>
> >
> >  Applied, thanks.
> >
> >
>
> PING!
>
> Was this patch really applied? I have it still in my patch-series.
>

It was applied to kvm.git and will find its way upstream eventually.

-- 
error compiling committee.c: too many arguments to function

