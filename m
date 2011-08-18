Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab1HRIQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 04:16:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:12002 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755288Ab1HRIQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 04:16:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,244,1312182000"; 
   d="asc'?scan'208";a="41006685"
Subject: Re: [PATCH] checkpatch: do not test/warn of leading whitespace
 before signature tags
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Joe Perches <joe@perches.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        Anish Kumar <anish198519851985@gmail.com>,
        Andy Whitcroft <apw@canonical.com>
Date: Thu, 18 Aug 2011 01:16:53 -0700
In-Reply-To: <1313654341.32547.62.camel@Joe-Laptop>
References: <1313650112-17287-1-git-send-email-jeffrey.t.kirsher@intel.com>
	 <1313652390.32547.53.camel@Joe-Laptop>
	 <1313653632.2128.88.camel@jtkirshe-mobl>
	 <1313654341.32547.62.camel@Joe-Laptop>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-dDpxkTeLr2i2WBLDom7h"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Message-ID: <1313655414.2128.102.camel@jtkirshe-mobl>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-dDpxkTeLr2i2WBLDom7h
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2011-08-18 at 00:59 -0700, Joe Perches wrote:
> On Thu, 2011-08-18 at 00:47 -0700, Jeff Kirsher wrote:
> > On Thu, 2011-08-18 at 00:26 -0700, Joe Perches wrote:
> > > On Wed, 2011-08-17 at 23:48 -0700, Jeff Kirsher wrote:
> > > > From: Bruce Allan <bruce.w.allan@intel.com>
> > > >=20
> > > > Commit 2011247 introduced additional style checks for signature tag=
s in
> > > > patches which is good.  Unfortunately, now whenever patches are che=
cked
> > > > by piping the output of 'git show' or 'stg show' through checkpatch=
 it
> > > > warns not to use whitespace before all signature tags since these (=
and the
> > > > rest of the patch description) are indented.  Remove this test/warn=
ing.
> > >=20
> > > I think this is not a good idea.
> > >=20
> > > checkpatch is meant for patches not git log output.
> > > indenting signatures can cause other problems later.
> > >=20
> > > I think you can avoid this easily by using checkpatch
> > > option --ignore=3DBAD_SIGN_OFF when using git log output
> > > as input.
> >=20
> > The problem I have with this is that the sign-off's are not bad, they
> > are by default indented by 'git show' or 'stg show' so checkpatch.pl
> > should handle the "default" formatting of git/stg and if there is
> > additional indenting not expected, then the sign-off's should be
> > considered bad.
>=20
> I disagree.
>=20
> checkpatch should handle the default input of patches
> as best it can.
>=20
> I suppose checkpatch could have a different "--input=3Dgit"
> or some such to avoid certain things that git might produce
> that a patch would not.
>=20
> Deleting useful checks for patches isn't a good idea.
>=20
> > If this option is added, then if there were "real"
> > problems with the sign-off, it would not be displayed.
>=20
> So what?
>=20
> It would also be too late to do anything about
> it anyway as it would already be committed.

To add...

Specifically, most maintainers ask developers to run checkpatch.pl on
their patches before submitting them to the community.  As part of our
patch validation process, our validation team runs checkpatch.pl on
every patch I submit and we are now getting constant warnings about good
sign-off's with this recent change.  I personally end up reviewing all
the warnings to ensure that they are false warnings and not "real"
issues with the sign-off's.

>=20
> > > You could also use:=20
> > > git log --format=3D"commit %H%nAuthor: %an <%ae>%nDate:   %aD%n%n%s%n=
%n%b"
> > > so that you get the current default --format=3Dmedium
> > > output without indenting the commit log body.
> > Even doing this does not resolve the "false" warnings" that
> > checkpatch.pl produces regarding the sign-off's.
>=20
> I tried it.  It works for me.
> What about it doesn't work for you?
>=20
>=20



--=-dDpxkTeLr2i2WBLDom7h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJOTMp1AAoJECTsCADr/EWUNFgH/2RVZLsQ4ZafEczpjjcIEzfb
ip1rWjdR6zJpV835sJyzAKS+8I0p5N4Gl7UggHwTXuMYnhVVE55ZLX5vwJtRRNKZ
btUfQ7qv83TrrGUaWnpmG5h1+Zjuo8cFCWi6qNjhuEmQlJbcsPbrV5ALkeNHNAfg
VZ60andtV31zPurCMICTkyYRcHdPPsieQbd+zPMaDvyF/Leu2ZGVxRVZXKUTkslQ
p2IL505Q7srBb52zojWqaro4zCRQEDfhbmGYIV/pNM8SMx8rnVKEp2gyGC0YU8vs
fQrVtVgJ08R4XtJNQ9rRmk6cLYe9XTesnVl94BSLRv/P3dGPFC9JtUkXRkI6T1o=
=aI3t
-----END PGP SIGNATURE-----

--=-dDpxkTeLr2i2WBLDom7h--

