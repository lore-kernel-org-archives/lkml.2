Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513Ab1BKN5f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 08:57:35 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59100 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214Ab1BKN5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 08:57:34 -0500
MIME-Version: 1.0
In-Reply-To: <1297379896.1865.6.camel@localhost>
References: <1297113368-27174-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br> <1297379896.1865.6.camel@localhost>
From: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Date: Fri, 11 Feb 2011 11:57:08 -0200
Message-ID: <AANLkTin1Y9S5C41BZQgSasXX-nBBUm7siNivyfKOaufj@mail.gmail.com>
Subject: Re: [rtc-linux] Re: [PATCH 0/4] RTC: Updates for RTC.
To: rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, tglx@linutronix.de,
        a.zummo@towertech.it
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On Thu, Feb 10, 2011 at 21:18, John Stultz <john.stultz@linaro.org> wrote:
> The first one worries me a little bit (see earlier reply), but the
> others look ok to me. The last one collided with my RTC tree, but I
> think I've fixed it up. You can find the tree here:
>
> git://git.linaro.org/people/jstultz/linux.git dev/rtc-cleanups
>
> Would you mind testing that branch and letting me know if anything
> breaks for you?

Sure, I was already testing using your branch, I don't know what
caused the collision.

I just tested it and my tests work fine in the rtc-cleanups branch.

> thanks
> -john

Regards,
Marcelo.
