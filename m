Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab1GUTeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 15:34:17 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:59593 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452Ab1GUTeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 15:34:16 -0400
Date: Thu, 21 Jul 2011 21:32:41 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, john stultz <johnstul@us.ibm.com>,
        Willy Tarreau <w@1wt.eu>, MINOURA Makoto <minoura@valinux.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Faidon Liambotis <paravoid@debian.org>, linux-kernel@vger.kernel.org,
        stable@kernel.org, seto.hidetoshi@jp.fujitsu.com,
        =?iso-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        Rand@jasper.es, Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        Petr =?iso-8859-1?Q?Kopeck=FD?= <petr.kopecky@linuxbox.cz>
Subject: Re: 2.6.32.21 - uptime related crashes?
Message-ID: <20110721193241.GB6402@nik-comp.lan>
References: <1310434819.30337.21.camel@work-vm> <20110712041938.GO27254@1wt.eu> <1310690138.3367.61.camel@work-vm> <1310724097.2586.296.camel@twins> <1310752795.2945.4.camel@work-vm> <20110721072256.GE9216@elte.hu> <1311251098.29152.130.camel@twins> <20110721125008.GF11246@pcnci.linuxbox.cz> <1311252799.29152.147.camel@twins> <20110721184524.GB381@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GID0FwUMdk1T2AWN"
Content-Disposition: inline
In-Reply-To: <20110721184524.GB381@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 5392756 records (last update: 20110721)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GID0FwUMdk1T2AWN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> yeah - and we also want a Reported-by tag and an explanation of how=20
> it can crash and why it matters in practice. I can then stick it into=20
> the urgent branch for Linus. (probably will only hit upstream in the=20
> merge window though.)

Hello Ingo,

well, I guess You can add me as reporter, but this has been independently=
=20
reported by others as well, as the bug got hit by quite a lot of people...
I'm afraid I won't add much to technical description of how this crashes the
machine apart from what has been discussed in this thread. But the reason w=
hy
this hurts us a lot is that it seems systems running RT tasks are affected =
in
particular, and many of our crashed machines were failover clusters running
pacemaker/corosync (which runs a lot of RT processes). And it really sucks,=
=20
when both nodes of "high-availability" system crash in the same time :(=20
So we were then forced to plan preventive restarts of some of those critica=
l=20
systems just to be sure they don't end up badly..

thanks to You all for taking a look at this!

cheers!

nik






>=20
> Thanks,
>=20
> 	Ingo
>=20

--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799

www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--GID0FwUMdk1T2AWN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk4oftkACgkQ3xdJJrLygV4z6QCffZYFcruWfFIw1AbB/kwjiM6v
HBEAoOXLePP8kZzvkdnDyQj8KsdoXFC4
=4qmn
-----END PGP SIGNATURE-----

--GID0FwUMdk1T2AWN--
