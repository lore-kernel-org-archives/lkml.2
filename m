Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950Ab1FQRoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 13:44:25 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:36635 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab1FQRoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 13:44:23 -0400
From: Eric Anholt <eric@anholt.net>
To: Daniel J Blueman <daniel.blueman@gmail.com>,
        Dave Airlie <airlied@redhat.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Ben Widawsky <ben@bwidawsk.net>,
        Kenneth Graunke <kenneth@whitecape.org>, Yi Sun <yi.sun@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Mengmeng Meng <mengmeng.meng@intel.com>,
        Robert Hooker <sarvatt@ubuntu.com>,
        Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: [PATCH 3.0-rc3, v2] i915: Fix gen6 (SNB) GPU stalling
In-Reply-To: <1308328920-2068-1-git-send-email-daniel.blueman@gmail.com>
References: <1308328920-2068-1-git-send-email-daniel.blueman@gmail.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 17 Jun 2011 10:44:19 -0700
Message-ID: <87zklgnyj0.fsf@eliezer.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sat, 18 Jun 2011 00:42:00 +0800, Daniel J Blueman <daniel.blueman@gmail.=
com> wrote:
> Workaround Sandy Bridge GPU stalls by allowing the blitter command stream=
er
> to write interrupt state to the Hardware Status Page when a MI_USER_INTER=
RUPT
> command is decoded.
>=20
> v1->v2: Moved to prior interrupt handler installation and RMW flags as per
> feedback.

We shouldn't be RMWing.  We're the driver, we're supposed to know what
we want.  I'm backing that bit out, will do another round of testing,
and send it off.

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk37knMACgkQHUdvYGzw6vcnQQCeNlKC6Ddu+BN9TJgxjv7oApYl
RvMAnRk3lKn4qCSjjkUf//mjbZDoGES3
=SOg4
-----END PGP SIGNATURE-----
--=-=-=--
