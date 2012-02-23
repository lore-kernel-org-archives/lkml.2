Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab2BWQa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 11:30:26 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:52628 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753406Ab2BWQaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 11:30:25 -0500
Date: Thu, 23 Feb 2012 08:30:16 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: stable <stable@kernel.org>, mjg@redhat.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
        "jirisl >> Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: Lost ps/2 input in 3.2.5 (aka PCI: Rework ASPM disable code)
Message-ID: <20120223083016.58cba319@jbarnes-desktop>
In-Reply-To: <4F4540E6.2020708@suse.cz>
References: <4F4540E6.2020708@suse.cz>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/hPzAcRr.9f9HlU54s+jXrO7"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/hPzAcRr.9f9HlU54s+jXrO7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 22 Feb 2012 20:24:22 +0100
Jiri Slaby <jslaby@suse.cz> wrote:

> Hi,
>=20
> so I finally decided to commit 3.2.5 into the opensuse kernel. However
> it does not even work on my laptop.
>=20
> Both keyboard and touchpad are not detected. They are connected via PS/2.
>=20
> I see
> PNP: PS/2 appears to have AUX port disabled, if this is incorrect please
> boot with i8042.nopnp
>=20
> Without that patch this warning is gone and devices properly enumerated.

Does it also work if you pass pcie_aspm=3Doff when you boot?

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/hPzAcRr.9f9HlU54s+jXrO7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPRmmYAAoJEIEoDkX4Qk9hdm0P/3gbpB+nulwu3hKcQf+k6Zal
wMYobY9tXgxq0bMwl6OHFw0DuLqUT9JBrGUXfg6x1gx+NWx9skQk1KpbcNM/w6uq
f1NSjqgME+19qc5rHx00cXbXMKTDLXIKqY+K+n8IfBVVQx8I6ChmIDSWPUxynYUk
TGJNcpfYiVDQJ0IpB8IduBk/LkIYpSV2msxasWYlNZctzG7ybVlwPHqzEYYhYg2F
Q4SSmFnRICzvgWnJuIrFaqYhEq3WbJ6i+F6ZAl+QP7Hyeb4+zCtPLV/xs++US1Gy
vHQ1ZmIHn5WbtGhR5H2h/W+S7FqyLKh8icrUhFAvZSgaInv4KPrHdt9TdBz51Ed8
caZGXHdxB60TnEGGKnzSFoHuA6cFsWVRrHO95JmaWwZ9HvpquCEt83TNAoBLMI9d
j4fJjO1QbLXxmXb2kZkKgxE1+xcuNGjvOP3awPkcf+g3DcIvDamsMp4zjzlv6Ku5
TGeStDBijipC/yvjIC9Vh0kRsxY2aCg+yA9AU9zYZh5YqMZklfURGAR0C/hxYjGy
PrV+MIwwdKA/WKUnP3duA+7P+DeDEK1wPG4eJvsxXTFm0eGfNCNHrUskoRMBQpTy
K6+ctCS2m6NIvU4MWPfFBoGRokt/c7WJKF+OotppM7jhaMc+2AUJrERrDu7o88xE
z7q7k8mYQu3+RU+NJNvk
=FqXE
-----END PGP SIGNATURE-----

--Sig_/hPzAcRr.9f9HlU54s+jXrO7--
