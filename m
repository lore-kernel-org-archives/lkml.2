Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab0KLKKp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 05:10:45 -0500
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:38901 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756263Ab0KLKKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 05:10:44 -0500
Message-ID: <4CDD120A.2050401@stericsson.com>
Date: Fri, 12 Nov 2010 11:08:10 +0100
From: Linus Walleij <linus.walleij@stericsson.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: john stultz <johnstul@us.ibm.com>,
        Rabin VINCENT <rabin.vincent@stericsson.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Colin Cross <ccross@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] RFC: nomadik: expand timesource to 63 bits
References: <1289466356-16697-1-git-send-email-linus.walleij@stericsson.com> <AANLkTi=ysONhPQBTbVNRgTOx5PGEM=STaUYY6RnUpfES@mail.gmail.com> <20101112095739.GH18358@pengutronix.de>
In-Reply-To: <20101112095739.GH18358@pengutronix.de>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Kleine-König wrote:

> Instead of implementing sched_clock for each architecture seperatly,
> wouldn't it be nice to have a generic sched_clock that uses the
> architecture's clocksource?  I tried to implement that some time ago,
> but tglx shoot it down because of locking problems.

I was and still am a big fan of this approach, I am willing to help
testing it if you want to dust off this patch set...

Yours,
Linus Walleij
