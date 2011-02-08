Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab1BHVKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 16:10:53 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34039 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841Ab1BHVKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 16:10:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aNjvXjO5Pcdx3gz1P4DwIwDXEAh7d1OJnbFJ8JySaZPV0MVtGWkwyeOmLdTUKp2i7z
         Z3ISasam18XwSaKWekNep9bBUJ875OKglwDmJAwkk4ydXuRHxmwKKoeS4Alnu52bSCNo
         6gt4bX02n23eaH4/QiJKnC3pVKs9lX8LHUoIQ=
Date: Tue, 8 Feb 2011 13:10:36 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sourav Poddar <sourav.poddar@ti.com>, Wolfram Sang <w.sang@pengutronix.de>,
        Linux-Next <linux-next@vger.kernel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: drivers/input/touchscreen/ads7846.c:959: error: 'GPIOF_DIR_IN'
 undeclared
Message-ID: <20110208211035.GC16527@core.coreip.homeip.net>
References: <AANLkTim2706Negrvd-ektbNMLwucM9M0icphb_uFY_9D@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim2706Negrvd-ektbNMLwucM9M0icphb_uFY_9D@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 09:03:27PM +0100, Geert Uytterhoeven wrote:
> linux-next/m68k-allmodconfig/m68k:
> http://kisskb.ellerman.id.au/kisskb/buildresult/3899710/
> 
> drivers/input/touchscreen/ads7846.c:959: error: 'GPIOF_DIR_IN'
> undeclared (first use in this function)
> drivers/input/touchscreen/ads7846.c:959: error: (Each undeclared
> identifier is reported only once
> drivers/input/touchscreen/ads7846.c:959: error: for each function it
> appears in.)
> make[4]: *** [drivers/input/touchscreen/ads7846.o] Error 1
> 
> As of commit e9b6e245c727767e6d64cb3dd47a0c6982aa5d23
> ("Input: ads7846 - use gpio_request_one to configure pendown_gpio"), this
> driver should depend on GENERIC_GPIO?
> Else <linux/gpio.h> doesn't include <asm/gpio.h>, and we never see the
> definition of GPIOF_DIR_IN.

Crap, sorry about that, I'll fix it up tonight.

-- 
Dmitry
