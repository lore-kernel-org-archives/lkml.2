Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab1KSSeW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 13:34:22 -0500
Received: from home.keithp.com ([63.227.221.253]:34896 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897Ab1KSSeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 13:34:21 -0500
From: Keith Packard <keithp@keithp.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Daniel Mack <zonque@gmail.com>, Chris Wilson <chris@chris-wilson.co.uk>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, harald@redhat.com,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: Fix invalid backpanel values for GEN3 or older chips
In-Reply-To: <s5hr5144ecu.wl%tiwai@suse.de>
References: <s5hlirgm1kg.wl%tiwai@suse.de> <yunsjlnl1f6.fsf@aiko.keithp.com> <s5hlirelndd.wl%tiwai@suse.de> <861ut5mdvn.fsf@sumi.keithp.com> <s5hr5144ecu.wl%tiwai@suse.de>
User-Agent: Notmuch/0.9 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Sat, 19 Nov 2011 10:34:12 -0800
Message-ID: <867h2wklln.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sat, 19 Nov 2011 11:05:05 +0100, Takashi Iwai <tiwai@suse.de> wrote:

> Maybe it'd be better to mention that actually setting bit-0 caused a
> blank screen on some machines.

Was that caused by *just* setting bit zero? Or was it caused by setting
the duty cycle to 0xffff, in which case it would be larger than the
maximum value?

I'll clean up the commit log message with your answer and then push this ou=
t.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTsf2pDYtFsjWk68qAQhPihAA2FVSknKtbpTbMF7xjt2fRQ1L0/03HpiV
7edZvtHpYIQSjmhywg0vv9p8+KaPaoRszrE2EZj8tmnuc1iLdu+xoYqeG4Nkyh6d
l3cgXVLpJtF4Nf2596TM7+Fc+MjUFBeUZQRy6RBN8r5ylbviX8NzmwQhK1TMkCz1
HpDCUiPd74JtMkKyPIhIYGxSfeAczQaHL0WUffCyMi6/lCq+WpDknT5uwf8p5swM
4xmwKA3UcNMcPCIJUrtzp2Yc9y6y9UYb+IUfT7KIG7H061QltLEXLT9nLajkBZLC
+b0Hk4FAbbRRa4I5DFBqWbWG6HegOnCyXRGgv/cpwyAkf7kVvrhzB+ASqXprJzVx
+HZIo5PVRqY25c1VsnZGayE1k8tPS0knE6k16kvTOpUfagZcDf8tmloH/kkWtSOV
TOJX1hm6r9sz+xhdkSDRIPhwTwogCjWnKWZGTijnrB67zxgbG2Vi5op7BDrDrX8Q
2zZDO0Z9k51uajktHt33pUp8QZZA+hUNYXM0G0/5DNjIb/nR6yqMq+064MPAqRSC
yYSS9sn3Mwrd5PiZ3fNIJrBjl44xy4Li7QbZGwREMdW24jwCSEoWGwsVw/HiuoIZ
+JeAM1El3qW6TpwoFbgYEOV8Lkqvc8Yc8MG01cmi48kdAeZPXN9ZUA4O/ekCQjgF
aFaM08ZQsU8=
=mYpT
-----END PGP SIGNATURE-----
--=-=-=--
