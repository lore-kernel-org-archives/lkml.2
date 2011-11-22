Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab1KVBkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 20:40:18 -0500
Received: from home.keithp.com ([63.227.221.253]:44179 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924Ab1KVBkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 20:40:16 -0500
From: Keith Packard <keithp@keithp.com>
To: Marcos Paulo de Souza <marcos.mage@gmail.com>
Cc: linux-kernel@vger.kernel.org, airlied@linux.ie,
        dri-devel@lists.freedesktop.org
Subject: Re: max PWM is zero
In-Reply-To: <alpine.LNX.2.00.1111212248140.2070@darkstar.example.net>
References: <alpine.LNX.2.00.1111151301410.2693@darkstar.example.net> <alpine.LNX.2.00.1111191124350.5248@darkstar.example.net> <864ny0kku8.fsf@sumi.keithp.com> <alpine.LNX.2.00.1111212248140.2070@darkstar.example.net>
User-Agent: Notmuch/0.9 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Mon, 21 Nov 2011 17:40:11 -0800
Message-ID: <86ipmdgcjo.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 21 Nov 2011 22:48:21 +0000 (Local time zone must be set--see zic ma=
nual page), Marcos Paulo de Souza <marcos.mage@gmail.com> wrote:

> My max_brightness is 1, and my brightness is 0.

Right, we've prevented the internal backlight driver from exposing a max
value of 0 as that's just confusing.

> But, my acpi_video0 have a=20
> max_brightness value =3D 9...

Right, sounds like your device is just using some other backlight
controller, which is perfectly reasonable.

> So, what can I do to silence this warning...? Change the driver of=20
> backlight?

If your backlight keys work correctly, then things are fine and perhaps
we should just remove the warning from the driver, or disable the
internal driver when we discover this situation.

This is the first time I've heard of this warning appearing...

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTsr9ezYtFsjWk68qAQh6lxAAlZUCzuixhvggMsRXWrFU15TyaavhA1rZ
f2WjF0zCGj3wSc/X3/dMXxn2LQv1WmSM6u49GDgccyy6yZLwzlr90iLRLV2t3eho
BaOO214Sqe3uQQJXniEym7hPE0CatLeDXiZQw37DkxY7PgLX+oUCFhKPVw1fFNwa
Jw1Pa0rKSb1cg/kHB2J90saKTE85Piwv9eEDLUhDeJzI5LB3lxVoXVtmxUbqa+3n
vGgFUfdp9PNXzd9x+boHAZKMSSa1pXH/KioKpiSCftNyCd6EtiDymjs3Gy98zc/g
SlbXzgTq+W7h86r8UEdUUEp4ocFnRaFEAnqdedy4aG5Bj6OSisClhNdI5148Bwi1
09ZTCfqgCl7KnncULDZ1bCRt1+8dpItLXrECR7qjIFQThYpMaL7kGjTseQPfGB8i
wxOiKImpaP1UW0muODDWf5I9Jo4xfctzPAZ4zRVuhrJETMDos2BoLPOLmkR5FgNF
21hTM7qXm+j0FmRa5cce+EVzE6yt8nDP+YvJZSpYuWLclML75+5zAcBcxVHRXZYU
rciL1rcK2gzLe7sRWJLFCj6MW4BUCRDyJj2u5IsHHLBW5lKwTw6tqHQpS5cO8Upp
8N5Y8qQnjwDtFBR91H1rTfySWZr7DqRNrnETkVlpb7Ajm90gDxjbiheV3Ta0moxP
lU49oS66BIw=
=fyBK
-----END PGP SIGNATURE-----
--=-=-=--
