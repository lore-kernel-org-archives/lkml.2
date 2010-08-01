Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab0HANWc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 09:22:32 -0400
Received: from vps.mortis.eu ([79.99.135.181]:41724 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003Ab0HANWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 09:22:30 -0400
Date: Sun, 1 Aug 2010 15:22:26 +0200
From: Giel van Schijndel <me@mortis.eu>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Jean Delvare <khali@linux-fr.org>, Jonathan Cameron <jic23@cam.ac.uk>,
        Wim Van Sebroeck <wim@iguana.be>,
        Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] hwmon: f71882fg: Add support for the Fintek F71808E
Message-ID: <20100801132226.GE3711@salidar.me.mortis.eu>
References: <20100323141718.GA23172@salidar.me.mortis.eu>
 <1269385936-3440-1-git-send-email-me@mortis.eu>
 <4BA9CC64.5010807@redhat.com>
 <20100324092357.GE6368@salidar.me.mortis.eu>
 <4BA9EA0C.6070200@redhat.com>
 <20100731233121.GD3711@salidar.me.mortis.eu>
 <4C551058.20509@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q8BnQc91gJZX4vDc"
Content-Disposition: inline
In-Reply-To: <4C551058.20509@redhat.com>
OpenPGP: id=CEE5E742; url=http://gpg.mortis.eu/me.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q8BnQc91gJZX4vDc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 01, 2010 at 08:12:40 +0200, Hans de Goede wrote:
> On 08/01/2010 01:31 AM, Giel van Schijndel wrote:
>> On Wed, Mar 24, 2010 at 11:31:40 +0100, Hans de Goede wrote:
>>> On 03/24/2010 10:23, Giel van Schijndel wrote:
>>>> Ack. New and improved patch follows this line.
>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>> hwmon: f71882fg: Add support for the Fintek F71808E
>>>
>>> This new version looks good to me:
>>> Acked-by: Hans de Goede<hdegoede@redhat.com>
>>
>> Thanks.  Anyone else I need to poke in order to set this on track to
>> mainline?
>=20
> No,
>=20
> Jean should have picked this up, I guess it has fallen through the cracks.
>=20
> I think it is probably best if you resend this patch and the watchdog
> patches re-based against the latest upstream rc, then I'll re-review
> them and ack them and Jean can then put them into his tree.

Ack.  I'll resend them as replies to this mail.

--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel

--Q8BnQc91gJZX4vDc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkxVdRAACgkQZBYm/87l50JXQgCgjGFS6DWqWtnCOu9XCa2xJxAl
qI4AoKZVUWhecyIc3WjGvJNFtvIv8/uz
=Hyh7
-----END PGP SIGNATURE-----

--Q8BnQc91gJZX4vDc--
