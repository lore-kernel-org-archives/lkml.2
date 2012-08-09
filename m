Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031480Ab2HIQGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 12:06:13 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:64808 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031418Ab2HIQGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 12:06:10 -0400
MIME-Version: 1.0
In-Reply-To: <20120809145005.GB17588@linaro.org>
References: <1344379514-30076-1-git-send-email-matt@genesi-usa.com>
 <1344379514-30076-2-git-send-email-matt@genesi-usa.com> <20120808065502.GI1451@pengutronix.de>
 <CAKGA1bmUuSZuWDM4QPTxmNR0+=uQ1RbFhw4u-sb9KaSPYwQiVw@mail.gmail.com>
 <20120809102414.GA17588@linaro.org> <CAKGA1bniQK9DbZudrHk1mA7FyDZkQzBJbWNUFTFW3pc_2A2x4g@mail.gmail.com>
 <20120809145005.GB17588@linaro.org>
From: Matt Sealey <matt@genesi-usa.com>
Date: Thu, 9 Aug 2012 11:05:47 -0500
Message-ID: <CAKGA1bkzOEiMm8Uo=AiXdquhKHFhjgHE0qXaztcxRvMDSjkfaQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: build ssi-fiq.S in ARM mode to prevent
 CONFIG_THUMB2_KERNEL build breakage
To: Dave Martin <dave.martin@linaro.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Steev Klimaszewski <steev@genesi-usa.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 9:50 AM, Dave Martin <dave.martin@linaro.org> wrote:
> On Thu, Aug 09, 2012 at 09:32:59AM -0500, Matt Sealey wrote:
>> Matt Sealey <matt@genesi-usa.com>
>> Product Development Analyst, Genesi USA, Inc.
>>
>>
>> On Thu, Aug 9, 2012 at 5:24 AM, Dave Martin <dave.martin@linaro.org> wrote:
>> > On Wed, Aug 08, 2012 at 12:32:39PM -0500, Matt Sealey wrote:
>> >
>> > [...]
>> >
>> >> I'm going to do a trapse through and find where Russell nacked Dave's
>> >> thumb-aware
>> >> rewrite.. would you mind if you have any of these boards seeing if it
>> >> really DOES
>> >
>> > There was no NAK because I didn't get as far as posting the patch,
>>
>> http://lists.arm.linux.org.uk/lurker/message/20111202.133911.393b6e28.en.html
>>
>> You did, twice :)
>
> Well, I meant that I had not posted it as a stand-alone patch for
> inclusion; I only posted it when commenting on other threads.
>
>> > mostly because of the doubt about whether this code is ever relevant
>> > on Thumb2-capable hardware.
>>
>> It's not, but it does break the build, and without disabling phyCORE boards for
>> Thumb2 it will always break the build..
>
> If you want me to push it, let me know.  I don't think this should get
> merged without some Tested-bys for hardware where the FIQ stuff actually
> gets used.

Please, then all the Tested-by's should flood in, right? :)

> The older post would be the one to use, since that at least got a
> reasonable level of build testing.

-- 
Matt Sealey <matt@genesi-usa.com>
Product Development Analyst, Genesi USA, Inc.
