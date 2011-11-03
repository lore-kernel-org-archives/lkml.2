Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab1KCWdI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 18:33:08 -0400
Received: from home.keithp.com ([63.227.221.253]:33873 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335Ab1KCWdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 18:33:07 -0400
From: Keith Packard <keithp@keithp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 6/7] drm/i915: Try harder during dp pattern 1 link training
In-Reply-To: <20111103130329.56505cd0@jbarnes-desktop>
References: <1320214830-12696-1-git-send-email-keithp@keithp.com> <1320214830-12696-7-git-send-email-keithp@keithp.com> <20111103130329.56505cd0@jbarnes-desktop>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Thu, 03 Nov 2011 15:32:46 -0700
Message-ID: <yunfwi4rg4x.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Thu, 3 Nov 2011 13:03:29 -0700, Jesse Barnes <jbarnes@virtuousgeek.org> =
wrote:

> Sneaky putting this bug fix into this patch. :)

Ickle already saw that, and I've split it out into a separate patch. I
don't think this is necessary, but it seems like a sensible change.

> Don't you love the training state machine?  I think this looks ok, and
> the DP compliance test should catch any grievous errors, so aside from
> the bug fix hunk which should be split out:
>=20
> Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>

And that chunk has already been split out :-)

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTrMWjjYtFsjWk68qAQhf1g/+OikgXEelnDPNNWIUpKap+Lo+eSrU7iLb
6ZHScAGPvw8WOJn1ATU4HovsjbNGjrr5/b/ulP/hKhZBJJPAEv/z0MmRww/XyP5V
lBNTA+jCjrO+c//6J6MsM0GIlVhPZMaXRaCZ27N5ldGLcBFjH7JZIb3su7Kgs8xM
ouDs0G3fsKoaFmPWnB4LSOZ4XTSj1tfmkBZKVJ46XmMbT7rJkQNXWS8FN53WjrnQ
iVqH8rqvvyFZbRt9PMJsXW6Bwq2nAuMKSmResAxMXJ/DRB7TzuSESBv5iLOpfMbE
XfbwdJaI9gl0ppkdEHXSIuwRbOw2zoE2xOdwp8iB2Wf6XZa18uta+3IZtfZaPBdV
BtLH3PV8szRtIxBm7IThXVyx7AYB7g4VtFNbnZnkvvi6qTVk01eeWL3jFH8YZpFO
uHrVaxuUuYahmcBPC7C0WV2029xJ0Z1rIrYtsWaShb0i4GXQ5R0tcY4Dsb1ceWLa
osNdpy63htkPqCWsEYZYlz4RoS6xjkqwod0318EG7b8kzue5ZaA/jjNmUwKUizRE
rlrvZPPylV5y7/cWjrlsKpnI0HCYQmVV2ALlYBezCtOcccF8MJ+vhaWeFYdu4kcI
KZr6F8BbSIpjXUoPhGHqsB0zwPZODQYnf23qxwJgLo9Ag0k1c8eym5xGCIEyz3tg
9iHhbl8csMo=
=dQE1
-----END PGP SIGNATURE-----
--=-=-=--
