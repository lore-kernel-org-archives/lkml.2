Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab2JLBXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 21:23:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50333 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757162Ab2JLBXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 21:23:09 -0400
Message-ID: <1350004968.4832.12.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 2.6.32.y, 2.6.34.y] ALSA: hda - ALSA HD Audio patch for
 Intel Panther Point DeviceIDs
From: Ben Hutchings <ben@decadent.org.uk>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>, stable@vger.kernel.org,
        Ana Guerrero <ana@debian.org>, Willy Tarreau <w@1wt.eu>,
        Takashi Iwai <tiwai@suse.de>, Seth Heasley <seth.heasley@intel.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Date: Fri, 12 Oct 2012 02:22:48 +0100
In-Reply-To: <50743B15.4020700@windriver.com>
References: <201104201059.57882.seth.heasley@intel.com>
	  <s5htydsiw20.wl%tiwai@suse.de> <20121009010734.GA24147@elie.Belkin>
	 <1349747733.6336.19.camel@deadeye.wl.decadent.org.uk>
	 <50743B15.4020700@windriver.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-qZZ3QmaqpNyhw6inUG+C"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qZZ3QmaqpNyhw6inUG+C
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-10-09 at 10:56 -0400, Paul Gortmaker wrote:
> On 12-10-08 09:55 PM, Ben Hutchings wrote:
> > On Mon, 2012-10-08 at 18:07 -0700, Jonathan Nieder wrote:
> >> From: Seth Heasley <seth.heasley@intel.com>
> >> Date: Wed, 20 Apr 2011 10:59:57 -0700
> >>
> >> commit d2edeb7c6f1dada8ca7d5c23e42d604e92ae0c76 upstream.
> >>
> >> This patch adds the HD Audio Controller DeviceIDs for the Intel Panthe=
r Point PCH.
> >>
> >> [jn: backported for 2.6.32.y by Ana Guerrero]
> >>
> >> Signed-off-by: Seth Heasley <seth.heasley@intel.com>
> >> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> >> Tested-by: Ana Guerrero <ana@debian.org> # EliteBook 8570w
> >> Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
> >> ---
> >> Hi Willy and Paul,
> >>
> >> Please consider
> >>
> >>   d2edeb7c6f1d ALSA: hda - ALSA HD Audio patch for Intel Panther Point
> >>                DeviceIDs
> >>
> >> for application to the 2.6.32.y and 2.6.34.y trees.
> >>
> >> It does what it says on the cover.  The patch was merged in the 3.0
> >> cycle, so newer stable kernels don't need it.  Backported and
> >> tested[1] against Debian's 2.6.32.y-based kernel by Ana (cc-ed) --
> >> thanks!
> >>
> >> Thoughts of all kinds welcome, as always.
> > [...]
> >=20
> > I queued up a whole series of device ID updates for Debian stable, as
> > they didn't obviously depend on other changes:
> >=20
> > cea310e ALSA: hda_intel: ALSA HD Audio patch for Intel Patsburg DeviceI=
Ds
> > e35d4b1 ALSA: hda: add Vortex86MX PCI ids
> > 0f0714c ALSA: hda - Add support for VMware controller
> > d2edeb7 ALSA: hda - ALSA HD Audio patch for Intel Panther Point DeviceI=
Ds
>=20
> I found that d2edeb7c6f depends (only trivially, on context) on b68645354=
3f,
> which makes a blanket class for intel IDs so that "...the driver will wor=
k
> with any new control chips in future."   In that respect, I guess it too
> (b68645) is in the same class as the other "add more IDs" patches?

Yes, it seems like this would also be worth adding.  (Always assuming
that any functional changes it depends on are also small enough for
stable.)  It's not a clean cherry-pick as the line above has changed.

Ben.

> Paul.
> --
>=20
> >=20
> > (They can be cherry-picked cleanly in the above order.)  But if I've
> > missed some post-2.6.32 dependencies then I would like to know.
> >=20
> > Ben.
> >=20
>=20

--=20
Ben Hutchings
Kids!  Bringing about Armageddon can be dangerous.  Do not attempt it in
your own home. - Terry Pratchett and Neil Gaiman, `Good Omens'

--=-qZZ3QmaqpNyhw6inUG+C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUHdw6Oe/yOyVhhEJAQpqKw//XcRUXd57luf7dEDD6KNip4Jm+A5fGvDo
gOc9390uocnUxldVaWhnMF+P4hWILu9/JvCe6ECLYbf4Mg2fHcnqXXddFiatgtme
n5piPrNZL/N5/6/oowLouPNiWIZbYWdDF9X4EZGlpjyrk/fDn3GJJhjLzPLxQA8D
/jAA0Fezo0R0DF//xs/6RQGTWePArAG03PJ9Xu2jRx+EUh3Lm6xKZs31SIpcdyeK
EpzxVGBDIVTmrv61B+nGYrEXZINQoO8G3rU0A+k1POvpxEMkZuvMhp0fHs9n7jNX
XBNd4rkkhIYS+5Lk/JukET+HFQ7VXwqyAmCJT3t7L8bfoM1pDixeSYxQZmv6wjXD
izceEv/8dUckBbEjxwzmv6jKuzTHl6MJuyRh/+0zQRqeOEId7VwgM66B9lRTKkpF
t3o7ZyC8gzLx/w6GLJtk7hESULEpoE9yqA1TBOw3UtY9ychuLNRrsZC+kictDRU9
o98tgwILDs8fLrgh9iqTk5I+jxiwQiV3y/W8LhT6y6uQn9fePFUpcfPZG2L971Pk
Alm7ccnAy3YpSCtZqIfGrHWjY2QADVdxaQ+t+HneYkwhRyCmPJ0ePoO0+ThBaOSQ
m9XMlxZNzo9wmhQm002Vzy7Ru/T49MWntBenaKlo7vmTwyYFFI4J7wOfDR3GJ2V2
0QiLorUEtSg=
=/9q9
-----END PGP SIGNATURE-----

--=-qZZ3QmaqpNyhw6inUG+C--
