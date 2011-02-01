Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab1BAR03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 12:26:29 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:57470 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913Ab1BAR02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 12:26:28 -0500
From: Ferenc Wagner <wferi@niif.hu>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: ucb1400_gpio driver Kconfig entry
References: <87bp2vsy5y.fsf@tac.ki.iif.hu>
	<201102011816.24029.marek.vasut@gmail.com>
Date: Tue, 01 Feb 2011 18:26:24 +0100
In-Reply-To: <201102011816.24029.marek.vasut@gmail.com> (Marek Vasut's message
	of "Tue, 1 Feb 2011 18:16:23 +0100")
Message-ID: <87ipx3r7i7.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marek Vasut <marek.vasut@gmail.com> writes:

> On Tuesday 01 February 2011 14:05:13 Ferenc Wagner wrote:
> 
>> drivers/gpio/Kconfig says:
>> 
>> config GPIO_UCB1400
>>         bool "Philips UCB1400 GPIO"
>>         depends on UCB1400_CORE
>>         help
>>           This enables support for the Philips UCB1400 GPIO pins.
>>           The UCB1400 is an AC97 audio codec.
>> 
>>           To compile this driver as a module, choose M here: the
>>           module will be called ucb1400_gpio.
>> 
>> But you use bool above, so choosing M isn't actually an option.
>> Maybe you want to resolve this inconsistency.
>
> I don't really have any device with ucb1400 available now. I will have
> some probably sometimes soon though. On the other hand, if you know
> it's a correct fix, you can send a patch.

This note hasn't got much to do with the driver code itself.  Either you
want to enable compiling the driver as a module, then use tristate
instead of bool; or it isn't an option and then remove the corresponding
paragraph from the documentation.  The latter is improbable, and a
quick look at the code seems to confirm that the driver was actually
intended to be used as a module.  So I suggest replacing bool with
tristate.  But I don't know anything at all about this driver or device.
-- 
Regards,
Feri.
