Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab1L3EwB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 23:52:01 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55419 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab1L3Ev7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 23:51:59 -0500
MIME-Version: 1.0
In-Reply-To: <4EFC7205.6000801@vflare.org>
References: <CAB4K4y4UWXXb8Tm_arYG7=_MOyMxJnk3jRLGbaXTyFiNKM-TOw@mail.gmail.com>
	<4EFC7205.6000801@vflare.org>
Date: Fri, 30 Dec 2011 10:21:58 +0530
Message-ID: <CAB4K4y6nmdnEnx9BXC_-K44g7cxPGDMZu_uQ_rcLkEeWDb7sFw@mail.gmail.com>
Subject: Re: [PATCH] xvmalloc: total_pages can be ulong
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nitin,

I wish if I could somehow know your plans for next release, so that I
can schedule my work accordingly, else my work on zram will be total
waste of my time making patches and your time replying and reviewing
it. Finally I have decided to delete my zram git.

Thanks and wishes for new year in advance.

On Thu, Dec 29, 2011 at 7:28 PM, Nitin Gupta <ngupta@vflare.org> wrote:
> Hi Ajeet,
>
> On 12/28/2011 12:50 AM, Ajeet Yadav wrote:
>
>> From 4763266cb0077d1082d4a1ef941448e9b4eb55ca Mon Sep 17 00:00:00 2001
>> From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
>> Date: Wed, 28 Dec 2011 11:08:34 +0530
>> Subject: [PATCH] xvmalloc: total_pages can be ulong
>>
>> total_pages is u64, its too large value considering
>> that its in page unit on both 32-bit and 64-bit system
>> , therefore make it ulong.
>>
>> Having done that we can use normal ++ and -- operators
>> instead of stat_inc() and stat_dec(), therefore
>> remove these functions as well.
>>
>
>
> I'm soon going to send patches which replace xvmalloc with a new allocator.
>
> Thanks,
> Nitin
