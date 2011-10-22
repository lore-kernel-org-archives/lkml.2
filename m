Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab1JVNN6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 09:13:58 -0400
Received: from unicorn.mansr.com ([78.86.181.103]:54776 "EHLO
	unicorn.mansr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915Ab1JVNN5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 09:13:57 -0400
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Tim Bird <tim.bird@am.sony.com>, Joe Perches <joe@perches.com>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Russell King <rmk@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/3] ARM 4Kstacks: introduction
References: <4E9E0B71.9020708@am.sony.com>
	<1318983248.7569.5.camel@Joe-Laptop> <4E9E1944.80601@am.sony.com>
	<1500345.YeXPhIIHc5@wuerfel>
	<CACVXFVMb9p8PiTYWGTNn-FtQts0sRgmK+BQ6kaJ6-D89CAT=xQ@mail.gmail.com>
Date: Sat, 22 Oct 2011 14:13:55 +0100
In-Reply-To: <CACVXFVMb9p8PiTYWGTNn-FtQts0sRgmK+BQ6kaJ6-D89CAT=xQ@mail.gmail.com>
	(Ming Lei's message of "Sat, 22 Oct 2011 16:50:15 +0800")
Message-ID: <yw1x1uu5p3sc.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ming Lei <tom.leiming@gmail.com> writes:

> On Wed, Oct 19, 2011 at 6:51 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Tuesday 18 October 2011 17:26:44 Tim Bird wrote:
>>> Even inside Sony, usage of 4K stacks is limited
>>> to some very special cases, where memory is exceedingly
>>> tight (we have one system with 4M of RAM).  And we
>>> don't mind lopping off features or coding around
>>> problem areas to support our special case.
>>
>> I would imagine that in those cases, you can gain more by reducing the
>> number of threads in the system. What is the highest number of
>> concurrent threads that you expect in a limited use case with no
>> networking or block devices?
>
> If system run for some time, sometimes it may be difficult for
> memory allocator to allocate 2 continuous page frames even  there are
> many spare page frames in system because of
> fragment issue, so the patch does make sense. Anyway,
> it provides one option for user to apply 4k stack to avoid
> such kind of process creation failure.

Can't page migration be used in these situations?

-- 
Måns Rullgård
mans@mansr.com
