Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab1JUF2q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 01:28:46 -0400
Received: from home.keithp.com ([63.227.221.253]:57751 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560Ab1JUF2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 01:28:45 -0400
From: Keith Packard <keithp@keithp.com>
To: Emmanuel Benisty <benisty.e@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT BISECT] 2c1756b12edc19fdd75c833699cb752e1bbb641e - Display corruption after blank screen state
In-Reply-To: <CA+i8gKK5wuR3zo0d4Mz6pZjFUhdj4mmW+TvVg+rWrBR2eCOOEw@mail.gmail.com>
References: <CA+i8gK+H4Y=+ZMr9QHh-1mn0wEdhDzf4iSqUgD322UhyXoruCg@mail.gmail.com> <yun4nzllamt.fsf@aiko.keithp.com> <CA+i8gKK5wuR3zo0d4Mz6pZjFUhdj4mmW+TvVg+rWrBR2eCOOEw@mail.gmail.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Thu, 20 Oct 2011 22:28:40 -0700
Message-ID: <yuny5wehq0n.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 21 Oct 2011 10:01:57 +0700, Emmanuel Benisty <benisty.e@gmail.com> =
wrote:

> This is now fixed in Linus' tree. Just FTR, adding
> i915.i915_enable_fbc=3D0 solved the issue (prior to mainline fix).

Good. We'll try some more FBC changes after 3.1 comes out and see if
those work, but we've always had machines which do weird things when you
enable it.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTqEDCDYtFsjWk68qAQipWxAAxGVE649tvKXC1kT9GOCBYjdq0wXV7xP9
tq1o0YdXmLHQlCm/L8RVq+XGdhPZbMwEPXuW/PoyErw3mXpccpXQIVNZca7svDuP
XU+/m/A/3CKyIzLzQLfgHA9h0mL+ygM6aR1drmJwBzdlGiDYk7n+AfyLnGiwjJCU
LyZ077mm//htjjRXyNAr7mLwKm+DTSqdSTQyjgygmLR+hVSE0WfGweqHvVfNoXmQ
aRyrtKiPyNjz62jj/YVjKoJawzm9ZtrxagksHyUTku1/2mFYAOXWNAzpksjYcRjG
uBDmQXHhsXIjEqU5L50TgBgaZ4WBebHw2ZktJWMsrDxbdxq/vt5iF5W3DSxDsBZl
/KFilUdgqF1xocSSx2kP+Bkbfy/Mb+JVa27z0E/AEVvbHvlfz9CMXVSrEBFCcwy5
Z0eohCgX2Gjz/dSaXTnvVsNxf4sQkeE5L3EQtM4upa53GGq3tfJRCLrgegnjyQWZ
AjwTLI1UwFp397wl/BdyItSGjmKG00J63AtJgI+eeK0CRg7MLwKxweiHD++DJSna
RlWDU5QzWVb1FmH1PAJm3BtIZPWZM/s/895B+gKlNUJbZZ2+fJNwnpiqALzSm0Oi
PXSHB3Ct2Z7WRCQkOCV0wzPTqjeetx02z7KQtBDcpPwEv0pqqhP9w4P3EjeZbMGJ
frqSdOLDHEA=
=kG7I
-----END PGP SIGNATURE-----
--=-=-=--
