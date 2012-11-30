Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab2K3CT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 21:19:59 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38646 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753523Ab2K3CT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 21:19:58 -0500
Message-ID: <1354241989.7995.26.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 036/270] kbuild: Do not package /boot and /lib in make
 tar-pkg
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Michal Marek <mmarek@suse.cz>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Date: Fri, 30 Nov 2012 02:19:49 +0000
In-Reply-To: <20121130013843.GB13478@kroah.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
	 <1353949160-26803-37-git-send-email-herton.krzesinski@canonical.com>
	 <1353983187.4266.40.camel@deadeye.wl.decadent.org.uk>
	 <20121130013843.GB13478@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-SSI08cG9VZvyZcn1H/tG"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-SSI08cG9VZvyZcn1H/tG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-11-29 at 17:38 -0800, Greg Kroah-Hartman wrote:
> On Tue, Nov 27, 2012 at 02:26:27AM +0000, Ben Hutchings wrote:
> > On Mon, 2012-11-26 at 14:55 -0200, Herton Ronaldo Krzesinski wrote:
> > > 3.5.7u1 -stable review patch.  If anyone has any objections, please l=
et me know.
> > >=20
> > > ------------------
> > >=20
> > > From: Michal Marek <mmarek@suse.cz>
> > >=20
> > > commit fe04ddf7c2910362f3817c8156e41cbd6c0ee35d upstream.
> > >=20
> > > There were reports of users destroying their Fedora installs by a ker=
nel
> > > tarball that replaces the /lib -> /usr/lib symlink. Let's remove the
> > > toplevel directories from the tarball to prevent this from happening.
> > >=20
> > > Reported-by: Andi Kleen <andi@firstfloor.org>
> > > Suggested-by: Ben Hutchings <ben@decadent.org.uk>
> > > Signed-off-by: Michal Marek <mmarek@suse.cz>
> > > [ herton: dropped unrelated changes to arch/x86/Makefile and
> > >   scripts/Makefile.fwinst, which don't apply anyway on 3.5, see commi=
t
> > >   3ce9e53e788881da0d5f3912f80e0dd6b501f304 upstream ]
> > > Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical=
.com>
> >=20
> > This is missing from 3.4.
>=20
> I don't think it is needed, as 3ce9e53e788881da0d5f3912f80e0dd6b501f304
> didn't go into 3.4, so all should be good for now.

No, 3ce9e53e788881da0d5f3912f80e0dd6b501f304 was later and reverted
unintended changes in fe04ddf7c2910362f3817c8156e41cbd6c0ee35d.  You
should probably combine the two.

See these stable commits:

3.2: 0767530 kbuild: Do not package /boot and /lib in make tar-pkg
3.6: 4bb50fa kbuild: Do not package /boot and /lib in make tar-pkg
3.6: 0a7f602 kbuild: Fix accidental revert in commit fe04ddf

Ben.

--=20
Ben Hutchings
Never attribute to conspiracy what can adequately be explained by stupidity=
.

--=-SSI08cG9VZvyZcn1H/tG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAULgXxee/yOyVhhEJAQqwrhAAkTlVXTfsfHti1Vdk+FoVpsMQs9nQIL0g
6UAANhtQjfPbPFRHfgxkrU+DIWmm8mM4ml/6Xq4vjOvnzoSJN2utjeWDk/JL50g9
Y/hJYeZwORc455iAQqg6KdQh1vYgWAnBp/yaAltMj4q2Emj0yuwyWMPCfdAfMqei
2kxf1zWugkDI3n2PlTT+VroWbILy+c0hZsu38U/Q710thk5iiR1yuwmqHTrZQ84X
i58MBdJawG7XYLHoYD1LhWhSgDSVTNVUKipQvu20GUvz0ykq6SE7nDjW9zbH0Ezo
rb29EeYtB9fC7pf0x1No0+oC1TqXvsfK9tU5mKGJvFJIZeUinVJn7OvKCj5U3SAE
1cfbBcj3xTHpAJgiELqD4Wc2jQt7sLFOraACxzhk3WAH8H4286qgmwY15rqJDN65
7cWHgyOvvS/JVz0HzztHSUoJwWmZlcFz4ZD4DLxmhIJasfmyfVbLJcHn7CRhvyzx
3HyK/LXi6eMniMvoROlwO+Fx8+LM4dawDbxJHB6yO7O3PyN+tzHT/ByyAOpASqMX
sJzRwtVB/e0yXyT5x6d2sSF/VHoiMG1gNOV/dCG2IYw1F8+cs+CNJLORg8XhNlUN
/1zE+h3XnM/IEJkFfDTKmFYMF7etUyVifup3K7cm3MOtZKBvlTmzzrFGAsZo1T/5
wZEKQb8Ir8k=
=GKr3
-----END PGP SIGNATURE-----

--=-SSI08cG9VZvyZcn1H/tG--
