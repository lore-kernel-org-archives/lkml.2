Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab2JBCwG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 22:52:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34464 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529Ab2JBCwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 22:52:04 -0400
Date: Tue, 2 Oct 2012 12:52:00 +1000
From: NeilBrown <neilb@suse.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [ 094/127] md: make sure metadata is updated when spares are
 activated or removed.
Message-ID: <20121002125200.6bf40ac7@notabene.brown>
In-Reply-To: <20120928235745.GA11630@kroah.com>
References: <20120928203045.835238916@linuxfoundation.org>
	<20120928203056.912250649@linuxfoundation.org>
	<1348872664.6858.7.camel@deadeye.wl.decadent.org.uk>
	<20120928235745.GA11630@kroah.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/aoERBX9+4dMH98o7gfzXnfj"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/aoERBX9+4dMH98o7gfzXnfj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 28 Sep 2012 16:57:45 -0700 Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:

> On Sat, Sep 29, 2012 at 12:51:04AM +0200, Ben Hutchings wrote:
> > On Fri, 2012-09-28 at 13:34 -0700, Greg Kroah-Hartman wrote:
> > > 3.0-stable review patch.  If anyone has any objections, please let me=
 know.
> > >=20
> > > ------------------
> > >=20
> > > From: NeilBrown <neilb@suse.de>
> > >=20
> > > commit 6dafab6b1383e912cd252fa809570b484eb6e0dc upstream.
> > [...]
> > > This is suitable for -stable as out-of-data metadata could lead
> > > to data corruption.
> > > This is only relevant for 3.3 and later 9when 'replacement' as
> > > introduced.
> > [...]
> >=20
> > Assuming Neil hasn't changed his mind about this, it should therefore
> > not be applied to 3.0.
>=20
> Neil, is this true?
>=20
> greg k-h

Yes it is true - my bad.

I should have realised that when you pointed out that the backport wasn't
clean.
The patch won't hurt 3.0, but it isn't necessary at all, so best leave it o=
ut.

Thanks,
NeilBrown


--Sig_/aoERBX9+4dMH98o7gfzXnfj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGpW0Tnsnt1WYoG5AQKasA//a3FBfCso9t7vZPvadIgbz4ouOIQQtt1/
U9Q49IoBtci8YGs/1OQvdRFaV2qIL+48nzhJLioAWuArfVgfUx/EcQN8arXAHg/p
uIcS25iOYqO5LJsEMhDaxn691iJez+R+CiwGoovSDDXcTKMsEEsatk2Kjb6k3lb9
B43zpk7KdW2tMtoFUQ6OJsP5sJ4M+BQk2OD8BBkqSh3fh9WaJSZSVjN5N5umTTDw
gO8qbOiGQx2P6bs6dwz6nPqWmf7tXCXCEOVvlO3LBudSBIBKen5Nl6UieUwroCqD
b4O/2fiX/eboYbwp68haPJ2P+bjgayWCpWe4fBWRt/mEMGdMeiQT4gn2s4r9X2LP
aYMdRNG7kV+tSaXnGf6CkiYAcfvhAVgN586aYKq/2AnypC7HPdBK0RZiUspdrgG1
zfAkYUZ+zpNlb9qsXc0g6X/vN1msgDZcjpvZPqxjxowlQmmrmFAfOM0srdA/9Llo
nkLwecndtglxt0f8sXytprFHGPp4tYDMEd/Iev9FxJZvJfp9i4yOTB6KKR42krH/
jLnbBAhP2pT8toTXjAsiOTW2iIURxUwBPaK4Sd4lB/QYrP4ksPkxH7dyCsMItRkF
l5my/1lipt5HSICFR1/dU62o4RzxYTy3D88x5pOD5cuvcKYknoBN/rSkGc3zXRba
dR2l07zLxqQ=
=JdaT
-----END PGP SIGNATURE-----

--Sig_/aoERBX9+4dMH98o7gfzXnfj--
