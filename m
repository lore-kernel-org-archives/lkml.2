Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324Ab0IGRM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 13:12:58 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:32840 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147Ab0IGRM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 13:12:56 -0400
From: Eric Anholt <eric@anholt.net>
To: Andy Isaacson <adi@hexapodia.org>, linux-kernel@vger.kernel.org
Cc: Zou Nan hai <nanhai.zou@intel.com>
Subject: Re: [2.6.36-rc2 regression] X201s: resume-from-S2R hangs
In-Reply-To: <20100906090536.GA12250@hexapodia.org>
References: <20100906090536.GA12250@hexapodia.org>
User-Agent: Notmuch/0.3.1-16-g417274d (http://notmuchmail.org) Emacs/23.2.1 (i486-pc-linux-gnu)
Date: Tue, 07 Sep 2010 10:12:34 -0700
Message-ID: <87fwxlbhq5.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 6 Sep 2010 02:05:36 -0700, Andy Isaacson <adi@hexapodia.org> wrote:
> I have a Thinkpad X201s on which suspend-to-RAM was quite reliable until
> after 2.6.36-rc1; with problematic kernels, suspend seems to work OK
> (the machine goes to sleep with the moon LED steadily lit) but on resume
> the LCD never lights up (and it's not just the backlight, the screen
> isn't drawing at all) and the keyboard and network are dead.  Nothing
> makes it to syslog, either.  The moon LED is turned off though.
>=20
> There seems to be some timing component to the problem -- some problem
> kernels will suspend reliably 25% or 50% of the time and hang the rest.
> There also seems to be some per-reboot state involved; one problem
> kernel suspended successfully and survived 25 suspends in a row without
> triggering a failure.  (But after a reboot, the first suspend hung...)
> Other problem kernels fail on 4 out of 4 reboots.
>=20
> Bisecting is pretty hard under these conditions, but it seems to point
> to

Weird.  That's exactly the hardware that I tested RC6 on, and I haven't
seen a single resume failure on mine.  Sounds like time to revert for
this release.

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkyGcoIACgkQHUdvYGzw6vdiRQCffgoBi+hHH1VxwvwbAnGXJBCN
+OsAoIN4Np5fx4eOyJjsnfHLp0t9DYeQ
=k3QX
-----END PGP SIGNATURE-----
--=-=-=--
