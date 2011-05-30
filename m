Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab1E3M4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 08:56:34 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:51541 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab1E3M4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 08:56:32 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Oliver Neukum <oneukum@suse.de>
Cc: david@lang.hm, "D. Jansen" <d.g.jansen@googlemail.com>,
        Theodore Tso <tytso@mit.edu>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        njs@pobox.com, bart@samwel.tk
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
In-Reply-To: Your message of "Mon, 30 May 2011 09:13:27 +0200."
             <201105300913.27971.oneukum@suse.de>
From: Valdis.Kletnieks@vt.edu
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com> <BANLkTi=BgGagV+dN9-nFcSkNsGNKbRMLfQ@mail.gmail.com> <alpine.DEB.2.02.1105291850260.5766@asgard.lang.hm>
            <201105300913.27971.oneukum@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1306760150_27223P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 30 May 2011 08:55:50 -0400
Message-ID: <148710.1306760150@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020204.4DE393DB.0025,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1306760150_27223P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 30 May 2011 09:13:27 +0200, Oliver Neukum said:
> Am Montag, 30. Mai 2011, 03:53:18 schrieb david=40lang.hm:

> > if what you are wanting is the ability to say 'these things must be=20
> > written before these other things to keep them from being corrupted, =
but I=20
> > don't care when they get written (or if they get lost in a crash)' th=
en=20
> > what you want isn't fsync, it's a barrier.
>=20
> Yes, but where is the problem?

The problem is that *from userspace*, the closest approximation to a barr=
ier
is fsync().

--==_Exmh_1306760150_27223P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN45PWcC3lWbTT17ARAkpDAJ97EjrjgpV6WG5y8vQuFa7Z+zkdMwCgtVvH
3WZx41LLrwVvCWMbm160E8U=
=Egpe
-----END PGP SIGNATURE-----

--==_Exmh_1306760150_27223P--

