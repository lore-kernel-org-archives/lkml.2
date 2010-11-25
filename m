Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432Ab0KYArz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 19:47:55 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53332 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064Ab0KYArx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 19:47:53 -0500
Date: Thu, 25 Nov 2010 11:47:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Paris <eparis@redhat.com>
Cc: James Morris <jmorris@namei.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Potentially pull new SELinux tree into linux-next
Message-Id: <20101125114743.0e027281.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LRH.2.00.1011251045240.20229@tundra.namei.org>
References: <1290530872.1443.18.camel@localhost.localdomain>
	<20101125103751.86f529fc.sfr@canb.auug.org.au>
	<alpine.LRH.2.00.1011251045240.20229@tundra.namei.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__25_Nov_2010_11_47_43_+1100_epVr7P/J9kIUu63R"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__25_Nov_2010_11_47_43_+1100_epVr7P/J9kIUu63R
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Thu, 25 Nov 2010 10:46:06 +1100 (EST) James Morris <jmorris@namei.org> w=
rote:
>
> On Thu, 25 Nov 2010, Stephen Rothwell wrote:
>=20
> > On Tue, 23 Nov 2010 11:47:52 -0500 Eric Paris <eparis@redhat.com> wrote:
> > >
> > > I was ask to start keeping an SELinux development tree.  I expect Jam=
es
> > > to pull it into his security tree pretty regularly.  I don't know if =
you
> > > want to start pulling my tree directly so things filter out faster or=
 if
> > > you want me to just wait for James to pull.
> >=20
> > I have a few trees like that (wireless, bluetooth for example).
> >=20
> > > I guess really the question comes down to "does linux-next want to de=
al
> > > with intra-subsystem conflicts or just inter-subsystem?"  If you don't
> > > mind intra-subsystem I'd like you to start pulling the master branch =
of
> > > git://git.infradead.org/users/eparis/selinux.git
> >=20
> > I can cope with that usually.   I would like James' opinion, though.
> >=20
> > If I merge this, it will be after the security-testing tree so that if
> > James does merge it, it costs me nothing.
>=20
> Should be fine, helps Eric get his stuff ready before pushing to me.


OK, so added from today.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Thu__25_Nov_2010_11_47_43_+1100_epVr7P/J9kIUu63R
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM7bIvAAoJEDMEi1NhKgbs3scH/0asTW7vMt/tXACDLsFsp+3F
Arj/9xFVB12TqAvnXgswxuI/NlbcsBScj7KsjxpKfM3zH/TeAcLxl7gkpsMhMw0f
ijhlmpLncEs0dkSxAo7B5w3qa3L5Y0Ssyfol7tPFJge1fQrMi6e8TZEV4/9jzWxh
nsNWYFtKTc4KhevRARDhu1mBJZ4gGJDIVfs74QYcpjlp3lkFK5DJSreXv05DX7PM
aITP7DlwFjR/U51f/DvfeVeg/4n/b/f7rBrZZeWyY5W6mlmWrC9rhpPDOUZb6lQX
imN9c7gJwE+vWEJFlhphTbO7fE8MlXSerEmWA37snv0LydG0m2Kbc9QkZanLJ5U=
=v4bm
-----END PGP SIGNATURE-----

--Signature=_Thu__25_Nov_2010_11_47_43_+1100_epVr7P/J9kIUu63R--
