Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab2A3FpO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 00:45:14 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48319 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab2A3FpM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 00:45:12 -0500
MIME-Version: 1.0
In-Reply-To: <1327901519.2891.4.camel@edumazet-laptop>
References: <20120127060034.GG29272@MAIL.13thfloor.at>
	<20120128125108.GA9661@localhost>
	<1327757611.7199.6.camel@edumazet-laptop>
	<20120129055917.GB8513@localhost>
	<1327831380.14602.6.camel@edumazet-laptop>
	<20120129111645.GA5839@localhost>
	<1327842831.2718.2.camel@edumazet-laptop>
	<20120129161058.GA13156@localhost>
	<CANejiEW86b7btiOcVFF3qVhqU1t6FRosvgfiydWwU5zgeDFOqw@mail.gmail.com>
	<1327901519.2891.4.camel@edumazet-laptop>
Date: Mon, 30 Jan 2012 13:45:12 +0800
X-Google-Sender-Auth: PZciVRIufj6d_macNiNI39i_wx4
Message-ID: <CANejiEWXDwYVtPUmOGXFxRohEmN4K3qde7z93Nw8bbk+-ZHP2w@mail.gmail.com>
Subject: Re: Bad SSD performance with recent kernels
From: Shaohua Li <shli@kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Wu Fengguang <wfg@linux.intel.com>, Herbert Poetzl <herbert@13thfloor.at>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/30 Eric Dumazet <eric.dumazet@gmail.com>:
> Le lundi 30 janvier 2012 à 11:17 +0800, Shaohua Li a écrit :
>
>> 1M block size is slow, I guess it's CPU related.
>>
>> And as for the big regression with newer kernel than 2.6.38, please
>> check if idle=poll
>> helps. CPU idle dramatically impacts disk performance and even latest
>> cpuidle governor
>> doesn't help for some CPUs.
>>
>
> No change with idle=poll
I mean the big regression might be related to CPU idle. because I
saw really bad performance with CPU idle with some CPUs.

The 1M block size performance is lower than 128K is not. but I still
guess it's CPU related (like copy). The test result is always like this
IIRC.
