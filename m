Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab1GUT2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 15:28:40 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:48761 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634Ab1GUT2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 15:28:36 -0400
Date: Thu, 21 Jul 2011 21:25:45 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
        Willy Tarreau <w@1wt.eu>, MINOURA Makoto <minoura@valinux.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Faidon Liambotis <paravoid@debian.org>, linux-kernel@vger.kernel.org,
        stable@kernel.org, seto.hidetoshi@jp.fujitsu.com,
        =?iso-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        Rand@jasper.es, Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: 2.6.32.21 - uptime related crashes?
Message-ID: <20110721192545.GA6402@nik-comp.lan>
References: <kk5d3hgi9eh.fsf@brer.local.valinux.co.jp> <1310434819.30337.21.camel@work-vm> <20110712041938.GO27254@1wt.eu> <1310690138.3367.61.camel@work-vm> <1310724097.2586.296.camel@twins> <1310752795.2945.4.camel@work-vm> <20110721072256.GE9216@elte.hu> <1311251098.29152.130.camel@twins> <20110721125008.GF11246@pcnci.linuxbox.cz> <1311252799.29152.147.camel@twins>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <1311252799.29152.147.camel@twins>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 5392756 records (last update: 20110721)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Peter,

> With a patch that frobs the starting value close to overflowing I hope,
> otherwise we'll not hear from you in like 7 months ;-)
sure. Which is the best patch to use for testing, You mean john's one?
(http://www.gossamer-threads.com/lists/linux/kernel/1406779#1406779)
or some other?
nik

> Yeah, I think we want to commit this with a -stable tag, Ingo?
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

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk4ofTkACgkQ3xdJJrLygV5lrACcDz+E3HdPVvEP37yFwxD7HUtm
+XUAn2c+KES/MHs5Ra4y2Hxq+GRp+38g
=78f6
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
