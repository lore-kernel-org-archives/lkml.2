Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397Ab0EFRJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 13:09:49 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:49381 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab0EFRJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 13:09:48 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jerome Glisse <jglisse@redhat.com>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
       dri-devel@lists.freedesktop.org
Subject: Re: linux-next - drm/ttm versus nouveau - WARNING and dead driver.
In-Reply-To: Your message of "Thu, 06 May 2010 18:56:10 +0200."
             <20100506165610.GB8934@barney.localdomain>
From: Valdis.Kletnieks@vt.edu
References: <7841.1273161966@localhost> <j2gb170af451005060916of64cbd20x12ea697de19931b2@mail.gmail.com>
            <20100506165610.GB8934@barney.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1273165755_4094P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 06 May 2010 13:09:15 -0400
Message-ID: <4162.1273165755@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020201.4BE2F7BC.00FB,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1273165755_4094P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, 06 May 2010 18:56:10 +0200, Jerome Glisse said:
> On Thu, May 06, 2010 at 06:16:26PM +0200, Rafał Miłecki wrote:
> > 2010/5/6  <Valdis.Kletnieks=40vt.edu>:
> > > Bisected down to:
> > >
> > > 82c5da6bf8b55a931b042fb531083863d26c8020 is the first bad commit
> > > commit 82c5da6bf8b55a931b042fb531083863d26c8020
> > > Author: Jerome Glisse <jglisse=40redhat.com>
> > > Date: =A0 Fri Apr 9 14:39:23 2010 +0200
> > >
> > > =A0 =A0drm/ttm: ttm_fault callback to allow driver to handle bo pla=
cement V6
> >=20
> > Can this be duplicate of https://bugs.freedesktop.org/show_bug.cgi?id=
=3D27822
 ?
> >=20
> > --=20
> > Rafał
>=20
> Yes this is a duplicate of :
> https://bugs.freedesktop.org/show_bug.cgi?id=3D27822
>=20
> The patch attached in the bug should fix your issue. Sorry for the
> trouble.

Confirming that the patch does fix the problem, thanks.

--==_Exmh_1273165755_4094P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFL4ve7cC3lWbTT17ARAmvHAKCbuGrmFsasGqvRyKTPWZ+9YCYj1wCfW6Ew
B1Ik//NjrvCT3jMIP/KTpu0=
=nITH
-----END PGP SIGNATURE-----

--==_Exmh_1273165755_4094P--

