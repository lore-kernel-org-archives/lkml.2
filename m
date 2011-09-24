Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610Ab1IXOtI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 10:49:08 -0400
Received: from home.keithp.com ([63.227.221.253]:39672 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459Ab1IXOtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 10:49:07 -0400
From: Keith Packard <keithp@keithp.com>
To: Alex Davis <alex14641@yahoo.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Regression] Laptop screen dark when lid closed and reopened.with 3.1
In-Reply-To: <1316868946.61433.YahooMailNeo@web130123.mail.mud.yahoo.com>
References: <1316478488.72684.YahooMailNeo@web130114.mail.mud.yahoo.com> <1316868946.61433.YahooMailNeo@web130123.mail.mud.yahoo.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Sat, 24 Sep 2011 07:48:59 -0700
Message-ID: <yunvcsim1wk.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sat, 24 Sep 2011 05:55:46 -0700 (PDT), Alex Davis <alex14641@yahoo.com> =
wrote:
>=20
>=20
> I have a laptop running Slackware64 13.37. With 3.1rc2, rc5, rc6, and
> rc7 the display stays dark when the lid is reopened.  The display is
> restored correctly with 3.0.2 and 3.0.3. I'm using KDE 4.5.5. I
> attached scripts to the brightness function keys which allow me to
> adjust the brightness manually, which revealed another regression: the
> password dialog to unlock the screen does not appear until I switch to
> the text console and back to my X session.

If you can, please send along a kernel log with drm.debug=3D5 and the
output of intel_reg_dumper run when the screen is working and when it is
black -- you'll need to use ssh from another computer to capture the
latter.

intel_reg_dumper can be found at:

        git://anongit.freedesktop.org/git/xorg/app/intel-gpu-tools

I suspect you're hitting some of the backlight changes. Hard to believe
that something as simple as a light could be so complicated...

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOfe3bQp8BWwlsTdMRAj9RAJ9Gziohs1we3iEMbUgq+Pu1iSmt5wCeJWDE
CGqdJ3v9IANdT5pjNKIrqD4=
=MaFM
-----END PGP SIGNATURE-----
--=-=-=--
