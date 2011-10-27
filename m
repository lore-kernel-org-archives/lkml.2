Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751186Ab1J0Ee7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 00:34:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54849 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704Ab1J0Ee6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 00:34:58 -0400
Date: Thu, 27 Oct 2011 15:34:52 +1100
From: NeilBrown <neilb@suse.de>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        John Stultz <john.stultz@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, mark gross <markgross@thegnar.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: lsusd - The Linux SUSpend Daemon
Message-ID: <20111027153452.47b195f8@notabene.brown>
In-Reply-To: <alpine.LNX.2.01.1110261625370.15209@frira.zrqbmnf.qr>
References: <20111020111743.13b40558@notabene.brown>
	<Pine.LNX.4.44L0.1110201019500.2081-100000@iolanthe.rowland.org>
	<20111021162340.669742c0@notabene.brown>
	<alpine.LNX.2.01.1110261625370.15209@frira.zrqbmnf.qr>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/YVi9WlojxaooNKHSC=cg2p3"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/YVi9WlojxaooNKHSC=cg2p3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 26 Oct 2011 16:31:06 +0200 (CEST) Jan Engelhardt <jengelh@medozas.d=
e>
wrote:

>=20
> On Friday 2011-10-21 07:23, NeilBrown wrote:
> >At:
> >    git://neil.brown.name/lsusd
> >or
> >    http://neil.brown.name/git/lsusd
> >
> >you can find a bunch of proof-of-concept sample code that implements a
> >"Linux SUSpend Daemon" with client support library and test programs.
> >
> >  lsused:
> >      lsused (which needs a better name) listens on the socket
> >            /var/run/suspend/registration
>=20
> (lx)suspd and (lx)susp_eventd?
> NB: The short form of Linux is usually lx (not l). Also, yours would be
> the first I know to explicitly contain l/lx, which I think is rather
> redundant, given I'll never run a type of suspend other than the linux
> one anyway.

Good points - thanks.
I'll certainly consider them if/when I try to decide on a better name.

NeilBrown


--Sig_/YVi9WlojxaooNKHSC=cg2p3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTqjfbDnsnt1WYoG5AQJyPg/8DeWMZjIaVzvqLLWPwEKHDUuQiwHzraZ3
hpsfEkrBljIZ3a+g4Agp9J6nOS09LQyGNgHT7ZHdUMUBVx4OlabwS6ViqtDutNp6
oaym8RRxs6/M1fDiLUumc3sg3xJ/38IusuEPZOw8mfdebDFObTXcySFDlpBwN6J/
hPpOa/osntesEN1GcTuXM4ei6pzpRbpNxdCAokIXIlt4VnQhE7HXRpkFrx8t9TAg
y3bFYyKWAPnc1lKutKo6zzGQBqXCZL9nyHQrA7bVkNuYvzuymNj5NaNVXyfqVw5O
3+cF59oe/elv1OdKlBGp2GhL32OqfcXsh/UzMSjIXV99aZWrhgchsIoX6W8l9wJG
3PYKmUUMzu6rzbXxFTMGEQnZYvCvX2A/pD1nY1A8efi7LNctB3LW6Fya3rLnNpMP
TCrmykBQijPHtxNv8I7V7CuyJSN3/WgFClSSVV/wkVpFXKbyuc/w+SFostg1grCm
VkhofIuRUpvAcPuzhS/IJUMVHefgLh8+fxDKGn/RiPzrbcqHK8/rCedst4Mao753
HmN3vVNz0CssXZFUNx0BrPOHndnrxNFqSt0NXbaAiFQte6CqJ/GcrTEUMkp7sY0h
Gx6K+3AnyUuG1VPwIucUAEYZxL9eEGHHZsBj3T8qQBNuTp83Gm+ClNDUskOPWyYI
dsNyd+NerEU=
=iZXH
-----END PGP SIGNATURE-----

--Sig_/YVi9WlojxaooNKHSC=cg2p3--
