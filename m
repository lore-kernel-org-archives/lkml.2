Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab1EVXCY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 19:02:24 -0400
Received: from home.keithp.com ([63.227.221.253]:48760 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795Ab1EVXCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 19:02:22 -0400
From: Keith Packard <keithp@keithp.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Regression with i915 and suspend on Thinkpad x220
In-Reply-To: <1306078089.4204.1.camel@calx>
References: <1306040157.3322.11.camel@calx> <yunlixz6yop.fsf@aiko.keithp.com> <1306078089.4204.1.camel@calx>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Sun, 22 May 2011 16:02:18 -0700
Message-ID: <yunipt2730l.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sun, 22 May 2011 10:28:09 -0500, Matt Mackall <mpm@selenic.com> wrote:

> Appears to work, thanks.

Thanks for testing this.

Jesse and Chris: would be best to figure out what's going on here if
possible, otherwise we should consider submitting an FBC disable patch
for SNB to stable@

Matt: sounds like your machine can reliably reproduce this problem; if
we come up with an alternate patch which re-enables FBC, would you be
willing to give it a try?

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFN2ZX6Qp8BWwlsTdMRAsniAJ48o/8aYA0yWmHRad4staQhgVnB4ACgozQb
opIGdFJYgEckDZo9E1EAPzQ=
=dhTe
-----END PGP SIGNATURE-----
--=-=-=--
