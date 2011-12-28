Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab1L1VdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 16:33:21 -0500
Received: from sunflower.ift.uni.wroc.pl ([156.17.88.33]:62021 "EHLO
	sunflower.ift.uni.wroc.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab1L1VdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 16:33:19 -0500
X-Greylist: delayed 581 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Dec 2011 16:33:19 EST
Date: Wed, 28 Dec 2011 22:23:33 +0100
From: =?utf-8?Q?=C5=81ukasz?= Michalik <lmi@ift.uni.wroc.pl>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: Possible bug introduced in commit 9b84cca
Message-ID: <20111228212333.GE20378@havoc.ift.uni.wroc.pl>
References: <201112281955.55200.vda.linux@googlemail.com>
 <4EFB850C.4030801@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M/SuVGWktc5uNpra"
Content-Disposition: inline
In-Reply-To: <4EFB850C.4030801@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M/SuVGWktc5uNpra
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 22:07 2011-12-28 +0100, Denys Vlasenko wrote:
> On Thu, Nov 17, 2011 at 10:25:26AM +0100, =C5=81ukasz Michalik wrote:
> > The bug only happens on recent linux.  I've bisected the kernel and
> > found that it was introduced by 9b84cca2564b9 [2] in linux.git, so
> > pretty much everything since 3.0-rc2 is affected.
>=20
> =C5=81ukasz, looks like 3.0-rc1 is affected too.
>=20

Yeah, my git foo failed me back then.  3.0-rc1 is the the first
upstream tag that contains that change.

--=20
Pozdrawiam,
=C5=81ukasz P. Michalik

--M/SuVGWktc5uNpra
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEARECAAYFAk77iNUACgkQ2Du0fXZKF/WDUACgqMQSR/WJ4AnagFSR8sF6UuH6
ZZQAn0MJyuFLa1P6zSMxFj1m4gzQEK4Z
=ZqVZ
-----END PGP SIGNATURE-----

--M/SuVGWktc5uNpra--
