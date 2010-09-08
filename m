Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791Ab0IHG16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 02:27:58 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:58274 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab0IHG1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 02:27:54 -0400
X-Greylist: delayed 403 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Sep 2010 02:27:54 EDT
Date: Wed, 8 Sep 2010 08:21:42 +0200
From: Nico Schottelius <nico-nospam@schottelius.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nico Schottelius <nico-linux-20100709@schottelius.org>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.36-rc3 suspend issue (was: 2.6.35-rc4 / X201 issues)
Message-ID: <20100908062141.GA2813@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-nospam@schottelius.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Nico Schottelius <nico-linux-20100709@schottelius.org>,
	Jeff Chua <jeff.chua.linux@gmail.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20100709170432.GA7691@schottelius.org>
 <201009072348.41344.rjw@sisk.pl>
 <20100907225004.GA2805@schottelius.org>
 <201009080128.52849.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <201009080128.52849.rjw@sisk.pl>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: kr (Linux 2.6.34 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Rafael J. Wysocki [Wed, Sep 08, 2010 at 01:28:52AM +0200]:
> On Wednesday, September 08, 2010, Nico Schottelius wrote:
> > Rafael J. Wysocki [Tue, Sep 07, 2010 at 11:48:41PM +0200]:
> > > On Tuesday, September 07, 2010, Jeff Chua wrote:
> > > >=20
> > > > Cool. Thanks for the short-cut! At least now, I can resume, but got=
 a
> > > > lot of BUGS showing up upon resume after applying the patch.
> > >=20
> > > This also was reported IIRC, but there's no resolution so far.  It's a
> > > different issue.
> >=20
> > Can somebody ping me, as soon as a git pull on linux-2.6
> > should be as "stable" (or more stable) than 2.6.34?
>=20
> No one can say when that happens for your machine.

True. I was more wondering, when the bisected issue will
be fixed, as this may give my machine some more chances
to work on Linux.

Btw, do you also recognize a different pattern on LKML?

In the past it was mostly "$device not support" && wait
for third party patch to go into upstream, whereas today
it "should be supported", but crashes/freezes sometimes.

Cheers,

Nico

--=20
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkyHK3UACgkQ19zI5DGHffAINQCgrgnOJn8jKJ9ad3qtNealzlfe
lEgAoIXcyZMWzNr48FCV6uw4arPKVCv8
=IKSt
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
