Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab1HWTNf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 15:13:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60060 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755681Ab1HWTNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 15:13:30 -0400
Message-ID: <4E53FBBB.7030008@zytor.com>
Date: Tue, 23 Aug 2011 12:12:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, castet.matthieu@free.fr,
        tglx@linutronix.de, sfr@canb.auug.org.au, hpa@linux.intel.com,
        rjw@sisk.pl, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/trampoline] x86, trampoline: Common infrastructure for
 low memory trampolines
References: <4D5DFBE4.7090104@intel.com> <tip-4822b7fc6d4870685a9feadfc348d48f5e47460a@git.kernel.org> <CA+8MBbLA0bDrJjCUoFBZRnA3+mLwKG+gZnXVt30Rwvza+Tj=Og@mail.gmail.com>
In-Reply-To: <CA+8MBbLA0bDrJjCUoFBZRnA3+mLwKG+gZnXVt30Rwvza+Tj=Og@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2011 12:05 PM, Tony Luck wrote:
> On Thu, Feb 17, 2011 at 9:19 PM, tip-bot for H. Peter Anvin
> <hpa@linux.intel.com> wrote:
>> +       printk(KERN_DEBUG "smpboot cpu %d: start_ip = %lx\n", cpu, start_ip);
>> +
> 
> This is kind of noisy on a large system:
> 
> Booting Node   0, Processors  #1
> smpboot cpu 1: start_ip = 96000
>  #2
> smpboot cpu 2: start_ip = 96000
>  #3
> smpboot cpu 3: start_ip = 96000
>  #4
> smpboot cpu 4: start_ip = 96000
>  #5
> smpboot cpu 5: start_ip = 96000
>   ... continues for every cpu ...
> 
> and doesn't really look all that useful. Can we drop it?
> 

Right, there haven't been any issues with this so we can just drop it.

	-hpa


