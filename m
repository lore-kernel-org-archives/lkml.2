Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab1GZPXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 11:23:22 -0400
Received: from home.keithp.com ([63.227.221.253]:54909 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776Ab1GZPXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 11:23:17 -0400
From: Keith Packard <keithp@keithp.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Hold struct_mutex during hotplug processing
In-Reply-To: <CAKMK7uHO1jqUNrnqC9sd=JJ9Vr=hmAjnJ06eDYxfeyTTFAMK1w@mail.gmail.com>
References: <1311613829-4990-1-git-send-email-keithp@keithp.com> <CAKMK7uHO1jqUNrnqC9sd=JJ9Vr=hmAjnJ06eDYxfeyTTFAMK1w@mail.gmail.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Tue, 26 Jul 2011 08:23:13 -0700
Message-ID: <yunsjpt2hi6.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Tue, 26 Jul 2011 09:24:39 +0200, Daniel Vetter <daniel@ffwll.ch> wrote:
> Two things I've noticed:

> - Why not dev->mode_config.mutex?

You're right, of course. I noticed that just after posting that version
and updated it; the updated version is on my drm-intel-fixes branch
already (having been reviewed by Jesse).

> - And a nitpick: Why the dev_priv->dev indirection, when dev is
> already lying around?

All nicely cleaned up by using &mode_config->mutex instead :-)

Thanks for looking it over!

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOLtvhQp8BWwlsTdMRAl0SAKCx2GmjQv2rWUfA+fUgSnSB9jDNSwCguixZ
srlD59fbqgd5+HFeO641rIE=
=7qXm
-----END PGP SIGNATURE-----
--=-=-=--
