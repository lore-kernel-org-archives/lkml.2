Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab0LHRaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 12:30:08 -0500
Received: from home.keithp.com ([63.227.221.253]:42326 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755130Ab0LHRaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 12:30:07 -0500
From: Keith Packard <keithp@keithp.com>
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Florian Mickler <florian@mickler.org>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 2/2] drm: record monitor status in output_poll_execute
In-Reply-To: <0d30dc$kddq6q@orsmga001.jf.intel.com>
References: <1290797159-3977-1-git-send-email-keithp@keithp.com> <1290797159-3977-2-git-send-email-keithp@keithp.com> <20101205132743.3b3458ab@schatten.dmk.lab> <yunpqtgexml.fsf@aiko.keithp.com> <20101208173424.76ec4041@schatten.dmk.lab> <0d30dc$kddq6q@orsmga001.jf.intel.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i486-pc-linux-gnu)
Date: Wed, 08 Dec 2010 09:30:00 -0800
Message-ID: <yun1v5sb2av.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 08 Dec 2010 17:08:04 +0000, Chris Wilson <chris@chris-wilson.co.uk>=
 wrote:
> On Wed, 8 Dec 2010 17:34:24 +0100, Florian Mickler <florian@mickler.org> =
wrote:
> > Does that mean that the kernel regression will not be
> > fixed/worked-around for old userspace?=20
>=20
> I think there is some confusion in that I believe there is more than one
> backlight bug at play here.

The kernel and user space fixes addressed the same  technical problem
(failing to note that mode setting turned on the devices), but the
symptoms that this caused were different; in kernel mode, the result
would be that monitors would be left turned on when user space asked
that they be turned off (and left pointing at random memory too, which
was amusing). I think that the backlight issue was caused by the
user-space bug though.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFM/8CYQp8BWwlsTdMRAv0FAJ9bOxGmAeiWP2cW4ZGAY+fVwMoF1wCg6Hpf
VU77yvGJmYAAjrWl4wcsOAc=
=QLJL
-----END PGP SIGNATURE-----
--=-=-=--
