Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab0LaCrF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 21:47:05 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:56912 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab0LaCrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 21:47:03 -0500
Date: Fri, 31 Dec 2010 13:46:53 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Matt Mackall <mpm@selenic.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Harald Welte <HaraldWelte@viatech.com>,
        Michal Ludvig <michal@logix.cz>
Subject: Re: 2.6.37-rc7: Regression: b43: crashes in hwrng_register()
Message-ID: <20101231024653.GA24879@gondor.apana.org.au>
References: <4D1BD2B0.4020101@lwfinger.net> <20101230012003.GA2665@darkside.kls.lan> <4D1BF056.3060909@lwfinger.net> <20101230143406.GA23219@darkside.kls.lan> <4D1CD161.4040107@lwfinger.net> <20101230204522.GC23219@darkside.kls.lan> <4D1D0C61.9050800@lwfinger.net> <20101231003735.GA24101@gondor.apana.org.au> <4D1D27E7.7030301@lwfinger.net> <20101231022550.GA2512@darkside.kls.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101231022550.GA2512@darkside.kls.lan>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 31, 2010 at 03:25:51AM +0100, Mario 'BitKoenig' Holbe wrote:
>
> Confirmed. No crashes with the junk buffer in action.
> I applied both patches (dump_stack() in hwrng_register() and junk[]
> after priv data) to vanilla 2.6.37-rc7 and tested both: via-rng and my
> via+rng2 as well as via-rng and b43-rng - no crashes. The (previously
> also crashing) `cat rng_available' does survive as well:
> 
> $ cat /sys/devices/virtual/misc/hw_random/rng_available
> via b43_phy0 via2 
> $ 
> 
> Attached 2 dmesg excerpts.

Thanks for checking.  Can you provide the output of

	cat /proc/cpuinfo

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
