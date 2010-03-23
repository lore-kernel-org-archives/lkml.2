Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab0CWX1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 19:27:16 -0400
Received: from vps.mortis.eu ([79.99.135.181]:34986 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726Ab0CWX1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 19:27:15 -0400
Date: Wed, 24 Mar 2010 00:26:57 +0100
From: Giel van Schijndel <me@mortis.eu>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Jean Delvare <khali@linux-fr.org>, Jonathan Cameron <jic23@cam.ac.uk>,
       Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] [RFC] hwmon: f71882fg: Add watchdog API for
 F71808E and F71889
Message-ID: <20100323232656.GA3605@salidar.me.mortis.eu>
References: <20100323141718.GA23172@salidar.me.mortis.eu>
 <1269385936-3440-1-git-send-email-me@mortis.eu>
 <1269385936-3440-2-git-send-email-me@mortis.eu>
 <1269385936-3440-3-git-send-email-me@mortis.eu>
 <1269385936-3440-4-git-send-email-me@mortis.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <1269385936-3440-4-git-send-email-me@mortis.eu>
OpenPGP: id=CEE5E742; url=http://gpg.mortis.eu/me.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 24, 2010 at 12:12:16AM +0100, Giel van Schijndel wrote:
> Implement the watchdog API for the Fintek F71808E.

Looking at the F71889FG datasheet I think implementing watchdog support
for that chip can be accomplished rather easily.

I think it's as simple as adding the pin initialisation (multi function
select registers 0x2a and 0x2b) sequence to the switch statement in
watchdog_start(). That being said; I don't have physical access to that
chip myself, thus I couldn't actually test it (unlike the F71808E, for
which I've already tested these patches).

--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkupTkAACgkQZBYm/87l50IExwCfWZoFKetUqxU5AC36DvRt2EqW
LXEAoLPp/L2JgoWNGQdwGyK5c61F3ZEW
=03zV
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
