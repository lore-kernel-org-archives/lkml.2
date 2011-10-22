Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab1JVO1Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 10:27:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33031 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab1JVO1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 10:27:23 -0400
Message-ID: <8d6b949ee16a092a660a7b05fdaf6d6a.squirrel@www.firstfloor.org>
In-Reply-To: <yw1x1uu5p3sc.fsf@unicorn.mansr.com>
References: <4E9E0B71.9020708@am.sony.com>
    <1318983248.7569.5.camel@Joe-Laptop> <4E9E1944.80601@am.sony.com>
    <1500345.YeXPhIIHc5@wuerfel>
    <CACVXFVMb9p8PiTYWGTNn-FtQts0sRgmK+BQ6kaJ6-D89CAT=xQ@mail.gmail.com>
    <yw1x1uu5p3sc.fsf@unicorn.mansr.com>
Date: Sat, 22 Oct 2011 16:27:18 +0200
Subject: Re: [PATCH 0/3] ARM 4Kstacks: introduction
From: "Andi Kleen" <andi@firstfloor.org>
To: =?iso-8859-1?Q?=22M=E5ns_Rullg=E5rd=22?= <mans@mansr.com>
Cc: "Ming Lei" <tom.leiming@gmail.com>, "Arnd Bergmann" <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        "Tim Bird" <tim.bird@am.sony.com>, "Joe Perches" <joe@perches.com>,
        "linux kernel" <linux-kernel@vger.kernel.org>,
        "Andi Kleen" <andi@firstfloor.org>,
        "Russell King" <rmk@arm.linux.org.uk>,
        "Thomas Gleixner" <tglx@linutronix.de>
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> If system run for some time, sometimes it may be difficult for
>> memory allocator to allocate 2 continuous page frames even  there are
>> many spare page frames in system because of
>> fragment issue, so the patch does make sense. Anyway,
>> it provides one option for user to apply 4k stack to avoid
>> such kind of process creation failure.
>
> Can't page migration be used in these situations?

The kernel already uses it of course, assuming the pages are movable.
So if you are really worried about this, just define a movable zone.

-Andi

