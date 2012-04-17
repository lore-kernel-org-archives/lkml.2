Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab2DQDYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 23:24:12 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52806 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab2DQDYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 23:24:10 -0400
Date: Tue, 17 Apr 2012 13:23:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>
Subject: Re: linux-next: build failure after merge of the final tree
 (devicetree tree related)
Message-Id: <20120417132357.b38685ea31582e638623961c@canb.auug.org.au>
In-Reply-To: <CACxGe6tDa+AzK0O=E+EPZ90Ek_C-rM-G4fHSnsdL0S+fNcmzmw@mail.gmail.com>
References: <20120411151155.b1a614f174442a592d1c1561@canb.auug.org.au>
	<20120412103157.70669ff82b81d5d926c36d4d@canb.auug.org.au>
	<CACxGe6tDa+AzK0O=E+EPZ90Ek_C-rM-G4fHSnsdL0S+fNcmzmw@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__17_Apr_2012_13_23_57_+1000_M.zjKQy2Yq6oCASo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_Apr_2012_13_23_57_+1000_M.zjKQy2Yq6oCASo
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

On Wed, 11 Apr 2012 18:35:34 -0600 Grant Likely <grant.likely@secretlab.ca>=
 wrote:
>
> On Wed, Apr 11, 2012 at 6:31 PM, Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
> > Hi Grant,
> >
> > On Wed, 11 Apr 2012 15:11:55 +1000 Stephen Rothwell <sfr@canb.auug.org.=
au> wrote:
> >>
> >> After merging the final tree, today's linux-next build (sparc64 defcon=
fig)
> >> failed like this:
> >>
> >> drivers/of/of_mdio.c: In function 'of_mdiobus_register':
> >> drivers/of/of_mdio.c:75:4: error: implicit declaration of function 'ir=
q_of_parse_and_map' [-Werror=3Dimplicit-function-declaration]
> >>
> >> Caused by commit e46c11b94787 ("of/irq: add empty irq_of_parse_and_map=
()
> >> for non-dt builds"). =C2=A0SPARC has CONFIG_OF but not CONFIG_OF_IRQ .=
..
> >>
> >> I have reverted that commit for today.
> >
> > That commit is actually in the devicetree-current tree.
>=20
> Yes, drop that tree or revert that commit.  There's nothing else in
> there and I didn't have time to pull it back today before you started
> linux-next for the day.  The change is bogus and I'll spin a proper
> fixup for tomorrow.

Ping?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__17_Apr_2012_13_23_57_+1000_M.zjKQy2Yq6oCASo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPjOJNAAoJEECxmPOUX5FEz6oP/RT3j3VTeUJqMPwt3/0tdusn
NbgL+9y6h6BFLAfh53ewNKq6Pmpr8+VjM6o1v0L39xEma+6YUmldELi2i+m995BX
w2Zfil3TymHVjnGnP1NxctYu/ZzqCDWxFz2NWuQcuG6lZSWrMsu6g1tvreA9tbDA
beOoTHR1C7crL1eAZKOhaqV6B+mirpbWr5UXphwlWqwrZrlYG6EFegnzASY60lG7
MOTjjcdtLKnGVrD6eVMfyT/Y1B6vPX5kIDgupJL3/wRV3h5wPhkbWqPJxVRvGiLX
FSZmGh5uKFV9mrBIr2Jc6BkFw+NETjKiICXVxP+ujD2fukCJXRKIdVbButAyn317
UdhNUPVeJ0d8KzROtwdNys/TQGA2kI2wm3eu/JBn0qTuwnLCBW06VO+UkbaZHM7r
Yem2bFItvhlZZbcX+bFcH967FX/2tIkZzC0Nh4/sd9XBnLCxvUGa87VypRhBNxU9
ThvU8KyZT2rLm1EE++Kg+FMuDfCbeXPECOqvw0U80WyyZb8keUGMsJPWC2avnmus
SlMOOHe4B+KaWHS1CEne9qRRDvXVnjv6+id1wumBOckyobeFgxZBo9IeUokQaMnw
L//rgVwv528uOfN2ysy5yB177+AbMNT2xj/6GhiA4nMnrQ1egLDceIa1IMj6ZJF3
Eklx+JTxmM/fWO3TQlQ1
=hwoi
-----END PGP SIGNATURE-----

--Signature=_Tue__17_Apr_2012_13_23_57_+1000_M.zjKQy2Yq6oCASo--
