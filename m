Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837Ab2BXQvy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 11:51:54 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:33622 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754135Ab2BXQvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 11:51:52 -0500
Date: Fri, 24 Feb 2012 08:51:48 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/13] x86, irq: support ioapic device hotplug for x86
Message-ID: <20120224085148.138c08d8@jbarnes-desktop>
In-Reply-To: <1330055339-11662-1-git-send-email-yinghai@kernel.org>
References: <1330055339-11662-1-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0jLPwBR1=+eYBrk81wtCGXN"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/0jLPwBR1=+eYBrk81wtCGXN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 23 Feb 2012 19:48:46 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> Hi, Thomas
>=20
> Current x86 code does not support iapic hotplug yet.
>=20
> This patcheset will try to pre-reserve irq block in allocated_irqs bitmap.
> for hot add ioapic controller. also record irq_base in gsi_config, so lat=
er
> could use it to convert gsi to irq for pci device using that ioapic contr=
oller.
>=20
> need to update x86/irq to support realloc_irq after those bit are pre-res=
erved.
>=20
> It is tested with pci remove/rescan method plus some test stubs.
>=20
> Please review them.

Suresh or Matthew may be interested in this patchset as well, and it
should go via -tip.

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/0jLPwBR1=+eYBrk81wtCGXN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPR8AkAAoJEIEoDkX4Qk9hN28P/3oMqvAMXEnRiKecgcLiPJno
Ft1mRoAXHWiedYCEIaUt+3FkKS5xRu0nQHymfAx/Tlv4H6by3Sbzp8ryGwFQUVFR
4vDugHr7A+4heQbjQWl4iIH4kElWfwme8zAT45F/sLChQ1ztmc0kxsiUPoqcUiUG
vU/GRe+mNS+zuDSGgvYp0PuOe5EETHkAOhVaHvuqQ4e85JAgSTbkYX/dqF4cT078
mlc2S5100cu7/z6BOVaw1fH7j/yJcEfQTotVeHPkxh1FvZ5giPT7v6N7zkAPKWkB
EIhPl2cG4/TuMdGvyS8Z3VowBVlz6+4XZiZsjpD4cNfrirONfytVJ8BO0xatwFrO
vSgZ37RH2OBVDg+tgfMK3fI5zPLdiMiQlYx/p8UxLBCiiesSOPWTfvLpHOfu4ilF
AFyGObSwdLCUYQ6fzoIuQpz/DoUMIChzZ/f0tbpf6kq5YCAkAwW3KbOXQywJoJfG
Rt6oa/5a5VzaTTttj8NTkm9woYdp+9v1hwkP2Vnd1YGSBuuNNErQzC24wAqBhuNa
ZsMxuU3RuA1mRAIfxVplF6gDIpzi8bAbtGJtmttTuw1d0pFbgBlsnulWoY//TQLb
radbV/vPcADzudupISRZ+QJzWd43PLB86K/ilbER/hK8MygbHgdQsSR4lEGFUlLJ
s6ZQmLjjxCalNLfwbxPQ
=mjMm
-----END PGP SIGNATURE-----

--Sig_/0jLPwBR1=+eYBrk81wtCGXN--
