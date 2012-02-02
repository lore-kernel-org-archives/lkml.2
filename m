Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab2BBMP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 07:15:57 -0500
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:50342 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755903Ab2BBMPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 07:15:55 -0500
Date: Thu, 2 Feb 2012 14:15:48 +0200
From: Felipe Balbi <balbi@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: balbi@ti.com, "Gupta, Ajay Kumar" <ajay.gupta@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Pasupathy, Visuvanadan" <vichu@ti.com>
Subject: Re: RFC: usb: musb: Changes proposed for adding CPPI4.1 DMA
Message-ID: <20120202121544.GJ29134@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <47CEF8C4B26E8C44B22B028A650E0EA9317C5B92@DBDE01.ent.ti.com>
 <4F22CC37.8010307@mvista.com>
 <47CEF8C4B26E8C44B22B028A650E0EA9317D2B9D@DBDE01.ent.ti.com>
 <4F27D011.8060203@mvista.com>
 <47CEF8C4B26E8C44B22B028A650E0EA9317D9346@DBDE01.ent.ti.com>
 <20120202090923.GC9948@legolas.emea.dhcp.ti.com>
 <4F2A6FAC.8010906@mvista.com>
 <20120202114911.GH29134@legolas.emea.dhcp.ti.com>
 <4F2A7B4D.4070509@mvista.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AwgMNpd3VkAVXjS"
Content-Disposition: inline
In-Reply-To: <4F2A7B4D.4070509@mvista.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7AwgMNpd3VkAVXjS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Feb 02, 2012 at 04:02:21PM +0400, Sergei Shtylyov wrote:
> >I want to remove direct access of musb from glue layer, and at some
> >point I will have to do it in order to fix a few problems we might still
> >have with modules, basically because glue layer could be trying to
> >access memory which was freed already.
>=20
>    We can do:
>=20
> void musb_platform_read_ints(u8 *usb, u8 *tx, u8 *tx);
>=20
>    That's what I thought first about but then got lazy. :-)

hmm... yeah, that's doable. Looks nice, actually. I'd ack that

--=20
balbi

--7AwgMNpd3VkAVXjS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPKn5wAAoJEIaOsuA1yqREQVYQAKhrWNDDNySplSgkX5qdlaXf
aQWsOtp7Zgdml5Cm0k+IwQUjgJJ37iVyAcOPFfl+oza4C50c3U7GNp24qgBIX+tJ
fHPcSV55t2X+B1S40Ic5fweHSOM6iC83BFz4INXurLayzw43bcJZuXFWM+H7tEFf
Y/F4STf+8LeMeiJJdZAT1824Ug4VBvUx7PmQvlcmiWeT9tE6xRVIediD8CjbjuXq
qsAZe0b2mtp1oANli0WNc6JljIzpOTl0EWw/oMppFbRnPkXe8/qBWfdZ3gdjtxN2
rdVrFdHDSsj6pvMURuoHx197km/FrSE97ZUEHCO50skkzNKvbw17BuODniiktyM9
2LmKtOAsJiHUPYceGhk/xsIlL0cX6KyHFRG9qNzxSngAdSPn+IuFC/bBLD8+ffpm
UU3i+bHLY6kQ97HQOD+b6CxUDGCLmazkQCf33Z89oHWoynpBI1+UJuHzcxsGTTPi
DXGwfcGPDkslvmIbRucFH0HvHjRpgEF91HX0Mbg+wMclAuMg1LwjGFu8WRbmeBvN
knyBb5hfzBdxtsRGQuvHPyPJoZ5VGM5YQNjZM+hufEeoqXJ2dw1jkmecPuQ2LcCI
dkZ1uMTokKO9SipwvFJaFqZoqoUKMDR3nd931SpbFnQmi6qaKdozKB8PTi8biirl
34yvM1Nlr2ftHLg9F/qz
=9Xf/
-----END PGP SIGNATURE-----

--7AwgMNpd3VkAVXjS--
