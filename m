Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab1K2R3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 12:29:13 -0500
Received: from nitrogen.vapor.com ([213.203.212.226]:45633 "EHLO
	nitrogen.vapor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab1K2R3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 12:29:11 -0500
X-Greylist: delayed 362 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Nov 2011 12:29:11 EST
Subject: Re: [REGRESSION] [Linux 3.2] top/htop and all other CPU usage
From: Ian Kumlien <pomac@vapor.com>
Reply-To: pomac@vapor.com
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl, tino.keitel@tikei.de,
        t.artem@lycos.com
In-Reply-To: <20111129075242.GB2675@tiehlicka.suse.cz>
References: <20111128222803.GA4925@pomac.netswarm.net>
	 <20111129075242.GB2675@tiehlicka.suse.cz>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-uSBxv3YuPq+5jt+K5XsO"
Date: Tue, 29 Nov 2011 18:23:05 +0100
Message-ID: <1322587386.4061.4.camel@pi>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-uSBxv3YuPq+5jt+K5XsO
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

1322587011:cpu0 5838553 164 1252921 1844674407370 78234
1322587012:cpu0 4 0 1 0 0
1322587013:cpu0 4 0 2 0 0
1322587014:cpu0 2 0 1 0 0
1322587015:cpu0 3 0 2 0 0
1322587016:cpu0 7 0 2 0 4
1322587017:cpu0 2 0 2 0 0
1322587018:cpu0 1 0 1 0 0
1322587019:cpu0 4 0 2 0 1
1322587020:cpu0 5 0 3 0 5
1322587021:cpu0 7 0 1 0 3
1322587022:cpu0 4 0 2 0 0
1322587023:cpu0 4 0 2 0 0
1322587024:cpu0 3 0 3 0 0
1322587025:cpu0 3 0 1 0 0
1322587026:cpu0 4 0 2 0 4
1322587027:cpu0 2 0 2 0 0
1322587028:cpu0 2 0 1 0 0
1322587029:cpu0 4 0 1 0 0
1322587030:cpu0 5 0 1 0 0
1322587032:cpu0 5 0 1 0 4
1322587033:cpu0 6 0 1 0 0
1322587034:cpu0 1 0 2 0 0
1322587035:cpu0 3 0 2 0 0
1322587036:cpu0 3 0 1 0 0
1322587037:cpu0 4 0 2 0 2
1322587038:cpu0 4 0 1 0 0
1322587039:cpu0 2 0 1 0 0
1322587040:cpu0 3 0 1 0 0
1322587041:cpu0 4 0 3 0 0

1322587011:cpu1 5944677 172 1287816 1844674407370 871
1322587012:cpu1 4 0 2 0 0
1322587013:cpu1 2 0 2 0 0
1322587014:cpu1 3 0 0 0 0
1322587015:cpu1 3 0 1 0 9
1322587016:cpu1 22 0 3 0 18
1322587017:cpu1 10 0 3 0 13
1322587018:cpu1 3 0 1 0 0
1322587019:cpu1 4 0 3 0 14
1322587020:cpu1 14 0 2 0 7
1322587021:cpu1 16 0 1 0 2
1322587022:cpu1 5 0 0 0 0
1322587023:cpu1 7 0 1 0 0
1322587024:cpu1 8 0 1 0 0
1322587025:cpu1 2 0 2 0 0
1322587026:cpu1 4 0 2 0 5
1322587027:cpu1 7 0 2 0 0
1322587028:cpu1 5 0 0 0 0
1322587029:cpu1 4 0 2 0 0
1322587030:cpu1 6 0 0 0 0
1322587032:cpu1 3 0 2 0 0
1322587033:cpu1 6 0 1 0 0
1322587034:cpu1 2 0 1 0 0
1322587035:cpu1 4 0 2 0 0
1322587036:cpu1 3 0 1 0 0
1322587037:cpu1 4 0 0 0 0
1322587038:cpu1 8 0 1 0 0
1322587039:cpu1 4 0 2 0 0
1322587040:cpu1 4 0 0 0 0
1322587041:cpu1 8 0 1 0 0

For me the cpu usage is sporadic and only shows up as user or kernel,
nothing else.

--=20
Ian Kumlien  -- http://demius.net || http://pomac.netswarm.net

--=-uSBxv3YuPq+5jt+K5XsO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEABECAAYFAk7VFPkACgkQ7F3Euyc51N901ACfeSNt3uoiyqzFJIoll3NO/Nf1
KioAoJhyoFynCtYBnlSsaObIVopmkspr
=TeKW
-----END PGP SIGNATURE-----

--=-uSBxv3YuPq+5jt+K5XsO--

