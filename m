Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab2EBIw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 04:52:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57167 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755183Ab2EBIwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 04:52:25 -0400
Date: Wed, 2 May 2012 09:52:21 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: jonghwa3.lee@samsung.com
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org, cw00.choi@samsung.com,
        Chiwoong byun <woong.byun@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] MFD : add MAX77686 mfd driver
Message-ID: <20120502085220.GC4075@opensource.wolfsonmicro.com>
References: <1335776022-4571-1-git-send-email-jonghwa3.lee@samsung.com>
 <20120501165825.GA3264@sirena.org.uk>
 <4FA0BF9C.7090107@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JWEK1jqKZ6MHAcjA"
Content-Disposition: inline
In-Reply-To: <4FA0BF9C.7090107@samsung.com>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JWEK1jqKZ6MHAcjA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 02, 2012 at 02:01:16PM +0900, jonghwa3.lee@samsung.com wrote:
> Hi Mark,
>=20
> You point out many things. ;-) Thanks for your concern.
> I want to explain one by one.

Don't top post!  http://daringfireball.net/2007/07/on_top

> 2. Those steps is needed for wake-up interrupt occurred by 77686 irq.
>    When system has woken up from Suspend-to-RAM state by 77686 irq,
> 	then it never call irq handler.

Why?  Are you sure you aren't doing something like requesting the wrong
trigger type for the interrupt?

> 4. This will work when I2C interface is changed according to board
> 	revision with board configuration.

> 5. This is for some board that doesn't use RTC. (e.g. SMDK board)

Since you top posted I'm really not sure which comments you're referring
to with these...

--JWEK1jqKZ6MHAcjA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPoPWxAAoJEBus8iNuMP3dvAcQAJW06U1QnFxWUYHhUUpjtt/X
mLHOUd62u+Kcbunz4BevLXIo/bHTV6pjdyqfuXIFC+zZbkINE9Ca4grJ4XhpPVYU
aZG94aQIJ9YCjJftlxufJyPjJ+QLNbBZqp3C5H11ADhHcKHIUSNqJ3Xk4v99UlFs
vkdXVVAR5jNWyAFeFuhBW7U1qDcRorJhxDlADL/UD7+QTIwi5G3RHFcQ7BwIs78q
TNmUvzUJ1N+w0ecHIf4wPhnlBldZLENeP2iE8xcVic99gJ6EHuKde6ELbN42tp9D
i9OY5V5sUt8qUvgocGxiAz8z1fEiXRKhG4+5n5Gw3DN5mwdlVRxfM9TvtuIWnLQb
qQ3/os34HciphKPN7+v3BynOj2sWxQXk8SjL2XT9B77JQqsEE8BVk+QlMcdecK2a
NNYAbItX3DSGInzkMi1Y4tsnehTiDfyP+pLlw9GMBMKWNfnzoGNECljskN9BuT5Z
aTJmZ+3Qbol/GJYbBCnfvW2c/yV3blgp6O1/V4D1zCd0Hu+R56oJi8e2YF8cPwP9
Re0x4ILb8piEcjUXwTJ9MKpmnmZ532tBRMv7i1p6TgIrFZwVuxMs4tg29FJojObt
hpk2f25fDvmZMS0XHS3IF4cCDaZszTnbONwZfFC9IVqVYnz92abduVSYVojUpFHA
9QAE7OwL7e00zgvBnvtO
=QfiM
-----END PGP SIGNATURE-----

--JWEK1jqKZ6MHAcjA--
