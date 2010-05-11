Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101Ab0EKBwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 21:52:24 -0400
Received: from mail-gx0-f227.google.com ([209.85.217.227]:48655 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab0EKBwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 21:52:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ob6zkTDoY+Ag39MFeeQIm8M7qW26/V7FA3WE6i6P84hABLnds9cNsRwVD55Im2fDb+
         4ZTVlO66TGAU5HrubbC9fq1Rkn+Jhh5kw/Ih0IL5zZRFKEvXVk95uQNkzazd+7PlFW8w
         SqaKdsOoOJYANgaaB++HCcqWGu/0kN80qf4JQ=
MIME-Version: 1.0
In-Reply-To: <1273540344.3843.101.camel@localhost.localdomain>
References: <AANLkTin6D2GP0yJJbPYGH1AcAM9-g219rAxSyW_ZlrXV@mail.gmail.com>
	 <AANLkTikjgoBQWqvNxncMUFqWOEXtq4ePvGkvF-m0sGUE@mail.gmail.com>
	 <AANLkTimnlZYonxKzfGHZTV8vwaDptOPHEPBjNhwnV55Y@mail.gmail.com>
	 <1273540344.3843.101.camel@localhost.localdomain>
Date: Mon, 10 May 2010 21:52:21 -0400
Message-ID: <AANLkTilg2cn3lAIOruz6oZE7V-9uAFDORlbvTX3qxmwF@mail.gmail.com>
Subject: Re: PROBLEM: tickless scheduling
From: Donald Allen <donaldcallen@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 9:12 PM, john stultz <johnstul@us.ibm.com> wrote:
> On Mon, 2010-05-10 at 20:59 -0400, Donald Allen wrote:
>> On Mon, May 10, 2010 at 8:54 PM, john stultz <johnstul@us.ibm.com> wrote:
>> > On Mon, May 10, 2010 at 5:18 PM, Donald Allen <donaldcallen@gmail.com> wrote:
>> >> 1. Network file transfers and fscks stop on Toshiba netbook unless
>> >> system receives external events
>> >
>> > Can you provide /proc/timer_list output?
>>
>> Attached, but again, this is from the system running with tickless disabled.
>
> Is it possible to boot with the kernel showing the issue and provide the
> details?

It's a minor pain, but I'll do it.

>
>
>> > I assume booting with nohz=off from grub resolves the issue?
>>
>> Didn't know about the boot-time option (thanks for pointing it out),
>> but I wanted to build a custom kernel anyway, so i did so and disabled
>> tickless.
>
> Ok. It may still be of value to know booting with nohz=off does avoid
> the problem.

Ok. When I've got the original kernel installed and bootable, I'll try
it. I won't be able to get to this for a day or so.

/Don

>
>
> thanks
> -john
>
>
