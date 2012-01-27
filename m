Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab2A0NRo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 08:17:44 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57930 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab2A0NRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 08:17:43 -0500
MIME-Version: 1.0
In-Reply-To: <20120127112434.GA7757@arm.com>
References: <CAJ8eaTwfYvAEUXX=LMFfHvvyG1JKT4wADqofb0YdyaUtDT8GEg@mail.gmail.com>
	<20120127112434.GA7757@arm.com>
Date: Fri, 27 Jan 2012 18:47:41 +0530
Message-ID: <CAJ8eaTzqZSuvDd2yVHSP1AydxHzjGkNgLP2KX7wSxyZ--DBZRA@mail.gmail.com>
Subject: Re: Long term stable kernel seletion (3.0)
From: naveen yadav <yad.naveen@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Greg KH <greg@kroah.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks a lot Catalin,

we do not want to use LPAE featue and virtulisation feature of cortex -A15,
 then still I need generic timers  ?. or they are used in virtulasiation ..

Thanks


On Fri, Jan 27, 2012 at 4:54 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Fri, Jan 27, 2012 at 05:24:42AM +0000, naveen yadav wrote:
>> Recently Greg decide and select linux 3.0 for long term.
>>
>> http://www.kroah.com/log/
>> 3.0.y - this is the new "longterm" kernel release, it will be
>> maintained for 2 years at the minimum by me.
>>
>> PS. Catalin+ Greg
>> So I have one request from Mr. Catalin and Greg.
>>
>> Is ARM-15 support will be added in this or not. ?
>
> It depends on how much Cortex-A15 support you mean. UP with classic MMU
> is already supported as it's an ARMv7 processor. SMP with classic MMU
> got merged in 3.1-rc1 (commit 7665d9d2df - "ARM: proc: add proc info for
> Cortex-A15MP using classic page tables"). ARM LPAE was merged in 3.3-rc1
> and generic timers probably during the next merging window.
>
> ARM LPAE and generic timers are unlikely to be back-ported to 3.0
> (though I have some patches around but they need considerable amount of
> timer for maintaining in a long-term release).
>
> --
> Catalin
