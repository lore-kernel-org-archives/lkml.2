Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab0IGJC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 05:02:29 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52119 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755416Ab0IGJCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 05:02:23 -0400
Date: Tue, 7 Sep 2010 11:02:20 +0200
From: Frank Becker <fb@alien8.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jens Taprogge <jens.taprogge@taprogge.org>, linux-kernel@vger.kernel.org,
        alsa-devel@vger.kernel.org, bp@alien8.de
Subject: Re: commit 7b2bfdb broke sound card detection on my Lenovo T400s
Message-ID: <20100907090220.GA3204@alien8.de>
References: <20100906170421.GA2957@alien8.de>
 <20100906224548.GA27279@taprogge.org>
 <s5hlj7ew0ph.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
In-Reply-To: <s5hlj7ew0ph.wl%tiwai@suse.de>
Organisation: private
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Takashi Iwai [2010-09-07, 08:17 +0200]:
> At Tue, 7 Sep 2010 00:45:48 +0200,
> Jens Taprogge wrote:
> >=20
> > On Mon, Sep 06, 2010 at 07:04:21PM +0200, Frank Becker wrote:

Hi,

> Also, it'd be helpful if alsa-info.sh output is given.
> Jens, Frank, could you guys run it with --no-upload option and attach
> the output for comparison?
Sorry, I wasn't aware of this fine tool.

Hope, it's OK to upload it as well. Don't want to fill up everyones mboxes
again

2.6.32: http://www.alsa-project.org/db/?f=3Df985e74bdda393213a29c6243012a7a=
8ea1dfe1f
2.6.35-broken: http://www.alsa-project.org/db/?f=3D827e4ef1a0d6c726a09fc580=
1853aa2ba58225ed
2.6.35-ideapad: http://www.alsa-project.org/db/?f=3D01e6a47003948f33aeb8ff1=
32b64d4bc4ecc73b8

Bye,

Frank

--=20
Frank Becker <fb@alien8.de> (jabber|mail) | http://twitter.com/41i3n8
GnuPG: 0xADC29ECD | F01B 5E9C 1D09 981B 5B40 50D3 C80F 7459 ADC2 9ECD
SILC-Net: a8 | Home: http://www.alien8.de | <<</>> http://www.c3d2.de
"> Freedom is just chaos, with better lighting. <"  Alan Dean  Foster

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkyF/5cACgkQyA90Wa3Cns2svACfTQXBbA2aJKULQ+m3/PkctAp0
hssAnj1XuVCDfZjDRO/nWaHhbrXmqqMS
=uCBd
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
