Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab1EYVId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 17:08:33 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:57836 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab1EYVIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 17:08:31 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, oleg@redhat.com,
        vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com, pedro@codesourcery.com
Subject: Re: [PATCH 07/19] ptrace: use bit_waitqueue for TRAPPING instead of wait_chldexit
In-Reply-To: Your message of "Wed, 25 May 2011 16:42:14 +0200."
             <20110525144214.GK10146@htj.dyndns.org>
From: Valdis.Kletnieks@vt.edu
References: <1306262259-7285-1-git-send-email-tj@kernel.org> <1306262259-7285-8-git-send-email-tj@kernel.org> <BANLkTi=6KNJnaXO+guTke_kkinfBXNunBA@mail.gmail.com> <20110525084411.GB10146@htj.dyndns.org> <BANLkTi=O5vG=pgaYsE-6GXODwF910Q2qwA@mail.gmail.com>
            <20110525144214.GK10146@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1306357694_2932P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 25 May 2011 17:08:14 -0400
Message-ID: <25746.1306357694@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4DDD6FC1.008A,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1306357694_2932P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, 25 May 2011 16:42:14 +0200, Tejun Heo said:

> > You can get a good idea of the code quality if you grep for users. I
> > don't think it's an accident at all that the two big blocks are
> > ide-tape and some infiniband drivers.
>=20
> Maybe, but also ilog2() is relatively new and most already had ways to
> deal with bit positions and masks, so the uptake is expected to be
> slow.

One has to wonder how ide-tape got to be a early-adopter user of *anythin=
g*.

--==_Exmh_1306357694_2932P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN3W++cC3lWbTT17ARAi8NAJsHCSbld7FtF7C98I+XyHPa2MFImACfQceQ
WQ36C3eYuS29Qyve+qxQRm0=
=R6qY
-----END PGP SIGNATURE-----

--==_Exmh_1306357694_2932P--

