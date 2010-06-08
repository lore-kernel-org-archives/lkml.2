Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab0FHGjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 02:39:49 -0400
Received: from daytona.panasas.com ([67.152.220.89]:28762 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753429Ab0FHGjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 02:39:48 -0400
Message-ID: <4C0DE5AC.1090204@panasas.com>
Date: Tue, 08 Jun 2010 09:39:40 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>
CC: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Dirk Hohndel <hohndel@infradead.org>,
       Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, v2] kbuild: Improve version string logic - two for the
 price of one - No thanks
References: <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <20091006153632.GA29795@elte.hu> <alpine.LFD.2.01.0910060843560.3432@localhost.localdomain> <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain> <20091006173508.GA4786@elte.hu> <20091012195733.GA7351@elte.hu> <4C0D29DE.6050602@panasas.com> <alpine.DEB.2.00.1006071242510.30389@chino.kir.corp.google.com> <4C0DDAA6.8080002@panasas.com> <alpine.DEB.2.00.1006072311170.31780@chino.kir.corp.google.com> <20100608063419.GF6376@linux-sh.org>
In-Reply-To: <20100608063419.GF6376@linux-sh.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jun 2010 06:39:47.0662 (UTC) FILETIME=[63753EE0:01CB06D5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2010 09:34 AM, Paul Mundt wrote:
> On Mon, Jun 07, 2010 at 11:18:42PM -0700, David Rientjes wrote:
>> On Tue, 8 Jun 2010, Boaz Harrosh wrote:
>>
>>>>> I already have my:
>>>>>  VERSION = 2
>>>>>  PATCHLEVEL = 6
>>>>>  SUBLEVEL = 35
>>>>> -EXTRAVERSION = -rc2
>>>>> +EXTRAVERSION = -rc2-my_tree
>>>>>
>>>>
>>>> You shouldn't be using EXTRAVERSION for this purpose, you should be 
>>>> passing LOCALVERSION=my_tree to make.
>>>>
>>>
>>> That will not work because the way I run make is out of my control. Every
>>> one in the working group has his system. The Makefile is part of the
>>> public git tree, so every one will get the same identification without
>>> any confusion with Vanilla kernel, or what was compiled.
>>>
>>
>> If everyone using that tree wants the same version string for that kernel, 
>> use CONFIG_LOCALVERSION="-my_tree" in your .config and use "make 
>> LOCALVERSION=".
>>
> Or just distribute a localversion-my_tree file in the top-level directory
> like other trees do. This doesn't strike me as a particularly significant
> problem.

OK That one is actually a solution. I'll try that ASAP. If it works as expected
it's perfect. Even better than before

Thanks
Boaz
