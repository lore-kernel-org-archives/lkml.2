Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435Ab0G1V15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 17:27:57 -0400
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:56279 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab0G1V1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 17:27:55 -0400
Date: Wed, 28 Jul 2010 23:27:46 +0200
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] Regression 2.6.35-rc6: ALSA Intel HDA/Realtek:
 missing	Beep
Message-ID: <20100728212745.GA15394@darkside.kls.lan>
Mail-Followup-To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
	alsa-devel@alsa-project.org
References: <20100728144903.GA18170@darkside.kls.lan>
 <s5hzkxbtya9.wl%tiwai@suse.de>
 <s5htynjtwz2.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
In-Reply-To: <s5htynjtwz2.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 28, 2010 at 06:03:29PM +0200, Takashi Iwai wrote:
> I wrote:
> > Mario 'BitKoenig' Holbe wrote:
> > > My PC-Speaker Beep control worked in 2.6.34, but is gone in 2.6.35-rc=
6.
> > It's because now the driver checks the SSID your board sets up.
> > So, it's actually BIOS that clears it.

But the BIOS itself beeps through the sound-card at boot :/

> Or, does the following patch fix?  It's already in sound git tree,

Nope, unfortunately it doesn't. Still no Beep controls, no beep through
sound-card.

May I somehow provide any further data?
Or am I somehow able to tweak it? Is there a module parameter to set
this SSID bit? I mean, it did work before... :)


Thanks for you help & regards
   Mario
--=20
Why did the tachyon cross the road?
Because it was on the other side.

--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTFCg0RS+e2HeSPbpAQLLxAgAgx7fx3F9KtEs57rQnAysRCEVyxZKIvGd
XsInyUCKdvnUPJ9tlpQJPEPr2z9KW9mnKUNcNuqq1HuGvCD/13WTJ0htk9nHoMLx
cWTrNPdpaoQmYBj8sUHQoXiqqd/Zwvjfoz+zRGjdje9YVjNJxI8yFkHniSGLW4wF
SHACViIBMzeRcafpffMkDfjrtxPdFJkxsn6JT1rtvUzo0YZYe/v1BKhQpoxJbYgv
DJv0ZczLKPu3V8Phnfo3QThu2y8uJmu/v/zG8MgsZl+bZoG0vQG/ytymoO6yyoNV
VqE26Vc8UvuXAb41beiGP4add/pGbwznMjFauE2sIzYIhwhQuj8hcQ==
=PFrw
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--
