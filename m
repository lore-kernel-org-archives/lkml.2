Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab1JNQIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 12:08:09 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:49293 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754436Ab1JNQIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 12:08:07 -0400
Date: Fri, 14 Oct 2011 09:07:58 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] PCI / PM: Remove unnecessary error variable from
 acpi_dev_run_wake()
Message-ID: <20111014090758.23aabe2d@jbarnes-desktop>
In-Reply-To: <201109282144.36766.rjw@sisk.pl>
References: <201109280001.28857.rjw@sisk.pl>
	<CAErSpo4CpEWaKkh280Kb_nNSVWfYKGZ06HQOrpLar=T40TyDZQ@mail.gmail.com>
	<201109282144.36766.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/6rdyMPwG+D8DnP8H1820CIX"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/6rdyMPwG+D8DnP8H1820CIX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Sep 2011 21:44:36 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PCI / PM: Return correct result from acpi_dev_run_wake()
>=20
> The result returned by acpi_dev_run_wake() is always either -EINVAL
> or -ENODEV, while obviously it should return 0 on success.  The
> problem is that the leftover error variable, that's not really used
> in the function, is initialized with -ENODEV and then returned
> without modification.
>=20
> To fix this issue remove the error variable from acpi_dev_run_wake()
> and make the function return 0 on success as appropriate.
>=20
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Applied to linux-next, thanks.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/6rdyMPwG+D8DnP8H1820CIX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOmF5fAAoJEIEoDkX4Qk9hwBYP/0eBtWd8sfHIhw8mXrbRY+pR
yBdeS/YhTTB3EZxeV4pi675QcfbIHGvQIjkSKhATKlqVsS1vWLiMWVfFLawZg2Ir
nL8ZzReQrmiAM3psWWCpkLGy8Du0/KvndyxCdfeGOPsF6ir35QPnx7H6n7cniTVy
2MOoELuUkmXqtKCw8L/MqNowj+fKf+H1cPDZmH9KqVb+mz8mavwszSC8AGLyGimS
s83MPeSGPZsA96q/C+jyKl2IDjZUu+KZnogKcPjMaYD6kSfk6s8LK7ANu67qgOj2
FgKVtZ7VBQ5wmRTfjSa4wb0D5InLpuIYCJdhPJtw01KbsCyLcaQLIQkQn6mPF0+8
+6SZCw9NmTlD6UT3NARMsUEoh2iMEULx1O96FPl7qT94b7YJ2OF/8XbGyFj4SOem
eVtPTSqB0IaIVTvXFUHDX2DZM/Exs7FEoB/wqorm48iS/jPrgHBguu+HoN4V5suD
ZKS0FFCpxIj/9rUYcJdG7gSl1KLmitTL4TnIo0ni9Vj7D7yyYRi6q8LuNqQHkYzO
TmiCsFF9ZSYsYNeqduuDNm9vj/1RfDoo6Up4pI3cF8tvKlp9CJluo/oWMNWujI1K
wPFc6wukDlvlxzGRUOYK6Ml52VsbPX7/PcviDmihmM+0NRfH+1/REvfsjY7sJeIv
raq9mFpG7N5ro2XahN7J
=PtAL
-----END PGP SIGNATURE-----

--Sig_/6rdyMPwG+D8DnP8H1820CIX--
