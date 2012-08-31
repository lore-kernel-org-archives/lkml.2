Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab2HaJws (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 05:52:48 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34252 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab2HaJwr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 05:52:47 -0400
MIME-Version: 1.0
In-Reply-To: <20120831083727.GA2903@liondog.tnic>
References: <CAH0vN5Jn1g+zekr-Nd=GizskgbcOGj8zoq+m6OvBiO6Xkw5-UQ@mail.gmail.com>
	<20120831083727.GA2903@liondog.tnic>
Date: Fri, 31 Aug 2012 06:52:46 -0300
Message-ID: <CAH0vN5J0_3B2e_dmLk1yaKfCde79egkG-s7THrKtEwzcLnmm5Q@mail.gmail.com>
Subject: Re: Get the min and max frequency of a processor
From: Marcos Souza <marcos.souza.org@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Marcos Souza <marcos.souza.org@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Borislav,

2012/8/31 Borislav Petkov <bp@alien8.de>:
> On Thu, Aug 30, 2012 at 02:48:33PM -0300, Marcos Souza wrote:
>> Hi people,
>>
>> I'm changing an application to get the min and max frequency of a
>> processor. The device is using cpufreq, and it will show the user  the
>> min and max frequency that we can overclock.
>>
>> There is a way to get these values, instead of reading the /sys files,
>> or is this the solution?
>
> What's wrong with using:
>
> /sys/devices/system/cpu/cpu<N>/cpufreq/scaling_available_frequencies
>
> ?

Nothing is wrong with access /sys, but I thought there was another
way, like an API or something else.

I use your solution Borislav, thanks!

> --
> Regards/Gruss,
>     Boris.



-- 
Att,

Marcos Paulo de Souza
Acadêmico de Ciencia da Computação - FURB - SC
"Uma vida sem desafios é uma vida sem razão"
"A life without challenges, is a non reason life"
