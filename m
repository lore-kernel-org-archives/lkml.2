Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab1LFPbV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 10:31:21 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49973 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755145Ab1LFPbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 10:31:15 -0500
Message-ID: <1323185442.7454.266.camel@deadeye>
Subject: Re: [tip:core/locking] lockdep, bug: Exclude
 TAINT_FIRMWARE_WORKAROUND from disabling lockdep
From: Ben Hutchings <ben@decadent.org.uk>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Date: Tue, 06 Dec 2011 15:30:42 +0000
In-Reply-To: <20111206151345.GA22353@elliptictech.com>
References: <tip-xopopjjens57r0i13qnyh2yo@git.kernel.org>
	 <20111206151345.GA22353@elliptictech.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-4Lz+9Q89wDv4P9msIIWq"
X-Mailer: Evolution 3.0.3-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4Lz+9Q89wDv4P9msIIWq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-12-06 at 10:13 -0500, Nick Bowler wrote:
> On 2011-12-06 01:38 -0800, tip-bot for Peter Zijlstra wrote:
> > Commit-ID:  df754e6af2f237a6c020c0daff55a1a609338e31
> > Gitweb:     http://git.kernel.org/tip/df754e6af2f237a6c020c0daff55a1a60=
9338e31
> > Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> > AuthorDate: Mon, 14 Nov 2011 13:13:49 +0100
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Tue, 6 Dec 2011 08:16:47 +0100
> >=20
> > lockdep, bug: Exclude TAINT_FIRMWARE_WORKAROUND from disabling lockdep
> >=20
> > It's unlikely that TAINT_FIRMWARE_WORKAROUND causes false
> > lockdep messages, so do not disable lockdep in that case.
> > We still want to keep lockdep disabled in the
> > TAINT_OOT_MODULE case:
> >=20
> >   - bin-only modules can cause various instabilities in
> >     their and in unrelated kernel code
> >=20
> >   - they are impossible to debug for kernel developers
> >=20
> >   - they also typically do not have the copyright license
> >     permission to link to the GPL-ed lockdep code.
>=20
> This is all bogus.  We have a proprietary module taint for the above.
> Out of tree does not mean "bin-only", "non-GPL" or anything else like
> that.  If the intent is to tell out of tree, GPL module developers to
> fuck off and die, then just go all the way and delete support for out
> of tree modules from Kbuild.  May as well go further and just prevent
> the kernel from loading such modules outright, too.
>=20
> Don't gag developers by arbitrarily disabling kernel debugging
> functionality: functionality that they can use to debug their
> *GPL* modules.

I totally agree; *I* wanted to keep lockdep enabled for (GPL-compatible)
OOT modules.

Ben.

--=20
Ben Hutchings
Absolutum obsoletum. (If it works, it's out of date.) - Stafford Beer

--=-4Lz+9Q89wDv4P9msIIWq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATt41Iue/yOyVhhEJAQpkDg/+PMPmM6uDER5p6fbAgBI9F5532ou1FFpY
j96N9wN0vDxyMMpsNQUBtDR6eKzlIGCrjRv3Ap2K8kFUHuaG35gcknUELxHJWeXc
1Gu0rRZi9ntGz12Pcy5xl98JWeaf8sVUsUP0x61IFjoMqkLAERtBmxImrwkKpHuI
3M263WBrKR/LAyJBp1YzdXCiXz/xroaYqmh5liEoA7d12G2zQWYCSyY7pDTZAPLE
fMSx8mc5v5xH5bGXu0uwOpnybpUSMNs7ayFAX40y4WBiI1lZnCrIZgXeYru7FSG3
61eY+G2OnZ0iWYyWdqAF40H/DwzzEjZfpW/pzv93EKwbIrpcT737/RE81nyzTfpU
c6KKhDE7+khDyTSZb16P6Htt8EPOYMesLvKS1jxhk/+9N/SoDieFZcWj83YrsyS2
2eyP64iJy0Bxw6yo4C1O7lZ5FbkHX5zDWe+N53FbmT5mOaaeswMX19HcqIq25Kh/
WsSuAeCLJ2szvEZU9dWn3IxDxGgNkAV+J6EZgCrfMICvmuzzFqFQw1+6QuTiK+yp
5J5O4ChlV21tluRB4cl9LAs4B6y05zBd5HdV+jvfAKi8Zzc6TmlR5QqgoWizJXlL
xh5G+6BB74LjCAKslobAiOgNV10pbc6X5AfrqpvE3OWZCLs/rrxsxeqDqPIvr1g+
reOo6Wvzp3U=
=BmI7
-----END PGP SIGNATURE-----

--=-4Lz+9Q89wDv4P9msIIWq--
