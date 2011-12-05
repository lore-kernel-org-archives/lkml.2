Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab1LET5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 14:57:24 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:42072 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932355Ab1LET5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 14:57:22 -0500
Date: Mon, 5 Dec 2011 11:59:56 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Vincent Palatin <vpalatin@chromium.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Olof Johansson <olofj@chromium.org>,
        Sameer Nanda <snanda@chromium.org>, Ming Lei <tom.leiming@gmail.com>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] PM / Runtime: make PCI traces quieter
Message-ID: <20111205115956.4d6920c1@jbarnes-desktop>
In-Reply-To: <1323114678-28750-1-git-send-email-vpalatin@chromium.org>
References: <20111205111906.7cae2946@jbarnes-desktop>
	<1323114678-28750-1-git-send-email-vpalatin@chromium.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2K/cIJSy0XHTb8XDIh+fBIz"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/2K/cIJSy0XHTb8XDIh+fBIz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon,  5 Dec 2011 11:51:18 -0800
Vincent Palatin <vpalatin@chromium.org> wrote:

> When the runtime PM is activated on PCI, if a device switches state frequ=
ently
> (e.g. an EHCI controller with autosuspending USB devices connected)
> the PCI configuration traces might be very verbose in the kernel log.
> Let's guard those traces with DEBUG condition.
>=20
> Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
> ---

Applied to linux-next, thanks.  The latency timer message is gone now
though, so it didn't need to be fixed. :)

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/2K/cIJSy0XHTb8XDIh+fBIz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJO3SK8AAoJEIEoDkX4Qk9hqXQP/1hFmk77cVsQoKl0+ZQEb+c5
/2VGuYFHRu2bC4NUncU/RBLQyokSQs6ECxfxjfiX1PKF1BHqJ5jnKZUYwjG1B8OO
l7Ms+4DYyyVAFIkgsDFNFHoAsiUPU6K38m45LLboL1Xmifj51J8MbcWVh2MT2zff
RoDxVTVUlR5piLqG9KmfGNse1rSJHsDrLHCMw44H9anepDCpQxbLx9Rk3QFF9Zio
pi3Jsqn6ajC6YUS6m4GQLGSsC0ToN7koEViRa67HS6oMpa7jRWOVFv52si1Q/Tt/
lnuszj+CBCLRm+jjEvddIDjoyjxGDhAPOyCdJdWysGWnrAsJ2yKpqZmZp7smvUi1
3AObvNzyrnyT5fj5WlKY0hsQDA9Hh7ObBdWFmpQ1iT4Sm5DL0ZBAsWvc44PBVC2b
+J6XjFnH4RuXVBDXKVnvO6iXvKCZESU0vb334TINhaEjWwxCVXEznO1bD+j0FiA4
dMVVZhQyomYK1dvIDxYbnsr1nDtbwyZbphxgLwvH5EPjcmKlTTIFkEL3C1h0RvJd
KOIfFSYvcUih2I/AHOMXKn0/uiFPfdigVvCauPF5ZdPKIpNQcPz5H8bLJsp4drje
27fS5QmWDf81cW1TyUpQKREnqYDZOSybAyCSMr7Zz+9c7+DJuRTvwKrx9VuDdcc/
ptrzhx2iEeQ23FifVfAk
=Gu2M
-----END PGP SIGNATURE-----

--Sig_/2K/cIJSy0XHTb8XDIh+fBIz--
