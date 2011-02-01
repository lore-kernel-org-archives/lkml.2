Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab1BARNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 12:13:10 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54573 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab1BARNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 12:13:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=cdp2dff2b5FM1vJjaaifW7dDyG2hzN4m31XXBlmWdB1Rqq10s1LCBkUQqc+w1vDNk4
         coab0bUouQzLBxhCl89Y86+Y5B/bcHbOhOohYVgibbVTsd+2CztOm3GftFadThAPq1lC
         Fzpg+zW1cISwGgQDBztNgdxzYdOO5sUdMpF0o=
From: Marek Vasut <marek.vasut@gmail.com>
To: Ferenc Wagner <wferi@niif.hu>
Subject: Re: ucb1400_gpio driver Kconfig entry
Date: Tue, 1 Feb 2011 18:16:23 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-trunk-amd64; KDE/4.4.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <87bp2vsy5y.fsf@tac.ki.iif.hu>
In-Reply-To: <87bp2vsy5y.fsf@tac.ki.iif.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102011816.24029.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 February 2011 14:05:13 Ferenc Wagner wrote:
> Hi Marek,
> 
> drivers/gpio/Kconfig says:
> 
> config GPIO_UCB1400
>         bool "Philips UCB1400 GPIO"
>         depends on UCB1400_CORE
>         help
>           This enables support for the Philips UCB1400 GPIO pins.
>           The UCB1400 is an AC97 audio codec.
> 
>           To compile this driver as a module, choose M here: the
>           module will be called ucb1400_gpio.
> 
> But you use bool above, so choosing M isn't actually an option.
> Maybe you want to resolve this inconsistency.

I don't really have any device with ucb1400 available now. I will have some 
probably sometimes soon though. On the other hand, if you know it's a correct 
fix, you can send a patch.

Also, CC linux-input please.

Cheers
