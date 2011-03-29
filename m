Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab1C2Nqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 09:46:48 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48513 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab1C2Nqq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 09:46:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=kF3qgTkmrIRkH89TY3h/s6bzixiXqXJpjLViZhjsl8nun93leaOPs74gLmldYXknsC
         vnGRAeelDZejdrlmSfu/gAJCJnI/EdcccPGcB2cdrVdCKAp+dbNf9v4UXBjuvR8ieDuj
         H199m84qQrQIHA/Dc/apbwiZfKot06yILe+Hc=
MIME-Version: 1.0
In-Reply-To: <20110329104231.GB18155@pengutronix.de>
References: <AANLkTi=cMzOj-NEc0uksDDBiBvyaKQWta9T9jtO12Gxr@mail.gmail.com> <20110329104231.GB18155@pengutronix.de>
From: "vooon341@gmail.com" <vooon341@gmail.com>
Date: Tue, 29 Mar 2011 17:46:25 +0400
Message-ID: <AANLkTinZ25gT+Y=YJMh=bFeZdRE-fZ45wDt8=tDWVScd@mail.gmail.com>
Subject: Re: [PATCH] mmc: Add MPC512x SDHC driver.
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Ball <cjb@laptop.org>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

I'll try to add abstraction.
But I can return to this only after our hardware will done (around one month).

2011/3/29 Wolfram Sang <w.sang@pengutronix.de>:
> Hi Vladimir,
>
>> MPC512x have similar sdhc module as in MX2/MX3,
>> but use different access to the registers.
>
> There are quite some drivers abstracting the register-access
> (sdhci-esdhc for example which is also used on ppc and arm). If the
> state-machine is the same, this really should be done. Otherwise
> maintenance will be harder. I have mx2/3-hardware here and am willing to
> test the changes. If the state-machine is significantly different, a
> seperate driver makes sense, of course.
>
> Regards,
>
>   Wolfram
>
> --
> Pengutronix e.K.                           | Wolfram Sang                |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.10 (GNU/Linux)
>
> iEYEARECAAYFAk2Rt5cACgkQD27XaX1/VRupZQCfZBKjZDcAXYpWruv/YddLcrl6
> 5l4AnigRQQhsiy7kyVpMGYYDvtdlzziJ
> =fihf
> -----END PGP SIGNATURE-----
>
>
