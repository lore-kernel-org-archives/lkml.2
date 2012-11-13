Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab2KMLJf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 06:09:35 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:48461 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540Ab2KMLJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 06:09:34 -0500
Date: Tue, 13 Nov 2012 13:03:17 +0200
From: Felipe Balbi <balbi@ti.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: <balbi@ti.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH] usb: otg: twl4030: Change TWL4030_MODULE_* ids to
 TWL_MODULE_*
Message-ID: <20121113110317.GG10951@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1352799818-22363-1-git-send-email-peter.ujfalusi@ti.com>
 <20121113094722.GB10395@arwen.pp.htv.fi>
 <50A220BF.7020901@ti.com>
 <20121113103757.GE10951@arwen.pp.htv.fi>
 <50A22789.7070103@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yZnyZsPjQYjG7xG7"
Content-Disposition: inline
In-Reply-To: <50A22789.7070103@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--yZnyZsPjQYjG7xG7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Nov 13, 2012 at 11:57:13AM +0100, Peter Ujfalusi wrote:
> On 11/13/2012 11:37 AM, Felipe Balbi wrote:
> > ok good. Unfortunately I have already sent this merge window's pull
> > request to Greg so I'd have to delay this until v3.9. If that's ok with
> > you, I can take it through my tree.
>=20
> I hoped that this can go with 3.8 since in 3.9 I'm planning to remove all=
 of
> these TWL4030_MODULE_* defines which have TWL_MODULE_* counterpart.
> In this case I will introduce dummy defines to point to the correct place=
 for
> the USB in 3.9 and we can get rid of the rest of these in 3.10. Oh well. =
This
> is going to take a bit longer than I have anticipated.
> I can't think of any other subsytem this can go through...

Let's ask if Greg could take this patch directly without going through
me.

Greg, would it be ok to take this single patch without going through me?
Or would you prefer if I made another tag just for this single patch ?

cheers

--=20
balbi

--yZnyZsPjQYjG7xG7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQoij1AAoJEIaOsuA1yqREaMEP/iSyeRHi8eWBqzpirMYlRj79
T+ZA2R5wR+vMqlV8vfVkUdrvTPsFeNwoUXBw1mANzubZaMnCjIP9Qy0C21edyT2x
9EEIc9DrJcpCBhxdGZNxrJB5B44Sm5txUT8zGMytes0RhpKcbGcfIFPvrmAm9Lh5
pgP5x3unFkPwLiYIPoaskr+moU9xC01hiPO3OoHcpa7BVDToyeM6v0kO8XYU/zAL
F7JRYVuPpTfyRDtDD6bJDE+g8VA3XpTOv1vpYa8MvN2L4M+0p3rlkx2BsvAmMj0Q
BSa7rdsQqRiDcuTtgcnyim+LRhwFPeCD0VJHqwHhAWrpICy6RycQY4mDY7Fh+b8L
ShDfdy2QXiEtdME52vjSW0uEkpwyM2uIYpDWHn5CuhPNxXvWSiJLZk3WmxoE/mD0
5R67lOftqQz1ZXjg50XUnjhiSVsaNQKxHANKDMLxD+rjugoCsoSUoU9tK+lZX0/B
aij31SD49B1bBrtUc7FuJ6IsZG0tN1SVI5R9aZBPLZv5GMBKmF3YcCYo0qjlq5nE
XjnSEoaqinntHBWxjJbHVGfCOI6JiI5jZQql64zqXcnfSn5jkvM9Kf6MZcTZLpDx
wm+V3pGhbwEKe6fQ+dQlbQexpy9tmkilOpxVsZUQIeD8SOkdpeePO8gn6sIdxomn
420gG9lfFPlAWY0RdCPh
=D7kT
-----END PGP SIGNATURE-----

--yZnyZsPjQYjG7xG7--
