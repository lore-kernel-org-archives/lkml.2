Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab2DRMNb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 08:13:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739Ab2DRMNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 08:13:30 -0400
Message-ID: <4F8EAFDF.5050406@redhat.com>
Date: Wed, 18 Apr 2012 08:13:19 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] Fix CONFIG_CLOCKSOURCE_WATCHDOG=n compile
References: <1334174480-16331-1-git-send-email-prarit@redhat.com> <alpine.LFD.2.02.1204181342560.2542@ionos>
In-Reply-To: <alpine.LFD.2.02.1204181342560.2542@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/18/2012 07:44 AM, Thomas Gleixner wrote:
> On Wed, 11 Apr 2012, Prarit Bhargava wrote:
> 
>> Noticed this while debugging -- compile fails with
>>
>> arch/x86/built-in.o: In function `mark_tsc_unstable':
>> /home/linux-2.6/arch/x86/kernel/tsc.c:791: undefined reference to
>> `clocksource_mark_unstable'
>> make: *** [.tmp_vmlinux1] Error 1
>>
>> Add in an empty function for the !CONFIG_CLOCKSOURCE_WATCHDOG case.
> 
> CONFIG_CLOCKSOURCE_WATCHDOG for x86 is always 'y', so what's the point?

Ah, I was playing around with the .config directly while debugging and I didn't
notice that.  Sorry for the noise ...

P.
