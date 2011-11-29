Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab1K2RbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 12:31:07 -0500
Received: from nitrogen.vapor.com ([213.203.212.226]:45706 "EHLO
	nitrogen.vapor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144Ab1K2RbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 12:31:03 -0500
Subject: Re: [REGRESSION] [Linux 3.2] top/htop and all other CPU usage
From: Ian Kumlien <pomac@vapor.com>
Reply-To: pomac@vapor.com
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl, tino.keitel@tikei.de,
        t.artem@lycos.com
In-Reply-To: <20111129075242.GB2675@tiehlicka.suse.cz>
References: <20111128222803.GA4925@pomac.netswarm.net>
	 <20111129075242.GB2675@tiehlicka.suse.cz>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-A7xipPIP4BSq9K663eOr"
Date: Tue, 29 Nov 2011 18:31:00 +0100
Message-ID: <1322587860.4061.6.camel@pi>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-A7xipPIP4BSq9K663eOr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On tis, 2011-11-29 at 08:52 +0100, Michal Hocko wrote:
> On Mon 28-11-11 23:28:03, pomac@vapor.com wrote:
> > Hi,=20
> >=20
> > All this time i have been thinking i'm the only one - and i've been to
> > loaded with work during working hours and tired when home =3DP
> >=20
> > Anyways, I've neen seeing this since -rc1 on:
> > Intel(R) Core(TM) i5 CPU U520  @ 1.07GHz - x86-64
> > AMD Phenom(tm) II X6 1090T - x86-64
> > AMD Athlon(tm) 64 X2 Dual Core Processor 4400+ - x86-64
> > Intel(R) Core(TM)2 CPU T7200  @ 2.00GHz - i686
> >=20
> > Configs available on demand - I've been running the same config for
> > quite some time though.
>=20
> As I have written in other email could you post your config and collect
> the following data?
> for i in `seq 30`;=20
> do=20
>         cat /proc/stat > `date +'%s'`
>         sleep 1
> done
> export old_user=3D0 old_nice=3D0 old_sys=3D0 old_idle=3D0 old_iowait=3D0;=
=20
>=20
> # for all your available CPUs
> grep cpu0 * | while read cpu user nice sys idle iowait rest;=20
> do=20
>         echo $cpu $(($user-$old_user)) $(($nice-$old_nice)) $(($sys-$old_=
sys)) $(($idle-$old_idle)) $(($iowait-$old_iowait))
>         old_user=3D$user old_nice=3D$nice old_sys=3D$sys old_idle=3D$idle=
 old_iowait=3D$iowait
> done

Sorry, the previous one was AMD X2 4400+ and now the T7200:

1322587696:cpu0 1410110 148 368843 357890604 357890604
1322587697:cpu0 0 0 1 0 0
1322587698:cpu0 1 0 1 0 0
1322587699:cpu0 2 0 1 0 0
1322587700:cpu0 0 0 1 0 0
1322587701:cpu0 0 0 1 0 0
1322587702:cpu0 0 0 1 0 0
1322587703:cpu0 1 0 0 0 0
1322587704:cpu0 0 0 0 0 0
1322587705:cpu0 0 0 1 0 0
1322587706:cpu0 1 0 1 0 0
1322587707:cpu0 0 0 1 0 0
1322587708:cpu0 1 0 0 0 0
1322587709:cpu0 1 0 0 0 0
1322587711:cpu0 0 0 2 0 0
1322587712:cpu0 0 0 0 0 0
1322587713:cpu0 1 0 1 0 0
1322587714:cpu0 1 0 0 0 0
1322587715:cpu0 1 0 1 0 0
1322587716:cpu0 1 0 0 0 0
1322587717:cpu0 0 0 1 0 0
1322587718:cpu0 1 0 1 0 0
1322587719:cpu0 0 0 1 0 0
1322587720:cpu0 0 0 0 0 0
1322587721:cpu0 2 0 1 0 0
1322587722:cpu0 1 0 0 0 0
1322587723:cpu0 0 0 3 0 0
1322587724:cpu0 1 0 0 0 0
1322587725:cpu0 0 0 0 0 0
1322587726:cpu0 0 0 1 0 0

1322587696:cpu1 1395249 509 284978 357890604 95640
1322587697:cpu1 0 0 0 0 0
1322587698:cpu1 0 0 0 0 0
1322587699:cpu1 0 0 0 0 0
1322587700:cpu1 1 0 0 0 0
1322587701:cpu1 1 0 0 0 0
1322587702:cpu1 0 0 0 0 0
1322587703:cpu1 0 0 1 0 0
1322587704:cpu1 1 0 0 0 0
1322587705:cpu1 0 0 1 0 0
1322587706:cpu1 1 0 0 0 0
1322587707:cpu1 0 0 0 0 0
1322587708:cpu1 1 0 0 0 0
1322587709:cpu1 1 0 1 0 0
1322587711:cpu1 0 0 0 0 0
1322587712:cpu1 0 0 0 0 0
1322587713:cpu1 0 0 0 0 0
1322587714:cpu1 0 0 0 0 0
1322587715:cpu1 0 0 0 0 0
1322587716:cpu1 0 0 1 0 0
1322587717:cpu1 0 0 0 0 0
1322587718:cpu1 0 0 0 0 0
1322587719:cpu1 0 0 1 0 0
1322587720:cpu1 1 0 0 0 0
1322587721:cpu1 2 0 0 0 0
1322587722:cpu1 0 0 0 0 0
1322587723:cpu1 0 0 1 0 0
1322587724:cpu1 0 0 0 0 0
1322587725:cpu1 1 0 0 0 0
1322587726:cpu1 0 0 0 0 0

Btw, perf doesn't seem to yield anything..

--=20
Ian Kumlien  -- http://demius.net || http://pomac.netswarm.net

--=-A7xipPIP4BSq9K663eOr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEABECAAYFAk7VFtQACgkQ7F3Euyc51N+0MwCgpkE6OOcBt0imTQckpoSndGAJ
8eUAn0RA167pv8uLppBf4JB1FumlmGZ5
=hKKF
-----END PGP SIGNATURE-----

--=-A7xipPIP4BSq9K663eOr--

