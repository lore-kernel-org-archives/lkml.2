Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828Ab1KRNgs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 08:36:48 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:39636 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755940Ab1KRNgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 08:36:46 -0500
Date: Fri, 18 Nov 2011 15:36:43 +0200
From: Felipe Balbi <balbi@ti.com>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, anaghi@mail.gnudd.com,
        balbi@ti.com, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH V2 0/2] debugfs: a tool to print 32-bit registers
Message-ID: <20111118133641.GE9999@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20111118002049.GA24806@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ffoCPvUAPMgSXi6H"
Content-Disposition: inline
In-Reply-To: <20111118002049.GA24806@mail.gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ffoCPvUAPMgSXi6H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 18, 2011 at 01:20:49AM +0100, Alessandro Rubini wrote:
> This is V2 of what I posted a few days ago. I also updates
> the file in Documentation.  I Cc:d people who gave feedback.
>=20
> Patch 2 uses the new tool for an existing file I didn't initially
> notice (I had a victim file, but it's seriously failing compilation).
> Code removal there is almost zero because Felipe Balbi already did
> stuff in the way I do.
>=20
> Mark Brown suggested to look at drivers/base/regmap, and actually this
> may be duplicating what is already being worked on in a more general
> way. My code base is earlier than regmap so I didn't notice.
> Unfortunately I have no resources left to study regmap as it
> deserves.
>=20
> Mark, if you say this is not useful at this point, I'm fine with it; I
> may return with some regbase-aware code when time permits if it's not
> already there.

-ENOPATCH ?? I didn't receive any replies to this mail with the patch.
Is my mailer screwed up ?

--=20
balbi

--ffoCPvUAPMgSXi6H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOxl9pAAoJEIaOsuA1yqREPOUP/R1304CjfUYWvO4Xraai1eEf
H/m9MqRyEw6vEeDuRER4TG9oXPfXuZBtEjUxunWlC3EQERMjh51Gu7hRRIFzyEby
0i6EefQoizPXCM+tfKRHb3bUISWe37dgAZCooJtM+nXPfbOSrrV20W2Q/8aXJW7+
KWy/olzkFbCOG/y3rWAcB9zd6xEsaXDno2xpYVkrKr5txZz4knHea+Glxw+eZYnN
tbD8tSn38RIxHa15lvFPVJ7PR4g41Ao/M6TKNLrN2f5QzfbdkdV1WvmwRlO016cK
Ruxov6nQIJ2x7SVYS9f9/ZXmtYksGGXIyMxi07Hy2qgGmDHzg5Pnaacz1vRNRmZX
U/Kf0JxWC4qpPQoc6PAnwmjEDkKZCGAdZ9o7v4+vsewL/BsC9nVgeZ0jDkXKlnv+
yxMCcTMoxq2SKzBa9nxjQXAnCF7vkX7NkXKQ2N4CVjh47/t60d5lqY1HE9us2YO+
16V42OWtIo5WyiHvFyPfeV+GQkUPDVVdfYs8BmjBkYwBZ+4zI+PyR5ioroqqfqGn
xSumbCOgyczQW+1eXA5CVRioVS2Fl3nYFJUxDaQkyeOBOLLPr1yNuub3PUhhpuPW
ma72RHFmT4+rsRwS7/y20ME6SEnyWtQNKM4TjwQ1FoJh7GY5J79tP1Ugq+b5tLp3
DyAgU6zfq+Q6fzx5zPTb
=DD26
-----END PGP SIGNATURE-----

--ffoCPvUAPMgSXi6H--
