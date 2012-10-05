Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab2JERtx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 13:49:53 -0400
Received: from tee.schottelius.org ([77.109.138.222]:46247 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751223Ab2JERtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 13:49:52 -0400
Date: Fri, 5 Oct 2012 19:51:39 +0200
From: Nico Schottelius <nico-kernel20120920@schottelius.org>
To: Valdis.Kletnieks@vt.edu
Cc: Nico Schottelius <nico-kernel20120920@schottelius.org>,
        David Rientjes <rientjes@google.com>,
        Arend van Spriel <arend@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Dave Kleikamp <shaggy@kernel.org>,
        jfs-discussion@lists.sourceforge.net
Subject: Re: Out of memory on 3.5 kernels
Message-ID: <20121005175139.GC831@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-kernel20120920@schottelius.org>,
	Valdis.Kletnieks@vt.edu, David Rientjes <rientjes@google.com>,
	Arend van Spriel <arend@broadcom.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Dave Kleikamp <shaggy@kernel.org>,
	jfs-discussion@lists.sourceforge.net
References: <505B1FA0.6030100@broadcom.com>
 <20120921194931.GA732@schottelius.org>
 <alpine.DEB.2.00.1209241538310.6356@chino.kir.corp.google.com>
 <20120926060653.GD16575@schottelius.org>
 <20120926085708.GA7839@schottelius.org>
 <20120927055208.GA25252@schottelius.org>
 <20121003212311.GA14018@schottelius.org>
 <22962.1349452084@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
In-Reply-To: <22962.1349452084@turing-police.cc.vt.edu>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: brief (Linux 3.5.4-1-ARCH x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Valdis,

Valdis.Kletnieks@vt.edu [Fri, Oct 05, 2012 at 11:48:04AM -0400]:
> On Wed, 03 Oct 2012 23:23:11 +0200, Nico Schottelius said:
>=20
> > does anyone of you have a clue so far what may be causing the huge
> > slab usage?
> >
> > I've just found an interesting detail: umounting and cryptsetup
> > luksClosing frees up the used memory (not sure which one was freeing
> > up)
>=20
> For what it's worth, I'm seeing a similar problem in linux-next on my lap=
top -
> trying to run a backup to an external hard drive that has a LUKS partitio=
n on
> it will OOM. (For some reason having the external LUKS partition is much =
more
> problematic than the LVM-on-LUKS on the internal drive)

Indeed, I also have the internal drive encrypted with LUKS, also jfs
on it, but the problem only occurs on the external drive.

Is there the possibility that the JFS on the external drive got into a
state that may caus JFS to behave unexpected? If this is true, it would
explain why it happens only with the external drive and also accross
kernel versions.

But "good" to hear I am not the only one affected anymore.

Cheers,

Nico


--=20
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlBvHisACgkQ19zI5DGHffB0MwCgrfpBRbsEgPDDg9Lw0133tha3
tL8AoOmJhDbskp7PUTGtHoWOd1C8fR2q
=o/zS
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
