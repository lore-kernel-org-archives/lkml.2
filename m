Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab1AOPoo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 10:44:44 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:57938 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192Ab1AOPon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 10:44:43 -0500
Date: Sun, 16 Jan 2011 02:44:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ozan Caglayan <ozan@pardus.org.tr>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the final tree (linus'
 tree related)
Message-Id: <20110116024434.3a5ccabb.sfr@canb.auug.org.au>
In-Reply-To: <201101151419.16758.rjw@sisk.pl>
References: <20110115133412.58b8cd89.sfr@canb.auug.org.au>
	<201101151419.16758.rjw@sisk.pl>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__16_Jan_2011_02_44_34_+1100_+rn4Bzohlg.aYF3W"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__16_Jan_2011_02_44_34_+1100_+rn4Bzohlg.aYF3W
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Raphael,

On Sat, 15 Jan 2011 14:19:16 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>
> It looks like the non-CONFIG_ACPI version of acpi_find_root_bridge_handle=
()
> is just not necessary any more, because acpi_find_root_bridge_handle() is=
 only
> used in code that depends on CONFIG_ACPI.
>=20
> A patch removing it is appended, please test.

That fixes the compile error for my powerpc allyesconfig build.
And my x86_64 allmodconfig and i386 defconfig builds still work.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__16_Jan_2011_02_44_34_+1100_+rn4Bzohlg.aYF3W
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNMcDiAAoJEDMEi1NhKgbscU8IAIoaRW3UaF79vKeVgQBQLqCE
KZPAhuEFBgl9EZ3blSxCoMvcjcQ3cQQl+gknYQ1rcDGUQUtnspH8iGQTJlkJ9w7f
+pUK+l4tROIqeUq/icxCp+zIt4O0sYHbMw3BqLrm8h8AmkKDsAZJX6K1rS1tDlsf
OUnA4H2vBtYdh4OYAxXfYfk+G8g3D9U9H7bzlY4WzVErLRBXJXW2iFc6I79LHhMw
8l2B6q7VE5kX9+Lw87eDX1Z58VrD3zR0j3YOL6eDNI08KVhCyAqF41tpQExd+xlt
rzR5gLI0XP7aX8zVFON9Y+Ng09KoV0BaUD+VOx+r5dYFM1Umlzy4Ig4VGCV0Eec=
=xvq6
-----END PGP SIGNATURE-----

--Signature=_Sun__16_Jan_2011_02_44_34_+1100_+rn4Bzohlg.aYF3W--
