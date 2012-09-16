Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab2IPQol (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 12:44:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58412 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751747Ab2IPQoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 12:44:13 -0400
Message-ID: <1347813844.13258.287.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 34/95] USB: option: add ZTE K5006-Z
From: Ben Hutchings <ben@decadent.org.uk>
To: Thomas =?ISO-8859-1?Q?Sch=E4fer?= <tschaefer@t-online.de>
Cc: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Sun, 16 Sep 2012 17:44:04 +0100
In-Reply-To: <201209131722.19730.tschaefer@t-online.de>
References: <20120909224155.514234762@decadent.org.uk>
	 <87zk4xm2cd.fsf@nemi.mork.no>
	 <1347416977.6699.1.camel@deadeye.wl.decadent.org.uk>
	 <201209131722.19730.tschaefer@t-online.de>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-JBVLMVCfkv0vN8M+xTn0"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JBVLMVCfkv0vN8M+xTn0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-09-13 at 17:22 +0200, Thomas Sch=C3=A4fer wrote:
> http://git.kernel.org/?p=3Dlinux/kernel/git/next/linux-next.git;a=3Dcommi=
tdiff;h=3Dba9edaa468869a8cea242a411066b0f490751798

I've added this and the previous change to the queue for 3.2.

Ben.

>  index cc40f47..5ce88d1 100644 (file)
> --- a/drivers/usb/serial/option.c
> +++ b/drivers/usb/serial/option.c
> @@ -886,8 +886,6 @@ static const struct usb_device_id option_ids[] =3D {
>         { USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1010, 0xff, 0xff=
, 0xff),
>           .driver_info =3D (kernel_ulong_t)&net_intf4_blacklist },
>         { USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1012, 0xff, 0xff=
, 0xff) },
> -       { USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1018, 0xff, 0xff=
, 0xff),
> -         .driver_info =3D (kernel_ulong_t)&net_intf3_blacklist },
>         { USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1057, 0xff, 0xff=
, 0xff) },
>         { USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1058, 0xff, 0xff=
, 0xff) },
>         { USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1059, 0xff, 0xff=
, 0xff) },
> @@ -1092,6 +1090,10 @@ static const struct usb_device_id option_ids[] =3D=
 {
>          .driver_info =3D (kernel_ulong_t)&zte_ad3812_z_blacklist },
>         { USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_MC2716=
, 0xff, 0xff, 0xff),
>          .driver_info =3D (kernel_ulong_t)&zte_mc2716_z_blacklist },
> +       { USB_VENDOR_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0xff, 0x02, 0x01) =
},
> +       { USB_VENDOR_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0xff, 0x02, 0x05) =
},
> +       { USB_VENDOR_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0xff, 0x86, 0x10) =
},
> +
>         { USB_DEVICE(BENQ_VENDOR_ID, BENQ_PRODUCT_H10) },
>         { USB_DEVICE(DLINK_VENDOR_ID, DLINK_PRODUCT_DWM_652) },
>         { USB_DEVICE(ALINK_VENDOR_ID, DLINK_PRODUCT_DWM_652_U5) }, /* Yes=
, ALINK_VENDOR_ID */
>=20
>=20
> I tested the new patch with linux-next-20120913
>=20
> It works as expected, at least for the K5006-Z.
>=20
> Sorry for the confusion I triggered. I have no clue about the best
> matching methods. My focus is on testing.

--=20
Ben Hutchings
Experience is what causes a person to make new mistakes instead of old ones=
.

--=-JBVLMVCfkv0vN8M+xTn0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUFYB1Oe/yOyVhhEJAQp17g//bodVml0Gw94FbaDxPyP6gMw2Obm9H646
pkWKlUGMjSJ0GHX4L9kdGe62uGhOLP8Ytg/b5dwaTWW+AlRQ1ucRrX0GzerFNw6F
1hSNvEGDNRRneJAbN7djjouSmG83xb6TeAHmC3cgeKwduIPaHnTS7+K8/q0OX+Ow
NXVnmSybr+cLe1hjey41K+1uTzsVqRRNPX2G6Mod9HWWb1XjCVAsouKef5LnzRn1
+oKrxKcjwLBPUCgE8yc2QLYMpCYgg/FOf7uwt12hxjUv7piUU8fkIfL0P4jhltyz
owxXuVS/VWO2xadLn6CnGETf4FVdf6o732I50FhQS3steKO2FjGHu8yRtMN2U82q
7ULGol7CCx/KOC148suLFCS21bMAjY+s32FG+Sxl1TWr+aRPfiEW+itDpaNe6lul
m6BRDuCzNtwWJfGVmITAslvEdzA0IeRsF/3G831S3T8q+WUlBv/RYIOIEDnabD1J
Y+mPMPr+sl4JxkcdPNDfArPbQC4LMR7U9xMBA6onAbyrdsVjZk37hzjRRAJ1R6Or
8ohYRwKT1IrjkSaI0vMGjoOJLLMt0lLYpoaDaYJJHh/Da4rr0TQcXT/sOqvCGbxO
KMsSaTIhzFQyDeLwD+6J8nuIl/cMP8c2luBdPS8+bKFOxPYKjZSOOiOrg/7pZWY+
mi5VDNyoqPc=
=BebN
-----END PGP SIGNATURE-----

--=-JBVLMVCfkv0vN8M+xTn0--
