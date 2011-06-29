Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279Ab1F2GNt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 02:13:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60881 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027Ab1F2GNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 02:13:47 -0400
Date: Wed, 29 Jun 2011 16:13:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, randy.dunlap@oracle.com,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: rtl8192de: Fix build errors when using allyes
 configuration
Message-Id: <20110629161338.7d265efd.sfr@canb.auug.org.au>
In-Reply-To: <4e0a6a06.Y78QUdJvxEiJ3SGd%Larry.Finger@lwfinger.net>
References: <4e0a6a06.Y78QUdJvxEiJ3SGd%Larry.Finger@lwfinger.net>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__29_Jun_2011_16_13_38_+1000_yhZUHVUzkF2s2xjL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__29_Jun_2011_16_13_38_+1000_yhZUHVUzkF2s2xjL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 28 Jun 2011 18:55:50 -0500 Larry Finger <Larry.Finger@lwfinger.net>=
 wrote:
>
> After adding rtl8192de to linux-next, making the rtlwifi drivers be built=
-in
> results in the following warnings:
>=20
>   LD      drivers/net/wireless/rtlwifi/built-in.o
> drivers/net/wireless/rtlwifi/rtl8192de/built-in.o: In function `rtl92ce_s=
w_led_on':
> (.text+0x11fb6): multiple definition of `rtl92ce_sw_led_on'
> drivers/net/wireless/rtlwifi/rtl8192ce/built-in.o:(.text+0xa326): first d=
efined here
> drivers/net/wireless/rtlwifi/rtl8192de/built-in.o:(.bss+0x0): multiple de=
finition of `dm_digtable'
> drivers/net/wireless/rtlwifi/rtl8192c/built-in.o:(.bss+0x0): first define=
d here
> ld: Warning: size of symbol `dm_digtable' changed from 40 in drivers/net/=
wireless/rtlwifi/rtl8192c/built-in.o to 48 in drivers/net/wireless/rtlwifi/=
rtl8192de/built-in.o
> drivers/net/wireless/rtlwifi/rtl8192de/built-in.o: In function `rtl92ce_s=
w_led_off':
> (.text+0x11cfe): multiple definition of `rtl92ce_sw_led_off'
> drivers/net/wireless/rtlwifi/rtl8192ce/built-in.o:(.text+0xa06e): first d=
efined here
>=20
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

I have added this patch to linux-next for today (and it fixed the build fai=
lure).

Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__29_Jun_2011_16_13_38_+1000_yhZUHVUzkF2s2xjL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOCsKSAAoJEDMEi1NhKgbsUHQH/3gIvDMsQ8RI/veGWU2os2Xy
qZzpg17/WUDMosdwAfrTtsFUrpPpe+Z7cDnye4/NMoowGwDdoE8FAW6OauMuPbV6
517aHdw4Hth5b1q2F66EU37quzCPWQj4FYYzrN/1W5aL26tACsK4wQpV6DfC8b+E
AgMvfBnADqFXRKZFpq1gtVvboLNFP9j0jbJLJ37QAyykNuHri+IBF0vxTZODbdQr
ebsNeuei/9e9o2LTIdt+3PLoTubI+jNUxx1AoxjchW3Qr75mV8LSRw8RcdlTDo04
xVvxJP2+tSZ6oxs13BiMGGaobvLqrpocBfvmDjbtGHtvJJ9hWKpdf3zvBsE8lVY=
=ReGl
-----END PGP SIGNATURE-----

--Signature=_Wed__29_Jun_2011_16_13_38_+1000_yhZUHVUzkF2s2xjL--
