Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab0JBXAK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 19:00:10 -0400
Received: from vps.mortis.eu ([79.99.135.181]:41871 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798Ab0JBXAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 19:00:08 -0400
Date: Sun, 3 Oct 2010 00:59:58 +0200
From: Giel van Schijndel <me@mortis.eu>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Laurens Leemans <laurens@signips.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Andrew Morton <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, 597820@bugs.debian.org
Subject: Re: [PATCH 1/2] hwmon: f71882fg: use a muxed resource lock for the
 Super I/O port
Message-ID: <20101002225958.GA18605@salidar.me.mortis.eu>
References: <20100801132226.GE3711@salidar.me.mortis.eu>
 <1280669455-31283-1-git-send-email-me@mortis.eu>
 <4C59514A.7090401@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
In-Reply-To: <4C59514A.7090401@redhat.com>
OpenPGP: id=CEE5E742; url=http://gpg.mortis.eu/me.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 04, 2010 at 01:38:50PM +0200, Hans de Goede wrote:
> Ack!
>=20
> Acked-by: Hans de Goede <hdegoede@redhat.com>
>=20
> On 08/01/2010 03:30 PM, Giel van Schijndel wrote:
>> Sleep while acquiring a resource lock on the Super I/O port. This should
>> prevent collisions from causing the hardware probe to fail with -EBUSY.
>>=20
>> Signed-off-by: Giel van Schijndel<me@mortis.eu>

Would anyone please apply this patch?  It's been sitting for quite some
time now collecting dust (none of that fictional bit-rot thus far
however).  If this patch needs to be resubmitted or requires me to poke
a specific individual please let me know (and what individual to poke).

FYI the Message-ID of that patch is:
<1280669455-31283-1-git-send-email-me@mortis.eu>

PS I've added Guenter Roeck and Andrew Morton to the CC list because
   between now and the original submission date they got appended to
   scripts/get_maintainer.pl's output.

--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel
--
"It would seem that perfection is attained not when no more can be
 added, but when no more can be removed."
  -- Antoine de Saint Exup=C3=A9ry

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkynuWsACgkQZBYm/87l50LG4ACaA+M3Mw18quNSpk88jmT3kk+U
zCoAoJsIgV+UNmHv/ED/wwQtWEJKVAHc
=DLEW
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
