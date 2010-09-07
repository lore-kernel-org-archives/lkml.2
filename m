Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab0IGJkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 05:40:53 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54445 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756181Ab0IGJkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 05:40:46 -0400
Date: Tue, 7 Sep 2010 11:40:41 +0200
From: Frank Becker <fb@alien8.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jens Taprogge <jens.taprogge@taprogge.org>, linux-kernel@vger.kernel.org,
        alsa-devel@vger.kernel.org, bp@alien8.de
Subject: Re: commit 7b2bfdb broke sound card detection on my Lenovo T400s
Message-ID: <20100907094041.GA2815@alien8.de>
References: <20100906170421.GA2957@alien8.de>
 <20100906224548.GA27279@taprogge.org>
 <s5hlj7ew0ph.wl%tiwai@suse.de>
 <20100907090220.GA3204@alien8.de>
 <s5h7hixap1c.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <s5h7hixap1c.wl%tiwai@suse.de>
Organisation: private
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Takashi Iwai [2010-09-07, 11:20 +0200]:
> At Tue, 7 Sep 2010 11:02:20 +0200,
> Frank Becker wrote:
> >=20
> > Takashi Iwai [2010-09-07, 08:17 +0200]:
> > > At Tue, 7 Sep 2010 00:45:48 +0200,
> > > Jens Taprogge wrote:
> > > >=20
> > > > On Mon, Sep 06, 2010 at 07:04:21PM +0200, Frank Becker wrote:

Hi,

[...]
> machine.  Anyway, I don't see why Jens' patch breaks your machine.
> The PCI SSID (not codec SSID) of his machine is 17aa:215e while yours
> is 17aa:20f2.  The breakage can be a coincidence.
>=20
> Could you check whether model=3Dthinkpad works better?
Works as model=3Dideapad IOW, yes that works perfectly well.

> If yes, we can simply add the new entry for your device.
Great. Thank you.

Bye,

    Frank

--=20
Frank Becker <fb@alien8.de> (jabber|mail) | http://twitter.com/41i3n8
GnuPG: 0xADC29ECD | F01B 5E9C 1D09 981B 5B40 50D3 C80F 7459 ADC2 9ECD
SILC-Net: a8 | Home: http://www.alien8.de | <<</>> http://www.c3d2.de
"> Freedom is just chaos, with better lighting. <"  Alan Dean  Foster

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEUEARECAAYFAkyGCJYACgkQyA90Wa3Cns3nOQCeOiksdBiYlO2kUYZ2bXcOiU1c
4U4AmLAgQbtUl968OArVy9j8wQaowUc=
=aywi
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
