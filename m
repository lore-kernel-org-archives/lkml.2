Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab2EMOD3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 10:03:29 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44900 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab2EMOD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 10:03:27 -0400
Date: Mon, 14 May 2012 00:03:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, cpufreq@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Add myself as the cpufreq maintainer
Message-Id: <20120514000312.3da77a8b29be4c33be3509e6@canb.auug.org.au>
In-Reply-To: <201205131512.36250.rjw@sisk.pl>
References: <20120504160417.GA421@redhat.com>
	<201205112135.46097.rjw@sisk.pl>
	<20120513101931.39617e4909fcc10d6739bc75@canb.auug.org.au>
	<201205131512.36250.rjw@sisk.pl>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__14_May_2012_00_03_12_+1000_iBZQBly5FYiZRf+w"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_May_2012_00_03_12_+1000_iBZQBly5FYiZRf+w
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

On Sun, 13 May 2012 15:12:36 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>
> On Sunday, May 13, 2012, Stephen Rothwell wrote:
> >=20
> > On Fri, 11 May 2012 21:35:45 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wr=
ote:
> > >
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > >=20
> > > Since cpufreq has no official maintainer at the moment, I'm willing
> > > to maintain it along some other power management core code I've been
> > > maintaining already.
> >=20
> > I have cpufreq-current and cpufreq trees in linux-next (both currently
> > empty and with Dave as contact).  What should I do with them?
> >=20
> > cpufreq-current	git://git.kernel.org/pub/scm/linux/kernel/git/davej/cpu=
freq.git#fixes
> > cpufreq		git://git.kernel.org/pub/scm/linux/kernel/git/davej/cpufreq.gi=
t#next
>=20
> I will push future cpufreq updates through the linux-pm tree.

OK, I will remove the two trees above from linux-next.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__14_May_2012_00_03_12_+1000_iBZQBly5FYiZRf+w
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPr78gAAoJEECxmPOUX5FEHdYP/RbNC9HWFVZM2y+kOJt43kAO
yZPoOYUPusYoz3lX3Myei0LcsRTLW7WGVl/fofZzfxiA7vZvMzIj+immPkF+hb+f
y28BZZ72/r2/ZJuUNEbuU8xuF5ARVOBGUZFRdwELhk5PtI5/iktdXe9GIYBu9GGC
IXQXvbJwftgYPULltNt+sMNQX0H3SXf+aF2iT+p8RHsBOaZDk0fydMslkrmy4+Qw
TtJsmdrG/UJ/3wF61B5rniFYRzJw1rSIbRthfIIW0oq3ZTF0hiePK9B17Xoeo9V0
q5/IPp1bAYi/MFdZcwxLEPe2MLd0DmpF7TsA4Ks0JSXu73JPl7LcwObX4e6MuosU
wKqV8B8JtSnNPdubQf0P1mjsg5QabJyPVB59dViefmwMnGLqjJBMIZQFzDk0Dvg0
55qkB3o13AdWhRIv/9DGRPk/YHSbyOqQ5sdmXerDBvP0vpwndITEABY500PxLice
Wbkd3wH/nxCHRNVD/DpgAkZkIXP4B3RD8GLk3R03Ka8JylQakUotyV7ZW0PJIMtY
tNs0/g0pr4k5KISglHh8ZHf57a9qlyl9yZNrWVKc/oTevJeVinGOEK12EtspfLhO
cWevX+cHeXxOnsQjo2dsXE0yWTwV4KOiusCzx+VmUrzPA58QpiHueacJp81l2PNs
ZlMs6rIurWvy35+vTjU/
=CwVU
-----END PGP SIGNATURE-----

--Signature=_Mon__14_May_2012_00_03_12_+1000_iBZQBly5FYiZRf+w--
