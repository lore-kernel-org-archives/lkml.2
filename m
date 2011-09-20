Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab1ITPza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 11:55:30 -0400
Received: from home.keithp.com ([63.227.221.253]:40550 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab1ITPz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 11:55:28 -0400
From: Keith Packard <keithp@keithp.com>
To: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-dev@lists.linaro.org, "Clark\, Rob" <rob@ti.com>,
        Archit Taneja <archit@ti.com>
Subject: Re: Proposal for a low-level Linux display framework
In-Reply-To: <CAMeQTsbP-_ut7BA3YQ+qgtqfM1tzM4qn3jxHT8B8_0hdPbP3Jg@mail.gmail.com>
References: <1316088425.11294.78.camel@lappyti> <yunboul7sx7.fsf@aiko.keithp.com> <1316100594.23214.65.camel@deskari> <yun8vpp7qk7.fsf@aiko.keithp.com> <1316107275.23214.99.camel@deskari> <yunfwjxwbjq.fsf@aiko.keithp.com> <20110916175326.54567b14@lxorguk.ukuu.org.uk> <1316414014.1978.12.camel@deskari> <yunfwjtauqg.fsf@aiko.keithp.com> <1316417361.1978.48.camel@deskari> <CAMeQTsbP-_ut7BA3YQ+qgtqfM1tzM4qn3jxHT8B8_0hdPbP3Jg@mail.gmail.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Tue, 20 Sep 2011 08:55:24 -0700
Message-ID: <yunpqivfbtf.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Tue, 20 Sep 2011 10:29:23 +0200, Patrik Jakobsson <patrik.r.jakobsson@gm=
ail.com> wrote:

> It would be nice to have a model that fits both DSI and SDVO, and the opt=
ion
> to configure some of it from userspace.

> I thought the purpose of drm_encoder was to abstract hardware like this?

SDVO is entirely hidden by the drm_encoder interface; some of the
controls (like TV encoder parameters) are exposed through DRM
properties, others are used in the basic configuration of the device.

I'm not sure we need a new abstraction that subsumes both DSI and SDVO,
but we may need a DSI library that can be used by both DRM and other
parts of the kernel.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOeLdtQp8BWwlsTdMRAkXyAKDcVSuLupU7KoUyWcBvUrGKFdT/fACeI0QG
yEzNPzQT4nq88Ct9hSYdpUs=
=gsOM
-----END PGP SIGNATURE-----
--=-=-=--
