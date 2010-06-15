Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab0FOIoJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 04:44:09 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:41671 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab0FOIoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 04:44:07 -0400
Date: Tue, 15 Jun 2010 10:43:07 +0200
From: Nico Schottelius <nico-linux-20100614@schottelius.org>
To: Borislav Petkov <bp@alien8.de>,
       Nico Schottelius <nico-linux-20100614@schottelius.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-pm@lists.osdl.org
Subject: Re: New issues in 2.6.35-rc{1,2}
Message-ID: <20100615084307.GC9549@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20100614@schottelius.org>,
	Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
	linux-pm@lists.osdl.org
References: <20100614161904.GE31910@schottelius.org>
 <20100614164320.GA4392@a1.tnic>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DIOMP1UsTsWJauNi"
Content-Disposition: inline
In-Reply-To: <20100614164320.GA4392@a1.tnic>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: kr (Linux 2.6.34-NS-08528-gb3f2f6c x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DIOMP1UsTsWJauNi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

And another one: with 2.6.35-rc2 my system freezes after
about 5 times suspend & resume.

I'm now back on 2.6.34-08528-gb3f2f6c, it seems this kernel
reliable suspends & resumes.

Although this issue is an old one, it simply "disappeared", but
has never been solved explicitly, see thread
"2.6.33-2.6.34-rc5 suspend issues" on lkml, from 27 Apr 2010.

Cheers,

Nico

--=20
New PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
Please resign, if you signed 9885188C or 8D0E27A4.

Currently moving *.schottelius.org to http://www.nico.schottelius.org/ ...

--DIOMP1UsTsWJauNi
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwXPRsACgkQ19zI5DGHffDU4wCfSGbARbaw0DvJAxLl7+nA26wi
WfAAoNZ/Hrvs3TS+MbouFiHQiPReNobP
=rSH5
-----END PGP SIGNATURE-----

--DIOMP1UsTsWJauNi--
