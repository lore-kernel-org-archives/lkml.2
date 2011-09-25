Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab1IYU3t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 16:29:49 -0400
Received: from home.keithp.com ([63.227.221.253]:35924 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383Ab1IYU3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 16:29:48 -0400
From: Keith Packard <keithp@keithp.com>
To: Alex Davis <alex14641@yahoo.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [Regression] Laptop screen dark when lid closed and reopened.with 3.1
In-Reply-To: <1316957004.77729.YahooMailNeo@web130108.mail.mud.yahoo.com>
References: <1316478488.72684.YahooMailNeo@web130114.mail.mud.yahoo.com> <1316868946.61433.YahooMailNeo@web130123.mail.mud.yahoo.com> <yunvcsim1wk.fsf@aiko.keithp.com> <1316877222.89367.YahooMailNeo@web130124.mail.mud.yahoo.com> <yunsjnln8it.fsf@aiko.keithp.com> <1316957004.77729.YahooMailNeo@web130108.mail.mud.yahoo.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Sun, 25 Sep 2011 13:29:44 -0700
Message-ID: <yun39fkpdqf.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sun, 25 Sep 2011 06:23:24 -0700 (PDT), Alex Davis <alex14641@yahoo.com> =
wrote:

> Result with 3.0.x: password dialog appears. This is the correct result.
>=20
> Result with git://anongit.freedesktop.org/~keithp/linux: screen is dark.
> Manually adjusting the brightness reveals a functioning mouse cursor, but
> no password dialog. Switching to a text console and back to the X session
> reveals the dialog.

Are yo using the drm-intel-fixes branch there? That's the one with the
FBC disable stuff.

Alternatively, you can just disable FBC manually by adding the kernel
argument:

        i915.i915_enable_fbc=3D0

> Result with 3.1rc7 with aaa6fd2a004147bf32fce05720938236de3361d9 reverted:
> screen with a functioning mouse cursor, but no password dialog. Switching
> to a text console and back to the X session reveals the dialog. Brightness
> cannot be controlled.

Ok, this is the second report of the new native backlight code failing;
not looking good for Matthew today :-)

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOf484Qp8BWwlsTdMRAvlrAKDrdd4dVFf0SjXHVwqRnxforMLQVQCeMkN7
BOdHrFuNPeYrrkm9c5zol/k=
=QiY0
-----END PGP SIGNATURE-----
--=-=-=--
