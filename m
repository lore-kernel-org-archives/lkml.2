Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934320Ab0EYVId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 17:08:33 -0400
Received: from vps.mortis.eu ([79.99.135.181]:55590 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934296Ab0EYVIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 17:08:30 -0400
Date: Tue, 25 May 2010 23:08:25 +0200
From: Giel van Schijndel <me@mortis.eu>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Hans de Goede <hdegoede@redhat.com>, Jean Delvare <khali@linux-fr.org>,
       Jonathan Cameron <jic23@cam.ac.uk>,
       Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] [RFC] watchdog: f71808e_wdt: new watchdog driver
 for Fintek F71808E
Message-ID: <20100525210824.GA7815@salidar.me.mortis.eu>
References: <20100325125005.6d58cfaf@lxorguk.ukuu.org.uk>
 <1269523063-30346-1-git-send-email-me@mortis.eu>
 <1269523063-30346-2-git-send-email-me@mortis.eu>
 <1269523063-30346-3-git-send-email-me@mortis.eu>
 <20100330090639.GA8822@salidar.me.mortis.eu>
 <20100520075229.GO4008@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
In-Reply-To: <20100520075229.GO4008@infomag.iguana.be>
OpenPGP: id=CEE5E742; url=http://gpg.mortis.eu/me.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 20, 2010 at 09:52:29AM +0200, Wim Van Sebroeck wrote:
>> On Thu, Mar 25, 2010 at 02:17:43PM +0100, Giel van Schijndel wrote:
>> > Add a new watchdog driver for the Fintek F71808E Super I/O chip.
>>=20
>> Updated patch:
>>  * fixes a bug where detection wouldn't function properly if a
>>    non-Fintek device was found (or a wrong Super I/O port chosen).
>>  * Add support for the F71882FG
>>=20
>> NOTE: This patch depends on patch [1] (applied in [2]) and patch [3].
>>=20
>> [1] https://patchwork.kernel.org/patch/89023/
>> [2] http://git.kernel.org/?p=3Dlinux/kernel/git/jbarnes/pci-2.6.git;a=3D=
commit;h=3D316607809324cc796c0809630b6ae8a768404296
>> [3] https://patchwork.kernel.org/patch/88235/
>=20
> Driver looks OK to me. Can't apply it before the I/O resource sharing
> is in place.  How do you want to proceed?

I would think applying it to watchdog-next to apply it for the next
kernel release (similar to Jean Delvare's linux-next).

--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv8PEcACgkQZBYm/87l50JZxgCgs3jRI+jEtrTp2iyiGBBC8fGg
35kAn3zwuHiwY6b4Y36KX72TCyv+NWqM
=OtPH
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
