Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab1LVPwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 10:52:46 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59585 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab1LVPwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 10:52:42 -0500
Message-ID: <4EF35243.9030600@gmail.com>
Date: Thu, 22 Dec 2011 23:52:35 +0800
From: "nai.xia" <nai.xia@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Brian Gerst <brgerst@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Question about missing "cld" in x86 string assembly code
References: <201112172258.24221.nai.xia@gmail.com> <CAMzpN2inHxaSnaYaYXZ4Ya3rK+MWXqR6dN5NVNZy3=OvP04uQA@mail.gmail.com> <CA+55aFzyEgDUSaNVQ1Nw5SBNd36Cvb-KrVdc1MYj+oRJt8xWgg@mail.gmail.com>
In-Reply-To: <CA+55aFzyEgDUSaNVQ1Nw5SBNd36Cvb-KrVdc1MYj+oRJt8xWgg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2011年12月18日 02:39, Linus Torvalds wrote:
> On Sat, Dec 17, 2011 at 9:08 AM, Brian Gerst<brgerst@gmail.com>  wrote:
>>
>> The i386 ELF ABI states "The direction flag must be set to the
>> ‘‘forward’’ (that is, zero) direction before entry and upon exit from
>> a function."  Therefore it can be assumed to be clear, unless
>> explicitly set.
>
> The exception, of course, being bootup, fault and interrupt handlers,
> and after we've called out to foreign code (ie BIOS).

Yeah, I think I see these cld's now. Thanks for the answers!


Nai
>
> So there *are* a few cld's sprinkled around, they are just fairly rare.
>
>                      Linus
