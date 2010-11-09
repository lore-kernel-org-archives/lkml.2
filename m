Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab0KIPT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 10:19:58 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:45178 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab0KIPTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 10:19:55 -0500
Date: Wed, 10 Nov 2010 02:19:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-fbdev@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        James Simmons <jsimmons@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@nokia.com>
Subject: Re: [ANNOUNCE] fbdev git tree.
Message-Id: <20101110021945.b5ce52ca.sfr@canb.auug.org.au>
In-Reply-To: <20101109093204.GB21086@linux-sh.org>
References: <20101109093204.GB21086@linux-sh.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__10_Nov_2010_02_19_45_+1100_gT7N1wXQSd4O3g9F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Nov_2010_02_19_45_+1100_gT7N1wXQSd4O3g9F
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Tue, 9 Nov 2010 18:32:04 +0900 Paul Mundt <lethal@linux-sh.org> wrote:
>=20
> The tree can be found at:
>=20
> 	git://git.kernel.org/pub/scm/linux/kernel/git/lethal/fbdev-2.6.git
>=20
> Stephen, if you could add this with the master branch to -next, it would
> be appreciated. For the moment I expect most of the patches to follow a
> fairly linear line of development, but there may be cause for topic
> branches as new (or contested) patch sets arise.

Added from next-20101110.  I also have a viafb and omap_dss2 trees in
linux-next that are owned by Florian Tobias Schandinat and Tomi Valkeinen
respectively (cc'd).  There is no reason that these trees cannot remain in
linux-next even if you merge them as well.

Currently you are the only listed contact for the fbdev tree.

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

--Signature=_Wed__10_Nov_2010_02_19_45_+1100_gT7N1wXQSd4O3g9F
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM2WaRAAoJEDMEi1NhKgbsX6AH/3J5AYZ5B/stzIojssEZEMKp
ffaVxRrsyeAO9eBUN8Dtup+I3SSWSK6oK7tuijkac8FAEwZLvfKNdDfC/Nhax1T+
DYDiUPYe/QoWw793qY+cZJH1nEUcL1SGqT7XRsRNdYVxNIT16dGbIxmAT4Sh0rKB
LD2Pys7h40xCimKM7m28+zCetI7LxKpls0K20Oh95DLNCqcTwsLpx5voNKb5aBcI
mex2TDAIDZXZ0qVKux+wOKKyJnLszISjXpLjVU9uy5W4yE+PAGFwcuF1SFZzL4UX
nRjjZ2uNJoJwUMyCWYYCohMNd1CBHaLXnExVNVdH8hsJxdg4XQDO9qzDqfZszO4=
=NDWn
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Nov_2010_02_19_45_+1100_gT7N1wXQSd4O3g9F--
