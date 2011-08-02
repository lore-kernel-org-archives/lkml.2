Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab1HBB3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 21:29:19 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58158 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527Ab1HBB3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 21:29:15 -0400
Date: Tue, 2 Aug 2011 11:29:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: sedat.dilek@gmail.com, Sedat Dilek <sedat.dilek@googlemail.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for Aug 1
Message-Id: <20110802112907.5ca1abdd81758bd3b0bb6321@canb.auug.org.au>
In-Reply-To: <20110801145422.cccff7aa.rdunlap@xenotime.net>
References: <20110801144732.7f5204b219f628f2a2a63b0c@canb.auug.org.au>
	<CA+icZUXq9V6h6kJrjckpeDXQAbQ-skiKLwTjD7Luhz1mTqSM1w@mail.gmail.com>
	<20110801145422.cccff7aa.rdunlap@xenotime.net>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__2_Aug_2011_11_29_07_+1000_Eyq3xg_OauWMmYH+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Aug_2011_11_29_07_+1000_Eyq3xg_OauWMmYH+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 1 Aug 2011 14:54:22 -0700 Randy Dunlap <rdunlap@xenotime.net> wrote:
>
> On Mon, 1 Aug 2011 09:01:21 +0200 Sedat Dilek wrote:
>=20
> > Just FYI: mmotm-tree still misses the fixup-patch from [1].
> >=20
> > [1] https://patchwork.kernel.org/patch/1021602/
>=20
> Yes, I am applying this patch daily (among others).  :(
>=20
> Acked-by: Randy Dunlap <rdunlap@xenotime.net>

OK, I will apply this patch to linux-next as a merge fixup on top of
Andrew's tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__2_Aug_2011_11_29_07_+1000_Eyq3xg_OauWMmYH+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJON1LjAAoJEDMEi1NhKgbsrhYIAJGrl6DOkP9h4bis0IYh9DBc
UZ3A1C/KwKoBoTZEYvuZWn3rn3fbAmmrY/TwkqapDmPgD2Po8DLdeynOQWdYJF7k
wICpMPhUQj8cJATfSi4arGJHifbarqYg1Q959UmDrqf5UxoqrQI45rp2iRAws3zE
zEZqJcWN7kAeYR3Y0jT6IT+jRHQi+951DB6SbTprPuaulOMPuyksuhBqb0WV7tmt
49EWeg3wI2Vzc2jeq3QtBDO+SXNqSGziGcEr4yA8oesdHqe32h4Uk3hadGYLpKE9
WB4p4GKfHvVm39Iz9TYBe0bwrF63XmEH4sDkvlbaNJRCEDnHjwEom34p1SRVeCY=
=VsYQ
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Aug_2011_11_29_07_+1000_Eyq3xg_OauWMmYH+--
