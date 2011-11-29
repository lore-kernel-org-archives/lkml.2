Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab1K2Sh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 13:37:26 -0500
Received: from nitrogen.vapor.com ([213.203.212.226]:48073 "EHLO
	nitrogen.vapor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086Ab1K2ShZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 13:37:25 -0500
Subject: Re: [REGRESSION] [Linux 3.2] top/htop and all other CPU usage
From: Ian Kumlien <pomac@vapor.com>
Reply-To: pomac@vapor.com
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl, tino.keitel@tikei.de,
        t.artem@lycos.com
In-Reply-To: <20111129175537.GA10356@tiehlicka.suse.cz>
References: <20111128222803.GA4925@pomac.netswarm.net>
	 <20111129075242.GB2675@tiehlicka.suse.cz> <1322587860.4061.6.camel@pi>
	 <20111129175537.GA10356@tiehlicka.suse.cz>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-CdB0Xbx7oQuVaSpQMiWP"
Date: Tue, 29 Nov 2011 19:37:22 +0100
Message-ID: <1322591842.4061.7.camel@pi>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-CdB0Xbx7oQuVaSpQMiWP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On tis, 2011-11-29 at 18:56 +0100, Michal Hocko wrote:
> On Tue 29-11-11 18:31:00, Ian Kumlien wrote:
> > On tis, 2011-11-29 at 08:52 +0100, Michal Hocko wrote:
> > > On Mon 28-11-11 23:28:03, pomac@vapor.com wrote:
> > > > Hi,=20
> > > >=20
> > > > All this time i have been thinking i'm the only one - and i've been=
 to
> > > > loaded with work during working hours and tired when home =3DP
> > > >=20
> > > > Anyways, I've neen seeing this since -rc1 on:
> > > > Intel(R) Core(TM) i5 CPU U520  @ 1.07GHz - x86-64
> > > > AMD Phenom(tm) II X6 1090T - x86-64
> > > > AMD Athlon(tm) 64 X2 Dual Core Processor 4400+ - x86-64
> > > > Intel(R) Core(TM)2 CPU T7200  @ 2.00GHz - i686
> > > >=20
> > > > Configs available on demand - I've been running the same config for
> > > > quite some time though.
> > >=20
> > > As I have written in other email could you post your config and colle=
ct
> > > the following data?
> > > for i in `seq 30`;=20
> > > do=20
> > >         cat /proc/stat > `date +'%s'`
> > >         sleep 1
> > > done
> > > export old_user=3D0 old_nice=3D0 old_sys=3D0 old_idle=3D0 old_iowait=
=3D0;=20
> > >=20
> > > # for all your available CPUs
> > > grep cpu0 * | while read cpu user nice sys idle iowait rest;=20
> > > do=20
> > >         echo $cpu $(($user-$old_user)) $(($nice-$old_nice)) $(($sys-$=
old_sys)) $(($idle-$old_idle)) $(($iowait-$old_iowait))
> > >         old_user=3D$user old_nice=3D$nice old_sys=3D$sys old_idle=3D$=
idle old_iowait=3D$iowait
> > > done
> >=20
> > Sorry, the previous one was AMD X2 4400+ and now the T7200:

--8<-- [data] --8<--

> OK, so the same thing as in another email in the thread (no idle/io_wait
> accounting).
> Could you double check what kind of idle driver are you using?
> cat /sys/devices/system/cpu/cpuidle/current_driver

"none", on both machines

--=20
Ian Kumlien  -- http://demius.net || http://pomac.netswarm.net

--=-CdB0Xbx7oQuVaSpQMiWP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEABECAAYFAk7VJmIACgkQ7F3Euyc51N91mACgh0XPmq5EpsvPSfInRhe1Ofhg
dDQAmwdd81ZaMGkWOPAuThaxSH4tFr7f
=OlFa
-----END PGP SIGNATURE-----

--=-CdB0Xbx7oQuVaSpQMiWP--

