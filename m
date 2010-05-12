Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab0ELGdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 02:33:53 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:44419 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab0ELGdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 02:33:51 -0400
X-Greylist: delayed 468 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 May 2010 02:33:51 EDT
Date: Wed, 12 May 2010 08:08:43 +0200
From: Nico Schottelius <nico-kernel@schottelius.org>
To: Nico Schottelius <nico-linux-20100427@schottelius.org>,
       Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: Re: 2.6.33-2.6.34-rc5 suspend issues
Message-ID: <20100512060843.GA20895@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-kernel@schottelius.org>,
	Nico Schottelius <nico-linux-20100427@schottelius.org>,
	Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
	Linux-pm mailing list <linux-pm@lists.osdl.org>
References: <20100427074609.GA3261@ikn.schottelius.org>
 <20100427083202.GA3143@ikn.schottelius.org>
 <20100428160935.GA4010@schottelius.org>
 <20100429191241.GA3407@schottelius.org>
 <20100501122441.GA3273@schottelius.org>
 <20100504041849.GA1262@ucw.cz>
 <20100504144714.GA3527@schottelius.org>
 <20100507135704.GB3455@schottelius.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
In-Reply-To: <20100507135704.GB3455@schottelius.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: kr (Linux 2.6.34-rc7-NS x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Nico Schottelius [Fri, May 07, 2010 at 03:57:04PM +0200]:
> Nico Schottelius [Tue, May 04, 2010 at 04:47:16PM +0200]:
> > Pavel Machek [Tue, May 04, 2010 at 06:18:50AM +0200]:
> > > On Sat 2010-05-01 14:24:41, Nico Schottelius wrote:
> > > > Nico Schottelius [Thu, Apr 29, 2010 at 09:12:42PM +0200]:
> > > > > Nico Schottelius [Wed, Apr 28, 2010 at 06:09:36PM +0200]:
> > > > > > Nico Schottelius [Tue, Apr 27, 2010 at 10:32:02AM +0200]:
> > > > > > >=20
> > > > > > > Nico Schottelius [Tue, Apr 27, 2010 at 09:46:09AM +0200]:
> > > > > > > > [..]=20
> > > > > > > > - suspend & resume works once
> > > > > > > > - second time system
> > > > > > > >   b) suspends, but comes up with the bios screen after resu=
me
> > > > > > > >      and hangs there forever (2.6.34-*)
> > > ...
> > > > Same happens on 2.6.34-rc5-00340-g79dba2e, now testing
> > > > 2.6.34-rc6-00063-gbe1066b.
> > >=20
> > > There's one bit that needs to be set to stay in the acpi mode, and
> > > there's blacklist somewhere...?
> >=20
> > Don't know if I should answer the question, but the problem also happens
> > on 2.6.34-rc6-00063-gbe1066b.
> >=20
> > Now compiling v2.6.34-rc6-106-gd93ac51.
>=20
> Same issue on 2.6.34-rc6-00201-g722154e.

Success, success! With 2.6.34-rc7 I can resume at least two times!

I'll keep an eye on it and notify you if things continue to work / break ag=
ain.

Cheers,

Nico

--=20
New PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
Please resign, if you signed 9885188C or 8D0E27A4.

Currently moving *.schottelius.org to http://www.nico.schottelius.org/ ...

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvqReoACgkQ19zI5DGHffAXBACg7/Hny8rhY8KWAU1DXhgUln/m
fC8AoMQXy0iufCu7wtEfyPpKAtShvTeW
=MHd/
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
