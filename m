Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab1ESH0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 03:26:16 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52487 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520Ab1ESH0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 03:26:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=DYYzwSnNtz8C4qPm0HlJgElwjyU1b5P9ErfkIYOMvTRCZS7pI70JSjIBLKfn4aeljf
         vUmNzCvDHe3Hou48VVfavWz2WUe8EhQQZOCHnxQKdxB6QVQ8IhdgeQN/O7Juw/NNx3AF
         l8PIyxTergofgb7VjrkhO2z0kFvmYknw5nfy0=
MIME-Version: 1.0
In-Reply-To: <20110518210136.437459958@linutronix.de>
References: <20110518205713.947614271@linutronix.de>
	<20110518210136.437459958@linutronix.de>
Date: Thu, 19 May 2011 09:26:14 +0200
X-Google-Sender-Auth: Hr4wPTJaAlMGdp-gYMv1CuTC9Wk
Message-ID: <BANLkTimhg6WAErYPSaSagZUc0mRZdNREvw@mail.gmail.com>
Subject: Re: [patch 5/7] clockevents: Provide interface to reconfigure an
 active clock event device
From: Linus Walleij <linus.walleij@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Ingo Molnar <mingo@elte.hu>, John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/18 Thomas Gleixner <tglx@linutronix.de>:

> Some ARM SoCs have clock event devices which have their frequency
> modified due to frequency scaling. Provide an interface which allows
> to reconfigure an active device. After reconfiguration reprogram the
> current pending event.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks for fixing this much needed function Thomas!
Linus Walleij
