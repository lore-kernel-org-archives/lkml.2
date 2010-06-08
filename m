Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab0FHFk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 01:40:59 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:57211 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab0FHFk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 01:40:58 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jeffrey Merkey <jeffmerkey@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-kernel@vger.kernel.org
Subject: Re: EXT3 File System Corruption 2.6.34
In-Reply-To: Your message of "Mon, 07 Jun 2010 20:37:06 MDT."
             <AANLkTil3D5w9Cg2_8GmFa-i0szYmhAu61AXdaLvwp3xv@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <AANLkTinQatQEYahpkN3bT-S5C41HqRoH--gTrvIbGs_c@mail.gmail.com> <4C0D5DCD.5010201@sandeen.net> <AANLkTik1T2nJxsoK9UGIVy6q6pfSxniFfJXJY0InmuUh@mail.gmail.com> <AANLkTil4FMnGl7llR4N0PkXuNyEClQmTspNK6PT62PAi@mail.gmail.com> <889B6B31-A1F0-438D-B782-DBB855912854@sandeen.net> <AANLkTilrmEnLrxRSYNnwr8vFaZi7R9U5vY39NmBWUEMy@mail.gmail.com> <C4177A0B-9A74-40E6-9A58-64418034232C@sandeen.net> <AANLkTinzZkN9agekI5eqzA9hERsghI7yDJyAy1O755dr@mail.gmail.com> <4C0DA955.7020802@sandeen.net>
            <AANLkTil3D5w9Cg2_8GmFa-i0szYmhAu61AXdaLvwp3xv@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1275975644_4518P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 08 Jun 2010 01:40:44 -0400
Message-ID: <15142.1275975644@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020204.4C0DD7DD.0078,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1275975644_4518P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 07 Jun 2010 20:37:06 MDT, Jeffrey Merkey said:
> Cool.  I'll use that from now on.  wonder if the source code came from
> xdump 10 years ago ... LOL

Probably not, given that 'man hexdump' says:

BSD                             April 18, 1994                           =
  BSD

Plus, they obviously rolled the code for '-e formatstring' themselves, no=
body
could have been so desperate to steal that code. ;)

hexdump -e '=22%08.08_ax  =22 4/4 =22%08X =22 =22  =22 4/4 =22%08x =22 ' =
-e '=22  *=22 32/1 =22%_p=22' -e '=22*=5Cn=22'

That's so old-skool it hurts. :)



--==_Exmh_1275975644_4518P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMDdfccC3lWbTT17ARAkEDAKC5uPPFlDoZNDFKZ61FCc02ajpaEgCglIp1
eoypf7PhMIwN+r2MHKZMhKo=
=1TpQ
-----END PGP SIGNATURE-----

--==_Exmh_1275975644_4518P--

