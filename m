Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab2JOMUw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 08:20:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33992 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388Ab2JOMUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 08:20:50 -0400
Date: Mon, 15 Oct 2012 15:15:09 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Philippe De Swert <philippedeswert@gmail.com>,
        Philippe De Swert <philippe.deswert@jollamobile.com>,
        Praveena Nadahally <praveen.nadahally@stericsson.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 1/1] musb : remove generic_interrupt and have all drivers
 define the isr on their own. Remove some unneeded CONFIG_SOC_OMAP_3430
 instances
Message-ID: <20121015121509.GL24333@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1349369952-7036-1-git-send-email-philippe.deswert@jollamobile.com>
 <20121008163451.GF3874@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RD6GsZsdEJvsf78O"
Content-Disposition: inline
In-Reply-To: <20121008163451.GF3874@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--RD6GsZsdEJvsf78O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 08, 2012 at 09:34:51AM -0700, Tony Lindgren wrote:
> * Philippe De Swert <philippedeswert@gmail.com> [121004 10:00]:
> > This patch is based on the discussion of a previous patch to fix an iss=
ue
> > where the omap2430 musb driver is not working for N9/N950.
> >=20
> > Moving all the interrupt handling to the devices. Avoids inclusion of g=
eneric
> > interrupt and breakage due to sometimes misleading CONFIG options. This=
 makes=20
> > sure usb always works if on of the subdrivers is chosen. Tested on Noki=
a N9/N950.=20
> >=20
> > Partially clean up CONFIG_SOC_OMAP3430 which is not necessary in the ca=
ses
> > where I removed it. Also helps with the removal work of those options t=
hat=20
> > Tony Lindgren predicted would happen at some point.
>=20
> Thanks looks OK to me:
>=20
> Acked-by: Tony Lindgren <tony@atomide.com>

Can someone please resend this patch with Tony's Ack ? We have some mail
server change recently and I lost a few mails in the process :-(

sorry

--=20
balbi

--RD6GsZsdEJvsf78O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQe/5NAAoJEIaOsuA1yqRESJUP/jKgA7FgG3Ot8FNU/0nsPwG2
d4HjppmdcFbQ6BtdIjGKZTxMphsqwVHOcPQdVm4oJ1AS1gYu7LwdZmGqRyQMfB9t
MsrfTCTW35BQEmQ1NwGL8qvofFYGaM9kJEi8sIAUcM/BNxOOsjS9SVUkRqJBTUqB
5I+gr+igHvjYjEnrZmb6TV4huSZI8DsmQE1SMMsENEmoVlW1P2aNIDDbnatuSirp
IzeiNVGJQR+ltJ7+fpuLdR+ayuR1cdxAVHJwlTUZnfXxFUGcvN2IS810l5GSnZ6q
0ImT5Nq7YgtWLNUMeE5GgYW1fvAmeHBll082A1+Fy00yVcmlzWXf3tLOjktjyxwI
kJEBNhDDieBoDIIvwiBJkR/r03ASBaRDm5IROeqwce7+GPVsfPkLbhtHqGM0ri4h
5t/yvJBghraqYaHJCo+ZpxZVhKRxySrJC5FoxMYhP3vzspQ2vDaRNvqpCv9lahye
EUBG1TUWD+aiUXcjnOZoa86AxwqpIJHDygrd4tEL/WcaeJPn+Q6u1R07aprVRFzQ
6a2koPTvbJvPCJMi3yvMhhkAiLb0qRy+llhO0sLlvmKrRjGBe/7ugpxbcC/1JiRJ
pkujocuoa8Ypk3r/SXXpoT5Efbfb03+7YBn5VSJG0njqvsIgTMj8q539KQ15/zze
Au+zElBenHAgtmHebxRC
=TrBk
-----END PGP SIGNATURE-----

--RD6GsZsdEJvsf78O--
