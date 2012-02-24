Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab2BXDI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 22:08:29 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:52769 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513Ab2BXDI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 22:08:27 -0500
Date: Fri, 24 Feb 2012 14:08:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: linux-next: build warning after merge of the libata tree
Message-Id: <20120224140814.c134151d30e3f32b36360d5d@canb.auug.org.au>
In-Reply-To: <20120213162740.9e3cb47a39da19ed89edea49@canb.auug.org.au>
References: <20120213162740.9e3cb47a39da19ed89edea49@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__24_Feb_2012_14_08_14_+1100_bt8XMs01=eN1ZbXu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__24_Feb_2012_14_08_14_+1100_bt8XMs01=eN1ZbXu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jeff, Matthew,

On Mon, 13 Feb 2012 16:27:40 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the libata tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
>=20
> drivers/ata/libata.h:133:13: warning: 'ata_acpi_bind_dock' defined but no=
t used [-Wunused-function]
> drivers/ata/libata.h:134:13: warning: 'ata_acpi_unbind_dock' defined but =
not used [-Wunused-function]
> drivers/ata/libata.h:132:13: warning: 'ata_acpi_unregister' defined but n=
ot used [-Wunused-function]
> drivers/ata/libata.h:132:13: warning: 'ata_acpi_unregister' defined but n=
ot used [-Wunused-function]
> drivers/ata/libata.h:133:13: warning: 'ata_acpi_bind_dock' defined but no=
t used [-Wunused-function]
> drivers/ata/libata.h:134:13: warning: 'ata_acpi_unbind_dock' defined but =
not used [-Wunused-function]
> drivers/ata/libata.h:132:13: warning: 'ata_acpi_unregister' defined but n=
ot used [-Wunused-function]
> drivers/ata/libata.h:133:13: warning: 'ata_acpi_bind_dock' defined but no=
t used [-Wunused-function]
> drivers/ata/libata.h:134:13: warning: 'ata_acpi_unbind_dock' defined but =
not used [-Wunused-function]
> drivers/ata/libata.h:132:13: warning: 'ata_acpi_unregister' defined but n=
ot used [-Wunused-function]
> drivers/ata/libata.h:133:13: warning: 'ata_acpi_bind_dock' defined but no=
t used [-Wunused-function]
> drivers/ata/libata.h:134:13: warning: 'ata_acpi_unbind_dock' defined but =
not used [-Wunused-function]
>=20
> Introduced by commits 75d22cd567ca ("libata: Bind the Linux device tree
> to the ACPI device tree") and c9df614ade0e ("libata: Add links between
> removable devices and docks").

Ping?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__24_Feb_2012_14_08_14_+1100_bt8XMs01=eN1ZbXu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPRv8eAAoJEECxmPOUX5FEZBIP/0yHy0McQUfKyFX7cOW+q/VR
fYlObpJRrLyLPsXB3xiZ2O3TNdY6yOWn/CIt4cEEUyU2ljb5RscNfU7WApnwkTSJ
1vkXIgRBpRWe/ZEpWIxWw7VtU6zuzunqQx57OSTr+aTHAlpCwCMcxJr5BYdbUSdw
/Ru5Qg+LPZiGjpIMZvo8TARhwkSwIuHXiOlXosUbcXnEvxNJU3kmFOUr6pizEoDe
oijIgQlMgAmTzYhYzvM7zfG/nOULTLsikwEGa1UwbmR89BjbBclaaZj/shWFN10D
9njMiTDe3UJNszydt6oFGtFEQadNbqtp5Siv0lwy6Iad5+GqCOZPh0RhEUcindQ6
1qMl4NGsbwiitQ2VjRfZXiSbWEHlAjAJYub2uQZudil2ea/u0GLs7Aa8hyfzCx5J
f5anFgc3JfRwenk9kmzLWaEAX2ZNKH5ZdUEoP5xR20TTya97eHmsmrG1HtoipO+n
6hHhKB4ur79zRqR5ggmJh0C9MCpbCSNYMnuXoFtzQsqhQy+JZHHSqshSomRSptIa
KevpxQYpN05sUYpuTQlZpUpvqp4+eUmHHSHjFcRgLysHLiluplBv0cm/FLYcviSo
0qodP5axZgXHwMu7ghtGFXestr/AcI1lAOwuZedgVoNMTnhlJt4TPxjLo1FbI3Nl
sZutr7q0yJP/Lt1tAIMe
=KcNx
-----END PGP SIGNATURE-----

--Signature=_Fri__24_Feb_2012_14_08_14_+1100_bt8XMs01=eN1ZbXu--
