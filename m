Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936160Ab2KAWxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 18:53:41 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:40107 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760291Ab2KAWxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 18:53:38 -0400
Date: Thu, 1 Nov 2012 20:53:31 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: Marcos Chaparro <marcos@mrkindustries.com.ar>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath3k: Add support for VAIO VPCEH [0489:e027]
Message-ID: <20121101225331.GB1915@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	Marcos Chaparro <marcos@mrkindustries.com.ar>,
	Marcel Holtmann <marcel@holtmann.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201210291009.12913.marcos@mrkindustries.com.ar>
 <20121031182532.GD1679@joana>
 <201211011940.45569.marcos@mrkindustries.com.ar>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LyciRD1jyfeSSjG0"
Content-Disposition: inline
In-Reply-To: <201211011940.45569.marcos@mrkindustries.com.ar>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LyciRD1jyfeSSjG0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Marcos,

* Marcos Chaparro <marcos@mrkindustries.com.ar> [2012-11-01 19:40:45 -0300]:

> Added Atheros AR3011 internal bluetooth device found in Sony VAIO VPCEH t=
o the=20
> devices list.
> Before this, the bluetooth module was identified as an Foxconn / Hai blue=
tooth=20
> device [0489:e027], now it claims to be an AtherosAR3011 Bluetooth=20
> [0cf3:3005].
>=20
> # cat /sys/kernel/debug/usb/devices
> T:  Bus=3D01 Lev=3D02 Prnt=3D02 Port=3D04 Cnt=3D02 Dev#=3D 11 Spd=3D12   =
MxCh=3D 0
> D:  Ver=3D 1.10 Cls=3De0(wlcon) Sub=3D01 Prot=3D01 MxPS=3D64 #Cfgs=3D  1
> P:  Vendor=3D0cf3 ProdID=3D3005 Rev=3D 0.01

I actually need the output without the patch in, showing the 0x0489 vendor =
id.
Sorry, but we like to document the devices we add support properly.

	Gustavo

--LyciRD1jyfeSSjG0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQkv1rAAoJEPs3PUX4s20oDNMP+wZbeZ9I/rPD5hOmowrG8W0y
5Y4u/x1a/IEGA4txbVh9RiPRarjW0Lj5vRektzPubxkJkGzd5cVdlmxMUwM6FSx1
7O2SfEWPd4ToT9UyIusNx5+7yjVGQT8EYo1XBaypAqRpgdj4DhDnfGQ2q3sR31EP
g0XwE/fpdaInTQDP08/khOR5dZpXSzbLIVr0ohuXjO+NgG1qJZVDwcVTgh1bqufb
d6hWtP5IxWpj/vW90DU8yXW8uiqmNmXjPEbc6WmCbNyOb1houIhKfvMk9+1+zzzD
g+Zjz8Rtz7qxInFEhzpKB801YHHDNLAZz48v43ida034lYgA4Ugm6PUAM9WHRJ8v
hDX3DzUURYsYhXdWumJDCTcsYTmnTX60qEEmj7zV3bwAAWW3CLwhKamtvAWV8wNC
WvMA+P8u+usR0a3n4iSflfth+3PFEQIwwMBzBwsm/IYLEkRMHzOAyt1gNyK+yt1Y
okyiTjB20EPdGHEUfcxBJn0MEj6QE/PVhgIwMwTCh7xgChMBNTuAJ3BDx4qjJydG
mL1OZYs0AAxvuHTUmz39C842O32G8AXwUuP7qyT7O9gqbLghPmJQ7nVhB5GUdqTJ
ipO6e1J3mZhR2keZl18JlLNEMZgLE6/UYk2wyZz4oEr1Mt0co1/ADQHdZ1Jce0QM
ZMujIxbmH++WCrY8KLrB
=7LkB
-----END PGP SIGNATURE-----

--LyciRD1jyfeSSjG0--
