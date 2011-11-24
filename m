Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab1KXJkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 04:40:37 -0500
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:40674 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755103Ab1KXJkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 04:40:31 -0500
Date: Thu, 24 Nov 2011 11:40:26 +0200
From: Felipe Balbi <balbi@ti.com>
To: Neil Zhang <zhangwm@marvell.com>
Cc: Peter Chen <hzpeterchen@gmail.com>, Greg KH <gregkh@suse.de>,
        "balbi@ti.com" <balbi@ti.com>, Haojian Zhuang <hzhuang1@marvell.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] USB: OTG should be linked before Host
Message-ID: <20111124094024.GL3352@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1322044728-27080-1-git-send-email-zhangwm@marvell.com>
 <20111123161759.GA27000@suse.de>
 <CAL411-o0k_=HN+LH4Vx07=DTPOhs6iZuDXjdo1daBHov85Etaw@mail.gmail.com>
 <175CCF5F49938B4D99B2E3EF7F558EBE19FD172883@SC-VEXCH4.marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NZiXfHLGvOGtDZMn"
Content-Disposition: inline
In-Reply-To: <175CCF5F49938B4D99B2E3EF7F558EBE19FD172883@SC-VEXCH4.marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NZiXfHLGvOGtDZMn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 23, 2011 at 11:19:44PM -0800, Neil Zhang wrote:
> > -----Original Message-----
> > From: Peter Chen [mailto:hzpeterchen@gmail.com]
> > Sent: 2011=E5=B9=B411=E6=9C=8824=E6=97=A5 14:06
> > To: Greg KH
> > Cc: Neil Zhang; balbi@ti.com; Haojian Zhuang; linux-usb@vger.kernel.org
> > Subject: Re: [PATCH v1] USB: OTG should be linked before Host
> >=20
> > On Thu, Nov 24, 2011 at 12:17 AM, Greg KH <gregkh@suse.de> wrote:
> > > On Wed, Nov 23, 2011 at 06:38:48PM +0800, Neil Zhang wrote:
> > >> For OTG controller, the host driver will call function
> > >> otg_get_transceiver to get the otg transceiver, so we need to init
> > the
> > >> OTG driver before HOST.
> > >
> > I agree with it, at freescale i.mx platform, we also need to init otg
> > first, then the host
> > if otg function is enabled.
> >=20
> > > How do you handle this if these drivers are built as modules?
> > We require the user load module by order, and write it at UserGuide.
> >=20
> > I find at older kernel version, like 2.6.38, the otg was built firstly
> > at usb module.
>=20
> Actually, it was changed by the following patch.
>=20
> commit 4661ffc91befc8c5ee080720120da1d53851060a
> Author: Felipe Balbi <balbi@ti.com>
> Date:   Thu Apr 7 10:59:34 2011 +0300
>=20
>     usb: don't enter usb subdirectories directly
>=20
>     Instead, make we enter usb/ directory on all
>     needed cases and enter the subdirectories from
>     drivers/usb/Makefile.
>=20
>     Signed-off-by: Felipe Balbi <balbi@ti.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>=20
> Hi Balbi,
> Do you have any concern to change it?

not from my side, we need the transceivers before the DRD controllers
can probe.

FWIW:

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--NZiXfHLGvOGtDZMn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOzhEIAAoJEIaOsuA1yqRED90P/2zKdSk5tWwzWO99dKIWBI+B
Y3JgQMtmm2RM2CaSj1ajDsV1VPt8oZBCG8joA6iouTT7iLdEyxBoXApqSy5w6iuG
fljOClc/8o5BOMp+02Ic6oBZshVHu1trLxp3L3OuVR9sr5R4JW9DwMbvB6BaAWmR
QPXhWD+RY1kAJ03G9ZTcO203q3vEusTLnRYC18uIvKqDzH1ObIrZPQS0fYlhWnMT
TfCR43zD5MvaVYnP727l6sdJOqlsca/ymHGf4UUNSZcNU7kj//FxLOjgTHVsEFPN
ljyfUnWzu9DhQcXqK7Fne5IZfYU0tkZbPsI0kImqn1+luq9yzPF0pyGnhT4KafOl
HbJ99iGErLWUZfcXyLzi1/GBvyqQ8k9KDysho8IaYX3plgpRKSlwwfsUO5SolA+9
33602jfB99SONzyQQTnK+SyrH/8BjUEyq4YAG9BEdElo91kV0VJLKgW8olRUKJOt
udG2zqGd6KXC5V0dcIm1VboxpUG8OQB+99ligLfXOJXg4kkBEH647azPXxZgXoUr
94j6Ijuh++cbKdl7m2M69Z/P/lrZoB8LFY2c4Livho5rrsGqaqmhfvr/wdCdPO5E
4XhAd889p/laOJ3OID6Ge9wwEFehSscvh3p5vypEOehuSptF+Yw7NBUW+lB5fjho
S3k5RqPj8+xLguwZMk/N
=NsnZ
-----END PGP SIGNATURE-----

--NZiXfHLGvOGtDZMn--
