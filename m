Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab0K3UNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 15:13:40 -0500
Received: from mail.lang.hm ([64.81.33.126]:51816 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388Ab0K3UNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 15:13:39 -0500
Date: Tue, 30 Nov 2010 12:13:05 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Pavel Machek <pavel@ucw.cz>
cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>, bkuhn@ebb.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Greg KH <greg@kroah.com>, David Miller <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>,
        Charles Marker <Charles.Marker@atheros.com>,
        Jouni Malinen <Jouni.Malinen@atheros.com>,
        Kevin Hayes <kevin@atheros.com>, Zhifeng Cai <zhifeng.cai@atheros.com>,
        Don Breslin <Don.Breslin@atheros.com>,
        Doug Dahlby <Doug.Dahlby@atheros.com>, Julia Lawall <julia@diku.dk>
Subject: Re: Challenges with doing hardware bring up with Linux first
In-Reply-To: <20101130200019.GA28735@elf.ucw.cz>
Message-ID: <alpine.DEB.2.00.1011301209090.423@asgard.lang.hm>
References: <AANLkTim4jVaZxYp8nSgJyy28iwxcxbPeNUzxTfoHAX4S@mail.gmail.com> <20101118113441.74fcdc21@lxorguk.ukuu.org.uk> <AANLkTikOZbtyhsk0OBb4OdUi6qj-7k_hU-aW_Pkhfpq0@mail.gmail.com> <20101130192648.GA1623@ucw.cz> <AANLkTinMyAeVJJc7Lc-vt_Ywr+vcSf-GAiQwggTGbqh8@mail.gmail.com>
 <20101130200019.GA28735@elf.ucw.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010, Pavel Machek wrote:

> On Tue 2010-11-30 11:30:18, Luis R. Rodriguez wrote:
>> On Tue, Nov 30, 2010 at 11:26 AM, Pavel Machek <pavel@ucw.cz> wrote:
>>> Hi!
>>>
>>>>>> everything else can be independent code. For ath9k in particular this
>>>>>> means we keep ath9k_hw shared between our Operating Systems and that's
>>>>>> it. In addition to this I believe opening up the common drivers for
>>>>>
>>>>> The Linux copy needs to be GPL,
>>>>
>>>> GPL-Compatible you mean, right. I mean we have ath9k_hw with
>>>> permissive licensed files.
>>>
>>> GPL-compatible is not right word. It has to be either GPL, or so
>>> permissive that anyone is allowed to turn it into GPL.
>>
>> Oh?
>
> Kernel is GPL. Dual BSD/GPL is ok. Just BSD... I don't think so.
>
> /*
> * Copyright (c) 2008 Atheros Communications Inc.
> *
> * Permission to use, copy, modify, and/or distribute this software
> for any
> * purpose with or without fee is hereby granted, provided that the
> above
> * copyright notice and this permission notice appear in all copies.
> *
>
> ...but I need permission to relicense it under GPL, and I'm not sure I
> have it.
> 							Pavel

unless it's the old 4-clause BSD license (with the advertising clause, 
which almost nobody used anymore), the BSD code can be relicensed as 
anything (including proprietary), as long as the notices in the file are 
maintained.

it doesn't take more explicit permission to re-license something as GPL 
than it does to make it closed-source.

However,
   there are quite a few files in the kernel that are BSD licensed, when 
combined with other GPL code, the only way you can re-distribute the 
result is under the GPL, so it is effectivly 'converted' when you compile, 
but by leaving the file BSD, improvements to it can be shared back with 
the original authors and put into their main codebase, so it's actually 
more polite to leave the license as-is for this file.

David Lang
