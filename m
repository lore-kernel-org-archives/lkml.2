Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654Ab1JCVZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 17:25:52 -0400
Received: from home.keithp.com ([63.227.221.253]:59925 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756850Ab1JCVZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 17:25:44 -0400
From: Keith Packard <keithp@keithp.com>
To: Ben Widawsky <ben@bwidawsk.net>, intel-gfx@lists.freedesktop.org
Cc: Ben Widawsky <ben@bwidawsk.net>, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>
Subject: Re: [PATCH 1/2] drm: Add Panel Self Refresh DP addresses
In-Reply-To: <1316557787-14935-1-git-send-email-ben@bwidawsk.net>
References: <1316557787-14935-1-git-send-email-ben@bwidawsk.net>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Mon, 03 Oct 2011 14:25:39 -0700
Message-ID: <yunaa9hn4x8.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Tue, 20 Sep 2011 15:29:47 -0700, Ben Widawsky <ben@bwidawsk.net> wrote:

> Add the addresses and definitions I care about for Panel Self Refresh, as
> documented in the eDP spec.

I generally review the addresses and bit definitions for any new
registers -- getting them wrong makes debugging the code really hard. I
couldn't find these in a brief search through the bspec. Can you point
out where they are?

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBToooUzYtFsjWk68qAQgUrQ/8D7ZzdDWVP/TZhSPAYmvagOTRs4T4Yp5e
17xDsL3jIaJNXy1xqPs0bsks9c/GISfpBEbURr/WoTakTFpcqsBz3uinzQBeexVX
bx23fA0nh2ZxPyUH4P9bLM4OvQS0QHAXehMLRlSlvlKXiXceBMwXTPBAVn1nBAw4
TMfLULz2XXjlvvHMOVuesadFkjbii5pM4jlBvul4IoERefpZoBARDNKhemHpUpzF
ixafeto7f1loI6gDzEP4gXuPvQnmh5zX1eOL4Mlk9qHv7R/YrbQDD87ErkjKLsud
7nWmiAWGwnX0Ovk40AVOhpK5pKoBUB2mRv5hxnC3ZVdRVZT6hHz7bDs3tzWs9tSa
560Zc6S7Ldj5KlVV/HuxZYXYvPf5ApVFDHT2lDLFfW9tbbAvhodIfu/yV3eJiGSz
QcCzjuwPcbRrA/6HVIMdJUhPOnI+7Acw7xmWc1AjJe+E4n3CxtTTmCZTq0DnAptm
9gpIDmmUGKo4KSTQURZ/pMFWDwm6EVv2rC6k/WWraJ5cllLpPm6P46Hn/Bf0xis0
Mr2WvpcB616W9Fa6JW2WLn6PxkWAPkiJ6+WmeJZkrZ3OTCu6Z34HbvNmNRynA2cE
Vep7gd5B/IiUP3nB6GVnoOMfYyNNwMG7JQ45adbmAs5/+huYUeoPyGmX8Rmv8bQF
6PrhoFP9tD4=
=RwBg
-----END PGP SIGNATURE-----
--=-=-=--
