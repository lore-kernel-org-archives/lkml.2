Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750843Ab2KIFBr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 00:01:47 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:58159 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab2KIFBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 00:01:45 -0500
Message-ID: <509C8DF4.4070300@ahsoftware.de>
Date: Fri, 09 Nov 2012 06:00:36 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC] arm: memtest
References: <509C1A92.9080407@ahsoftware.de> <CAE9FiQWeie62NYt2vyq2q+Um8NeA5xWQGy-nULmFidt4XxW=BA@mail.gmail.com>
In-Reply-To: <CAE9FiQWeie62NYt2vyq2q+Um8NeA5xWQGy-nULmFidt4XxW=BA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 08.11.2012 23:39, schrieb Yinghai Lu:
> On Thu, Nov 8, 2012 at 12:48 PM, Alexander Holler <holler@ahsoftware.de> wrote:
>> Hello,
>>
>> I've recently discovered the lack of the command line parameter memtest for
>> ARM. So I've made a patch.
>>
>> But I have some questions:
>>
>> 1. arch/x86/mm/memtest.c looks platform independ.
>> The only thing why I don't use it for arm, is because it uses 64bit
>> pointers. Maybe it could be moved to mm/memtest.c. If so, the memtest32.c
>> I'm using (basically a copy of memtest.c) could be moved there too.
>>
>> 2. Because the below memtest32.c is basically a copy of
>> arch/x86/mm/memtest.c, I'm not sure if the mapping from physical to virtual
>> locations there does fit (always) for ARM too. I know almost as much about
>> the in-kernel memory organization on x86 as on ARM, which is not really that
>> much (some theory about TLBs, some source code explorations, ..., but I'm
>> working on it). ;)
>
> We are using arch/x86/mm/memtest.c for x86 32bit and 64bit.
>
> So it should be ok to use it with arm 32bit and 64bit directly.

It does. But in order to enable it on every boot, I wanted it to be as 
fast as possible.

Regards,

Alexander

