Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab0JUNuQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:50:16 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:42146 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932166Ab0JUNuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:50:15 -0400
X-Authenticated: #15668376
X-Provags-ID: V01U2FsdGVkX1/xRIZiuGvxWJhWpeBSU+i5m/0dVhUo5pZ9qTjNcm
	IKj9FiylJX74Da
From: Sven Eckelmann <sven.eckelmann@gmx.de>
To: Greg KH <greg@kroah.com>
Subject: Re: [B.A.T.M.A.N.] [resend][PATCHv2] staging: batman-adv: remove useless addr_to_string()
Date: Thu, 21 Oct 2010 15:51:12 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.32-5-amd64; KDE/4.4.5; x86_64; ; )
Cc: b.a.t.m.a.n@lists.open-mesh.org, devel@driverdev.osuosl.org,
        "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Marek Lindner <lindner_marek@yahoo.de>
References: <1287589664-25447-1-git-send-email-andy.shevchenko@gmail.com> <201010211441.39483.sven.eckelmann@gmx.de> <20101021133848.GC20184@kroah.com>
In-Reply-To: <20101021133848.GC20184@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart20442021.5PmmWb4flc";
  protocol="application/pgp-signature";
  micalg=pgp-sha512
Content-Transfer-Encoding: 7bit
Message-Id: <201010211551.14371.sven.eckelmann@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart20442021.5PmmWb4flc
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Greg KH wrote:
> On Thu, Oct 21, 2010 at 02:41:37PM +0200, Sven Eckelmann wrote:
> > Greg KH wrote:
> > > On Thu, Oct 21, 2010 at 12:16:37AM +0200, Sven Eckelmann wrote:
> > > > On Wed, Oct 20, 2010 at 01:57:49PM -0700, Greg KH wrote:
> > > > > On Wed, Oct 20, 2010 at 10:51:15PM +0200, Sven Eckelmann wrote:
> > > > > > On Wed, Oct 20, 2010 at 06:47:44PM +0300, Andy Shevchenko wrote:
> > > > > > > Since all *printf() methods in the kernel understand '%pM'
> > > > > > > modifier the conversion to the string is useless beforehand.
> > > > > > >=20
> > > > > > > Additionally this patch decreases batman_if structure by 20
> > > > > > > bytes.
> > > > > >=20
> > > > > > Thanks for your patch. I have problems with compiling due to
> > > > > > other patches in the queue. I will fix that and recommend it as
> > > > > > patch for 2.6.38.
> > > > >=20
> > > > > What do you mean by this?  It applies just fine to my tree, so why
> > > > > can't I take it now?
> > > >=20
> > > > If you want then do so, but the stuff in batman-adv's master must be
> > > > fixed so they have to apply the v3 version of the patch and not the
> > > > v2 version Andy sent.
> > >=20
> > > That's one of the problems with having an out-of-tree tree.  Please
> > > don't do that at all anymore.
> >=20
> > I don't see a difference in a in-tree tree and and out-of-tree tree when
> > applying patches somewhere else out of order. In both situations we have
> > a merge conflict (not that the scm says "omg, i cannot merge it" but
> > that the thing doesn't compile after the merge).
>=20
> Not true at all, the in-linux-next tree builds just fine with this
> patch.  In fact, it's now in linux-next already.

He? I never said that it breaks stuff in your staging tree.

> > I always thought that even when the source is in the kernel (or in
> > staging) that there are still a maintainer responsible for it. That this
> > person has to go through the patches and look if they do whatever they
> > claim to do and that this isn't against what the original implementation
> > had to do or should do.
>=20
> Yes, but sometimes, especially for trivial patches, the maintainer is
> routed around and patches go in through other trees.
>=20
> Remember a maintainer is not someone who can say "no" to all patches
> that comes in, sorry, we don't work that way.

What? I no batman-adv maintainer said no to patches on the lkml or other li=
nux=20
related mailing lists as far as I can remember, but postponed them or=20
recommended changes.

There were patches dropped in the past which didn't make sense or created m=
ore=20
problems than they solved - but that was even before batman-adv entered=20
staging.

thanks,
	Sven

--nextPart20442021.5PmmWb4flc
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABCgAGBQJMwEVRAAoJEF2HCgfBJntGZWQP/11baSKY2u+zlkjbSsASxWfi
JwGNxA1DZ/KYyx4lPF9hUhDBRIQQSI34IARigkarAZ2mPi2ADyse4pQwt3ettXsc
6CRyRiHTTSms96gAjICTKBOsQw2QGTjhP+XPkXsCkwA2U1F2sAJf8nkVkLzrEpQm
yDRsKgJfw5c6tl9EVABw9w5795dLLnZrB3W05u8UX8O9liusubHkc6RkThwoFLDa
EYwtVvk7EHbuvo/7cAkHsZayI4Z0c6pJ2fBMuQmOFEvbMiVbFTMZe7ePdV6Ar41H
KOtvmy5IhTuDnsiu30fVtVPoO5/kDa1tpd4l6UiYnhnnLCmuHbOKHLEW0tNygWnd
6UIMxk3u6ugUMY0HcW9YphiT+cOUVDb5RukeDq8y0MMw9SMkSiQKUcbm5gOgE0/H
9HMgHCqraaPuHU0Ux10NjYIyKGF96cXTwhj4DtJgsana9yiX2hR8juvePKuTsUVa
qLK19XoWeBDMDQFhy/CWfHSTYR/EK8s8GUtFr/zIP8Xs8PUgtfrvVn3psahknisE
VJX4l7s6T5Yljcji2dFaEjAtCkWxBeJ4LdOgWH3IQ41CuUPG4DgP67WqyLonqGDO
DSu0rCPEvkMxDRBlg97Zz0o56I+HaCFzALqTR9fwxfiGagdNKEzbcVv5r94l5i27
QdZA8e1CHdJal1GmWk3o
=22FI
-----END PGP SIGNATURE-----

--nextPart20442021.5PmmWb4flc--
