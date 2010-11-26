Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab0KZPiA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 10:38:00 -0500
Received: from wrar.name ([109.74.195.39]:50732 "EHLO haley.wrar.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518Ab0KZPh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 10:37:59 -0500
Date: Fri, 26 Nov 2010 20:37:51 +0500
From: Andrey Rahmatullin <wrar@wrar.name>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [BISECTED] 2.6.36 regression for ALC892
Message-ID: <20101126153751.GA4185@belkar.wrar.name>
References: <20101125211803.GA4236@belkar.wrar.name>
 <s5h7hg0sk04.wl%tiwai@suse.de>
 <20101126091211.GA3505@belkar.wrar.name>
 <s5heia8qvry.wl%tiwai@suse.de>
 <20101126142737.GA3522@belkar.wrar.name>
 <s5h62vkrw6c.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
In-Reply-To: <s5h62vkrw6c.wl%tiwai@suse.de>
X-Operating-System: Debian Sid
X-Jabber-Id: wrar@altlinux.org
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 26, 2010 at 03:34:03PM +0100, Takashi Iwai wrote:
> > > Try the very latest alsa-driver snapshot or sound-2.6 git tree.
> > > You should have an individual "Headphone" volume as well.
> > Yes, that makes difference: I was able to use the headphones after rais=
ing
> > that new volume.
> OK, then this should be the patch below.  Care to apply it to 2.6.36
> and check whether it gives the same result?
I've applied it to 2.6.36 and got a "Headphone" volume, and it works.

--=20
WBR, wRAR

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBCAAGBQJM79RJAAoJEOih81koZvPBnrgIAJ8p5bCPqfXgX98xlx38Jwtg
Regfc+EYxLZEUC4zlc8xkZq1s03OXlxcc3nwqA3j6F0tCAppt/E+Rxz0phpKp+6X
WHNxD39gHeXrIZ38Ks13XVA/z6lrRD6NDKNMeLobZhpBgleHHwwl2Kua5VIOx9iY
PchVI6p2ra4WESsiu/pGSnf2eDNLFP1iVC2Z7U2DCOnwCaYRDoGQsuGcdopCIjl8
NNpODwYR55z+OWjZZbuv108BZNyXt9DedoFLmSz++vK7qXV1JMBL9bE6s9DhYBUx
hlLr7q8w3AhyeJBC0eGvy1r5AW5iSY79xtftQtt4r1tOGA60hTTz33+sUPdqnpw=
=pPtr
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
