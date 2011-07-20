Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358Ab1GTJnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 05:43:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42986 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab1GTJnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 05:43:16 -0400
Message-ID: <4E26A332.8010304@suse.cz>
Date: Wed, 20 Jul 2011 11:43:14 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Vitaliy Ivanov <vitalivanov@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: `make headers_check' bustage
References: <20110707171627.4f15035e.akpm@linux-foundation.org> <20110717144746.78063c97.rdunlap@xenotime.net> <CAGTPOqdP6OwZ2dF+1J3rxL0aBag5ir+_-ge1n_4UWWUMc1949Q@mail.gmail.com> <4E26A03E.10707@suse.cz> <CAGTPOqeMgXXtVnGZ8R1rQT2nMyiOdt3vTOi0nF4o7h2ETkxRxw@mail.gmail.com>
In-Reply-To: <CAGTPOqeMgXXtVnGZ8R1rQT2nMyiOdt3vTOi0nF4o7h2ETkxRxw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.7.2011 11:36, Vitaliy Ivanov wrote:
> On Wed, Jul 20, 2011 at 12:30 PM, Michal Marek<mmarek@suse.cz>  wrote:
>> And it exits with non-zero? Please run make headers_check; echo $?
 >
>    CHECK   include/linux (366 files)
> /home/TOROKI-UA/vitaliy.ivanov/PRIVATE/KERNEL/LINUX-2.6/build-linux-2.6/usr/include/linux/kernel.h:65:
> userspace cannot reference function or variable defined in the kernel
> /home/TOROKI-UA/vitaliy.ivanov/PRIVATE/KERNEL/LINUX-2.6/build-linux-2.6/usr/include/linux/quota.h:175:
> userspace cannot reference function or variable defined in the kernel
> /home/TOROKI-UA/vitaliy.ivanov/PRIVATE/KERNEL/LINUX-2.6/build-linux-2.6/usr/include/linux/soundcard.h:1054:
> userspace cannot reference function or variable defined in the kernel
> [...]
> Wed Jul 20 12:33:50
> [vitaliy.ivanov@vivanov linux-2.6]$ echo $?
> 0

So it works as expected; the warnings have been there for a long time 
and are not fatal. But Andrew says it exits with non-zero :(.

Michal
