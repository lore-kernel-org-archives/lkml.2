Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224Ab0HKXjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:39:41 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:50308 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758179Ab0HKXjh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:39:37 -0400
MIME-Version: 1.0
In-Reply-To: <20100811203453.GB28777@merkur.ravnborg.org>
References: <20100804125156.GA23464@sepie.suse.cz>
	<AANLkTinN4npO7qfSa-42B-Cq5mKZX+--H0=1SuSrWTEP@mail.gmail.com>
	<20100807040101.GA30520@merkur.ravnborg.org>
	<AANLkTinOWBfsncSZw3bvHa6Mp+eb5dzibKSV15OKgW2M@mail.gmail.com>
	<20100811195131.GA24193@merkur.ravnborg.org>
	<20100811203453.GB28777@merkur.ravnborg.org>
Date: Wed, 11 Aug 2010 16:39:35 -0700
Message-ID: <AANLkTimcVwfq4Vm9TjY0vyvJcHpvHt+DzO73=a7693mx@mail.gmail.com>
Subject: Re: [GIT] kbuild: kconfig changes
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>, JBeulich@novell.com,
        aris@redhat.com, catalin.marinas@arm.com, jacmet@sunsite.dk,
        justinmattock@gmail.com, lizf@cn.fujitsu.com, ulfalizer.lkml@gmail.com,
        zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 1:34 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
>>
>> Unfortunately the bug I had discovered is another bug.
>> If I do:
>>       make ARCH=avr32 atngw100_defconfig
>>       make ARCH=avr32 savedefconfig
>>       cp defconfig arch/avr32/configs/atngw100_defconfig
>>       make ARCH=avr32 atngw100_defconfig
>>       diff -u .config .config.old
>>
>> then the diff shows an unexpected difference.
>>
>> I will continue of that issue.
> Fixed it - see patch below.
>
> @Michal - I will do a proper patch submission if Arve
> can confirm that the problem he saw has been fixed
> with these patches.
>

Your first patch fixes the problem I saw.

-- 
Arve Hjønnevåg
