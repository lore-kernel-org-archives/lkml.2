Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab0KIOoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 09:44:00 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:39488 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147Ab0KIOn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 09:43:59 -0500
Date: Wed, 10 Nov 2010 01:43:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ed Cashin <ecashin@coraid.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "sage@newdream.net" <sage@newdream.net>,
        "yehuda@hq.newdream.net" <yehuda@hq.newdream.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tracey Dent <tdent48227@gmail.com>
Subject: Re: [Resend][PATCH 2/2] Drivers: block: aoe: Makefile: replace the
 use of <module>-objs with <module>-y
Message-Id: <20101110014350.ad3a7ca7.sfr@canb.auug.org.au>
In-Reply-To: <767A0825-0AC8-4B95-BE03-41027F9BC1E6@coraid.com>
References: <1289069918-2085-1-git-send-email-tdent48227@gmail.com>
	<1289069918-2085-2-git-send-email-tdent48227@gmail.com>
	<EDA33B3B-F9C9-4C45-B20D-C985DFC95C2F@coraid.com>
	<20101108130543.1188a63f.akpm@linux-foundation.org>
	<20101109121113.956cc6e5.sfr@canb.auug.org.au>
	<767A0825-0AC8-4B95-BE03-41027F9BC1E6@coraid.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__10_Nov_2010_01_43_50_+1100_2ghqbFKTgeD5RR8k"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Nov_2010_01_43_50_+1100_2ghqbFKTgeD5RR8k
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ed,

On Tue, 9 Nov 2010 08:54:55 -0500 Ed Cashin <ecashin@coraid.com> wrote:
>
> On Nov 8, 2010, at 8:11 PM, Stephen Rothwell wrote:
> ...
> > I have a quilt series in linux-next called aoe that has not been updated
> > since Nov, 2009.  Can I assume that it is defunct and remove it?  Or wi=
ll
> > you be using it again?
>=20
> You can remove it, thanks.  When I created it, I had the
> misunderstanding that I was supposed to push through
> linux-next into Linus's tree.  But patches still just go through
> Andrew or Jens.
>=20
> The aoe changes usually aren't invasive enough to benefit
> from being available in linux-next, I think.

OK, thanks, will do.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__10_Nov_2010_01_43_50_+1100_2ghqbFKTgeD5RR8k
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM2V4mAAoJEDMEi1NhKgbsWJMH/RBLUUjywhW2w1o+ejLqhoNW
ntS23oUfVZlvDWbGaWw0kX8nwkPwf6J8LXGfHfzHSmQEgb17cSBuJZDwcAN1CwOa
KH4g9spv0zoxMBIs5tpDhbkqjPiJEebVRvNykO4M7n0n4ss8Dic+TLnbl/IhDZLV
vLvMfO979clFOxWoW6bg76PCEoxDd9sdJCJ4p6sENmrchyAGLir2XxUeteBsH4pD
/HtANbYEKcAplxO/HA8LK+W7kCDODbJUe8C4R8lErVRsOGdC8VaDWbD5s4CfA6nm
wK9Vyvt7l6csY3H9sPQEkmeAOh8xLBkQyVafGuj+dY+e1/tVmDBC9rgq32e3K94=
=rLQQ
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Nov_2010_01_43_50_+1100_2ghqbFKTgeD5RR8k--
