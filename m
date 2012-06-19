Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab2FSFhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 01:37:16 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47891 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab2FSFhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 01:37:14 -0400
Date: Tue, 19 Jun 2012 15:37:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Len Brown <lenb@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Durgadoss R <durgadoss.r@intel.com>,
        Jenny TC <jenny.tc@intel.com>
Subject: Re: linux-next: build failure after merge of the final tree (acpi
 and battery trees related)
Message-Id: <20120619153705.bc20359d73d6139e2cb4c1f5@canb.auug.org.au>
In-Reply-To: <20120619051032.GB16286@lizard>
References: <20120619145425.6f825e142856ca808927ca45@canb.auug.org.au>
	<20120619051032.GB16286@lizard>
X-Mailer: Sylpheed 3.2.0beta8 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__19_Jun_2012_15_37_05_+1000_7yJdGbEmaxUygH1H"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__19_Jun_2012_15_37_05_+1000_7yJdGbEmaxUygH1H
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Anton,

On Mon, 18 Jun 2012 22:10:32 -0700 Anton Vorontsov <cbouatmailru@gmail.com>=
 wrote:
>
> Thanks for noticing, Stephen! Although, I wonder what would be the
> best way to fix this?.. I would happily cherry-pick the ACPI change
> into my tree and then re-apply the battery thermal zone support patch,
> but ACPI change doesn't apply cleanly on the battery tree. Heh.
>=20
> Is there thermal zone git tree? Or maybe I would just let ACPI
> folks take the battery patch in question?

Just wait until the next merge window and then who ever get's Linus to
merge their tree last can tell him to fix this in the merge commit.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__19_Jun_2012_15_37_05_+1000_7yJdGbEmaxUygH1H
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP4BABAAoJEECxmPOUX5FElLYP/iRYhOl25aA3QcQ9DmM95f71
FYbMZ7ninBFXg0TuHb5H6N8YTSg7PrgFRxGzlNisQGyxp1pUVAew/040+ebN1YVh
GcQbYQLcmU/NiN0qrte/x58W90GuwQ/yv7tyvkXpBTGTbsTmIAxTjtKk37kCRRCX
ib0aXHhWt+iTWcIA0njMh5f/cMcRh5pLeNtVJPehwR0SLHb/iuUXy/YimY4LVx0c
PLwD2Y04hyzT3JzXLp/KZNywU8wEfY+YBr2Vk3hH/sJBL/TkQfchsArKiGD/5lyl
q7+1btcNLesp24J/PIZIabnNnxJTw7T3Rn2oCrD0kZ3k7dq1ZSesQ+Y5XwXcfdQT
Uqt59U2lwi/Zq6IKxF6d3JZPyExStiThXHrSGzTX+nm3xIvj3qV3DAHWlDFHR31a
3Vl3idepQfiSnWJulDKbKunPfVxRUCsgM0J/3f/p9LUlAlaA5i3iWPQuDudwynIz
3l70q9uyWHrrgA5caV6zc1TpJuO+Nmwa2CRWGrpiqoWHsGyu/5uMYlXr6sULwjnp
Szsgq9pdVB+m9mx7b8iRgjMURMQYzmr1UOVBGgLKgOVFGv3D0NCpwy8LIYDGhwrk
OKeOe/xKxT217XBRRdnYgd/x8d1Tm6xF9rsIfNzdXS//hWIRd4v8hLcBe5t++NWJ
b5171y/SZR/cOVSzRO2r
=O1/a
-----END PGP SIGNATURE-----

--Signature=_Tue__19_Jun_2012_15_37_05_+1000_7yJdGbEmaxUygH1H--
