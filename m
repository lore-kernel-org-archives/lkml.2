Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab0IJIZz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 04:25:55 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:58128 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab0IJIZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 04:25:53 -0400
Date: Fri, 10 Sep 2010 10:26:23 +0200
From: Nico Schottelius <nico-linux-20100709@schottelius.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nico Schottelius <nico-linux-20100709@schottelius.org>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.36-rc3 suspend issue (was: 2.6.35-rc4 / X201 issues)
Message-ID: <20100910082623.GA2795@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20100709@schottelius.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Jeff Chua <jeff.chua.linux@gmail.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20100709170432.GA7691@schottelius.org>
 <201009072348.41344.rjw@sisk.pl>
 <20100907225004.GA2805@schottelius.org>
 <201009080128.52849.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <201009080128.52849.rjw@sisk.pl>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: kr (Linux 2.6.34 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Rafael J. Wysocki [Wed, Sep 08, 2010 at 01:28:52AM +0200]:
> For me -rc3 is pretty much usable already.

Update: vmlinuz-2.6.36-rc3-00185-gd56557a behaves identical,
black screen on resume, X201 dead.

Cheers,

Nico

--=20
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkyJ668ACgkQ19zI5DGHffAueACdFwhDN6J5ySZ8rFsPmwG6IZlC
1vwAoM5O8WkVO8xxuh75PjU2i0K5exnc
=owg/
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
