Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272Ab0GaVgn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 17:36:43 -0400
Received: from vps.mortis.eu ([79.99.135.181]:40343 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757164Ab0GaVgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 17:36:41 -0400
Date: Sat, 31 Jul 2010 23:36:39 +0200
From: Giel van Schijndel <me@mortis.eu>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Hans de Goede <hdegoede@redhat.com>, Jean Delvare <khali@linux-fr.org>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] [RFC] watchdog: f71808e_wdt: new watchdog driver
 for Fintek F71808E
Message-ID: <20100731213639.GC3711@salidar.me.mortis.eu>
References: <20100325125005.6d58cfaf@lxorguk.ukuu.org.uk>
 <1269523063-30346-1-git-send-email-me@mortis.eu>
 <1269523063-30346-2-git-send-email-me@mortis.eu>
 <1269523063-30346-3-git-send-email-me@mortis.eu>
 <20100330090639.GA8822@salidar.me.mortis.eu>
 <20100520075229.GO4008@infomag.iguana.be>
 <20100525210824.GA7815@salidar.me.mortis.eu>
 <20100526073843.GJ3972@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bu8it7iiRSEf40bY"
Content-Disposition: inline
In-Reply-To: <20100526073843.GJ3972@infomag.iguana.be>
OpenPGP: id=CEE5E742; url=http://gpg.mortis.eu/me.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Bu8it7iiRSEf40bY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 26, 2010 at 09:38:43 +0200, Wim Van Sebroeck wrote:
>>> Driver looks OK to me. Can't apply it before the I/O resource
>>> sharing is in place.  How do you want to proceed?
>>=20
>> I would think applying it to watchdog-next to apply it for the next
>> kernel release (similar to Jean Delvare's linux-next).
>=20
> Will add it after 2.6.35-rc1 is out then.

Sending a reminder, as 2.6.35-rc1 has been tagged for a while now.

--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel

--Bu8it7iiRSEf40bY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkxUl2cACgkQZBYm/87l50IiFQCfSzB/tUOZlrNzjK+OoiV9Q/y3
MWoAoJAXJxe225uDT07PAI6+UHzLUN0Q
=oB5o
-----END PGP SIGNATURE-----

--Bu8it7iiRSEf40bY--
