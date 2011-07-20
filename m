Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751343Ab1GTJam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 05:30:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42290 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072Ab1GTJal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 05:30:41 -0400
Message-ID: <4E26A03E.10707@suse.cz>
Date: Wed, 20 Jul 2011 11:30:38 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Vitaliy Ivanov <vitalivanov@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: `make headers_check' bustage
References: <20110707171627.4f15035e.akpm@linux-foundation.org> <20110717144746.78063c97.rdunlap@xenotime.net> <CAGTPOqdP6OwZ2dF+1J3rxL0aBag5ir+_-ge1n_4UWWUMc1949Q@mail.gmail.com>
In-Reply-To: <CAGTPOqdP6OwZ2dF+1J3rxL0aBag5ir+_-ge1n_4UWWUMc1949Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.7.2011 11:26, Vitaliy Ivanov wrote:
> On Mon, Jul 18, 2011 at 12:47 AM, Randy Dunlap<rdunlap@xenotime.net>  wrote:
>> On Thu, 7 Jul 2011 17:16:27 -0700 Andrew Morton wrote:
>>
>>> It is just me, or is headers_check busted in current -linus?
>>>
>>> z:/usr/src/25>  make mrproper; make allmodconfig; make headers_check
>>> ...
>>> /usr/src/25/usr/include/linux/kernel.h:65: userspace cannot reference function or variable defined in the kernel
>>> /usr/src/25/usr/include/linux/quota.h:175: userspace cannot reference function or variable defined in the kernel
>>> /usr/src/25/usr/include/linux/sdla.h:116: userspace cannot reference function or variable defined in the kernel
>>> /usr/src/25/usr/include/linux/soundcard.h:1054: userspace cannot reference function or variable defined in the kernel
>>
>> What does it take to reproduce this?
>> Does it fail on either type of X86 or is this from some other $ARCH?
>> I can't make it fail on X86 (3.0-rc7).
>
> Config is attached. I can see it on today's linus' tree.
>
> Wed Jul 20 12:15:14
> [vitaliy.ivanov@vivanov linux-2.6]$ make
> O=/home/TOROKI-UA/vitaliy.ivanov/PRIVATE/KERNEL/LINUX-2.6/build-linux-2.6
> headers_check
 > [...]

And it exits with non-zero? Please run make headers_check; echo $?

Michal
