Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934619Ab0KQIV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 03:21:59 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:37035 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934588Ab0KQIV6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 03:21:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=wdgNt5VWbpGeH6ZF3DFwDOY6n/rd8jU8EZNNvec7GKaSFBfUf/CIY63UXDXZxPXeXC
         STO5Aoehzv9UHJHRdeM0D9B2i8rtuQSWZlWh5ZB0jbxDnXJhYJwCaIPXnWc+OEs/n7UK
         /MEK6DLPbpxDjfFTt/h3XCFYaweBJG7JtZlS0=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20101117081205.GB11542@pengutronix.de>
References: <1289962844.8233.2.camel@mola> <20101117081205.GB11542@pengutronix.de>
From: Axel Lin <axel.lin@gmail.com>
Date: Wed, 17 Nov 2010 16:21:37 +0800
Message-ID: <AANLkTik_b=JT3Fwep4cdNoguoFHEQ=xV+mL2DKJVo5c+@mail.gmail.com>
Subject: Re: [PATCH] regulator: Move lp3971 regulator driver to subsys_initcall()
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/17 Wolfram Sang <w.sang@pengutronix.de>:
> On Wed, Nov 17, 2010 at 11:00:44AM +0800, Axel Lin wrote:
>> Regulators need to be available early in init in order to allow them
>> to be available for consumers when requested.
>>
>> Other regulator drivers are already moved to subsys_initcall(),
>> looks like only lp3971 is missing.
>
> My 2 cents: it is safer to create such patches with real HW when there is a
> need (we deal with a similar situation in i2c). Janitorial might do more harm
> than good. Another option might be to call the patch a RFC?

Thanks for the comments.
I appreciate if someone who has this device can test it.
I only have a similar device ( lp3972 ) and it works with using
subsys_initcall().

Regards,
Axel
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
> Version: GnuPG v1.4.9 (GNU/Linux)
>
> iEYEARECAAYFAkzjjlUACgkQD27XaX1/VRsF2QCfQn/bCEZSb0qkn1aj9SpqxsST
> zlMAoIyd6I+c4XitD1KRHe53/n3wlXOQ
> =MQc1
> -----END PGP SIGNATURE-----
>
>
