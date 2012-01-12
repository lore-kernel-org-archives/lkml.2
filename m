Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab2ALRds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 12:33:48 -0500
Received: from home.keithp.com ([63.227.221.253]:53936 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013Ab2ALRdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 12:33:45 -0500
From: Keith Packard <keithp@keithp.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Michal Marek <mmarek@suse.com>,
        "intel-gfx\@lists.freedesktop..." <intel-gfx@lists.freedesktop.org>,
        Robert Lemaire <rlemaire@suse.com>
Subject: Re: [PATCH] drm/i915: set AUD_CONFIG N_value_index for DisplayPort
In-Reply-To: <20120110054519.GA27257@localhost>
References: <20120109131717.GA4713@localhost> <86y5tgx02g.fsf@sumi.keithp.com> <20120110054519.GA27257@localhost>
User-Agent: Notmuch/0.10.2 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Thu, 12 Jan 2012 09:33:34 -0800
Message-ID: <86ty404yhd.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Jan 2012 13:45:19 +0800, Wu Fengguang <fengguang.wu@intel.com> w=
rote:

> @@ -5943,6 +5947,7 @@ static void ironlake_write_eld(struct dr
>  	if (intel_pipe_has_type(crtc, INTEL_OUTPUT_DISPLAYPORT)) {
>  		DRM_DEBUG_DRIVER("ELD: DisplayPort detected\n");
>  		eld[5] |=3D (1 << 2);	/* Conn_Type, 0x1 =3D DisplayPort */
> +		I915_WRITE(aud_config, AUD_CONFIG_N_VALUE_INDEX); /* 0x1 =3D DP */
>  	}

Do we need to clear this bit in the HDMI case? Or do we just trust the
BIOS to either leave this bit zero or set it correctly?

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTw8ZbjYtFsjWk68qAQiRwxAApFKKEQyS5JeRpPnwnoA8C7uy/uV+WeAv
B2mt/Sye6DruK6O2aQ8EtV4GpY3cR17muVtKSdZf8lhijgEI6RNUA9wpMxwYURx4
A2SZq/8AkmxGRt7OaUYx5Tm1tNnTtOAtzZCGh5hba969lHQUmkdjJqTuSUdccZoz
45aZm12ZZcQ8fMIXxglBw96XADYnpct9MXB+yG0Qp/ldjugryRcw/apFbHPgabiU
ZXtYnPFqh+PdWtc2lXO+J9nzNl3n//x36AmJpqUg8N7+23NNkGo3tDb0N3oVENZb
DRBTGft6aHoJhjkwxQt+N5rOazSUHhGqMRYPYlQ4a4v5rxUy6LwATVeugh7dDkGw
tMXazkeNyWJHYNDQWVZS63aXl+l8OLE4fEEcI8+7Oe5JCUpzILuGvGceWzjU7O8q
E3PS4XeUH2fVee9Qxxw6VmDWv+E2NH39keLV5qnRSBR9OHnawdF91onpDwvgB+Ks
IaN3C0d+gGo1JOMHuEXgISb8kcTldvCZu2Me4wxGmSmeJO5OKygTQAgy3PxZs7ii
7KwFJfyC0iwDmhmd2iZkgjO1XB2mq5+IEYCema1GCsydr27HqCjnNlkQxQSbufwd
mxN19SBRqaGz58a7yw69pfP15aT/j2xYkR8WoqVobThOriTpBj9Smce8nmiHpWXD
PuT/wCK1vYI=
=Mhr2
-----END PGP SIGNATURE-----
--=-=-=--
