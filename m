Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab1G1Mv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 08:51:29 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:45401 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754996Ab1G1Mv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 08:51:26 -0400
Date: Thu, 28 Jul 2011 15:51:20 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tommy Lin <tommy.lin.1101@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Anton Vorontsov <avorontsov@mvista.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] arch: arm: mach-cns3xxx: Add gpiolib support
Message-ID: <20110728125119.GD9069@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1311873401-26075-1-git-send-email-tommy.lin.1101@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JGq01gMRpXZxBGpH"
Content-Disposition: inline
In-Reply-To: <1311873401-26075-1-git-send-email-tommy.lin.1101@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JGq01gMRpXZxBGpH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jul 29, 2011 at 01:16:41AM +0800, Tommy Lin wrote:
>  arch/arm/mach-cns3xxx/gpio.c                 |  692 ++++++++++++++++++++=
++++++

why is this driver under arch/arm/mach-cns3xxx instead of drivers/gpio ?

--=20
balbi

--JGq01gMRpXZxBGpH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOMVtHAAoJEAv8Txj19kN1+LwH/3D1yxGfoqSozGqqnXLeQF8D
YoZ4DYzyL8jrFoaaC0cyTr1dNKREKWnXUasBK42+4ELSoj3Xcsl4hgmvZG4MWsfT
piX+FWxpjJhsoJgWouvr8vAofrcv4i3z2BiHqsW2p3UlsRnMwgAwVnDlhkxz9v/X
G12dotXm+0gWmpdiKVi7TYA+/O93XqaHWUL9vB4AB7sdciY58QIRuX8Rsg7mgrH0
/JGkS6zz5ZLcqdjexejRXYAYFLDp6q/pjIfjLuTcbCGGDqMYJHayeyTGOwYNwOKJ
qpE3oA73bPa1Fp3pqfdTu3p7t5hMZWqjGSgn6QhHL2DBhJanIcsKfJktgnn57SY=
=ot0v
-----END PGP SIGNATURE-----

--JGq01gMRpXZxBGpH--
