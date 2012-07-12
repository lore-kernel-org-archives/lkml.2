Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161479Ab2GLRkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 13:40:12 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:45810 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432Ab2GLRkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 13:40:10 -0400
Message-ID: <4FFF0BE9.2010307@linaro.org>
Date: Thu, 12 Jul 2012 10:39:53 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>,
        Mike Turquette <mike.turquette@linaro.org>,
        Marc Zyngier <maz@misterjones.org>
Subject: Re: [PATCH 33/36] AArch64: Generic timers support
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <1341608777-12982-34-git-send-email-catalin.marinas@arm.com> <CAKnu2MrHibKWezjEK+6oOnamkjxWnWwKfoVYRDBURZ3VkaoxEQ@mail.gmail.com> <12a7f9b8e6d0b4dc3e3f6fcf91ad2a18@localhost> <CACRpkdbMjRzTVo6o-+z6mNNkKWp1mFL76ptKd8PFV8orgFLeOg@mail.gmail.com> <4FFF01FD.4050005@linaro.org> <62038bf130381e2b55cedec5f3c44760@localhost>
In-Reply-To: <62038bf130381e2b55cedec5f3c44760@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071217-7282-0000-0000-00000ADCB270
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2012 10:31 AM, Marc Zyngier wrote:
> On Thu, 12 Jul 2012 09:57:33 -0700, John Stultz <john.stultz@linaro.org>
> wrote:
>
>> So following ia64's method is probably better then copying the 8253's
>> rate if you're not concerned about tick-granularity error.
> The 8253 is completely meaningless in our case (though I'm sure someone
> could try and bold one on the side of an Aarch64 CPU...), so going the ia64
> way is probably best (erm... this last bit doesn't sound quite right,
> doesn't it?).

Sorry, the "copying the 8253's" bit didn't come out sarcastic enough.  :)

The best solution would be to include the actual tick-granularity, but 
given its not really an architecture constant (which CLOCK_TICK_RATE 
assumes), that probably wouldn't be appropriate.

thanks
-john

