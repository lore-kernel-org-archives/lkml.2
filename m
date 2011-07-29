Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab1G2Spd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 14:45:33 -0400
Received: from home.keithp.com ([63.227.221.253]:41708 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392Ab1G2Spc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 14:45:32 -0400
From: Keith Packard <keithp@keithp.com>
To: Ben Brewer <ben.brewer@codethink.co.uk>, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: i915 SSC Patch
In-Reply-To: <4E32ADC7.3080002@codethink.co.uk>
References: <4E32ADC7.3080002@codethink.co.uk>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 29 Jul 2011 11:45:28 -0700
Message-ID: <yunwrf1gc3b.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 29 Jul 2011 13:55:35 +0100, Ben Brewer <ben.brewer@codethink.co.uk>=
 wrote:

> I've added a global SSC (Spread Spectrum Clock) parameter to the i915=20
> driver, since having SSC enabled breaks (distorts) VGA output on some=20
> Core i5/i7 chips (see https://bugs.freedesktop.org/show_bug.cgi?id=3D3875=
0).
> SSC is still enabled by default so the behaviour won't change but=20
> setting the global_use_ssc parameter will turn this feature off and=20
> allow affected devices to function correctly (notably the Dell Vostro
> 3300).

The question I have is why is SSC enabled on the VGA output at all? I
don't see any way VGA could ever tolerate it.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOMv/IQp8BWwlsTdMRAv3CAKDCG2F1d2oUZ9/CT9n3HgAW9awl5QCfc5A9
hfiljjMp5pICsqib+90jBsQ=
=TaiA
-----END PGP SIGNATURE-----
--=-=-=--
