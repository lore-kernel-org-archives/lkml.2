Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759569Ab1JGGCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 02:02:17 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:60866 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484Ab1JGGCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 02:02:14 -0400
Date: Fri, 7 Oct 2011 17:02:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>, linux-next@vger.kernel.org
Subject: Re: Including C6X in linux-next
Message-Id: <20111007170203.657b5e0e84218019f479a1cb@canb.auug.org.au>
In-Reply-To: <1317947131.2300.6.camel@deneb.redhat.com>
References: <1317917085.2703.16.camel@deneb.redhat.com>
	<20111007102953.7b533ec58dd613b9fd78a198@canb.auug.org.au>
	<1317947131.2300.6.camel@deneb.redhat.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__7_Oct_2011_17_02_03_+1100_nkNyv34caxW7N=O5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_Oct_2011_17_02_03_+1100_nkNyv34caxW7N=O5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Thu, 06 Oct 2011 20:25:30 -0400 Mark Salter <msalter@redhat.com> wrote:
>
> On Fri, 2011-10-07 at 10:29 +1100, Stephen Rothwell wrote:
> >=20
> > On Thu, 06 Oct 2011 12:04:44 -0400 Mark Salter <msalter@redhat.com> wro=
te:
> > >
> > > All of the patches in the latest C6X patch set have gotten Acked-bys,=
 so
> > > I guess its time to include it in the linux-next tree. The patches are
> > > available on the "for-linux-next" branch at:
> > >=20
> > >    http://linux-c6x.org/git/projects/linux-c6x-upstreaming.git
> >=20
> > I had a look at this and unfortunately you have based it on linux-next.
> > I cannot use it like that.  You need to rebase this onto Linus' tree,
> > sorry.  (Also, I used the git://... version of the URL as that is more
> > efficient than http://.. for updting git trees).
>=20
> Okay, it is now rebased on Linus' tree.

I have added this tree from today.

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

--Signature=_Fri__7_Oct_2011_17_02_03_+1100_nkNyv34caxW7N=O5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOjpXbAAoJEECxmPOUX5FEoxIP/1O0wybtXf3+YirpB21537eD
C8lZ5GmAN6dkjxphq2MnTC/nmTZ398H/zrLmlTK4orB2O7hd3+RF7/R0iQ4D7jeL
fUA4rHKGGxHbzXNzAxIY/DT/92q68wc9NMbjeecraArmZD+UtRq/3OHO6QPLVBEs
NwDVi9bler85gpQp3H0O6YCKviHRbQq17F3KkYr/bFqeuvvhsBlz1hCr+St6juTi
yvDWusW3ZNnft8vuDDH1KUpttohhCtM3dwa/qxnTc43TtEBmuw/hqBTvNHHqeGH9
EF8ZzzzlXIf0YWlKT5nP0Cx5cyH77HHt8nMyQGZ//7CO8sIImmYSOINJFp4Th6lV
3YV2BAJIdCKiPWOk5Av0EqUDFVIm6v0PAJctJ0e7yU0XHd5mzwTazqIy9kdMytHH
Qm+XPlP81YVeqhcBQ6GtC5FhkVDa9Z/lwbL1U49nopi8vU0rkFKN15X8HgjDr/hA
E8LrNGI1dcJw7I0lpYSo2j2ZRM10vSy3gKLOam5AvZqTWqKzz/MAY0UswUY2ggyz
issW8GfN648qLQSwme6y1kekv3KjBUy5etKMCWIPZOGBTMB+fH53rlbXzTPlUTJd
mF9QIED4UK18S/SXg3faU9QJiQLyh+go356LzHuK3pAn5OL2djStH5no3N9sQGwd
Xwf7oTLBhprujFMp96in
=gnd2
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Oct_2011_17_02_03_+1100_nkNyv34caxW7N=O5--
