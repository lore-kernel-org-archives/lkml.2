Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072Ab1IXRkr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 13:40:47 -0400
Received: from home.keithp.com ([63.227.221.253]:58322 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007Ab1IXRkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 13:40:46 -0400
From: Keith Packard <keithp@keithp.com>
To: Alex Davis <alex14641@yahoo.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Regression] Laptop screen dark when lid closed and reopened.with 3.1
In-Reply-To: <1316877222.89367.YahooMailNeo@web130124.mail.mud.yahoo.com>
References: <1316478488.72684.YahooMailNeo@web130114.mail.mud.yahoo.com> <1316868946.61433.YahooMailNeo@web130123.mail.mud.yahoo.com> <yunvcsim1wk.fsf@aiko.keithp.com> <1316877222.89367.YahooMailNeo@web130124.mail.mud.yahoo.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Sat, 24 Sep 2011 10:40:42 -0700
Message-ID: <yunsjnln8it.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sat, 24 Sep 2011 08:13:42 -0700 (PDT), Alex Davis <alex14641@yahoo.com> =
wrote:

> One good thing about the 3.1 kernels is that I now have the /sys/class/ba=
cklight/intel_backlight directory
> in addition to /sys/class/backlight/dell_backlight. With intel_backlight,=
 I can control the LCD brightness;
> dell_backlight never worked, neither in 3.0 or 3.1.

Can you tell if the screen is blank with the backlight on, or is the
screen drawn correctly and the backlight off?

If the screen is blank but the backlight is on, then you may want a
patch which is on my drm-intel-fixes branch.

git://anongit.freedesktop.org/~keithp/linux

If the screen is drawn, but the backlight is off, you may want to try
reverting the native backlight patch:

aaa6fd2a004147bf32fce05720938236de3361d9

Author: Matthew Garrett <mjg@redhat.com>  2011-08-12 03:11:33
Committer: Keith Packard <keithp@keithp.com>  2011-08-15 12:10:25
Parent: 302983e9059e9ef5de3ca7671918eeb237c5971e (drm/i915/pch: Fix integer=
 math bugs in panel fitting)

Not all systems expose a firmware or platform mechanism for changing the ba=
cklight intensity on i915, so add native driver support.
=20
=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOfhYaQp8BWwlsTdMRAsoZAJ9nksCOyxSq+HXwcUoTN3gAjLp4GgCfd935
QQQMeQwDY/1ny5GrHESrHiA=
=izDy
-----END PGP SIGNATURE-----
--=-=-=--
