Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab1GYTn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 15:43:56 -0400
Received: from home.keithp.com ([63.227.221.253]:37713 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078Ab1GYTnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 15:43:55 -0400
From: Keith Packard <keithp@keithp.com>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iwlagn: check for !priv->txq in iwlagn_wait_tx_queue_empty
In-Reply-To: <1311622594.3431.0.camel@wwguy-ubuntu>
References: <1311622702-4807-1-git-send-email-keithp@keithp.com> <1311622594.3431.0.camel@wwguy-ubuntu>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Mon, 25 Jul 2011 12:43:52 -0700
Message-ID: <yuny5zmuow7.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 25 Jul 2011 12:36:34 -0700, wwguy <wey-yi.w.guy@intel.com> wrote:

> is this against any bug in bugzilla? please include the information in
> description

I looked in bugzilla and didn't find anything matching -- the only
iwlagn suspend bug I could find was already resolved and completely
different.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOLcd4Qp8BWwlsTdMRAnLxAJ4gSafBaofppYeuH5dqY602qatkuACgpak8
PZHzXflZy/g9AUFkkaaaPSo=
=9Nlv
-----END PGP SIGNATURE-----
--=-=-=--
