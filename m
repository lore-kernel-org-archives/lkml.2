Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab0DTRNZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 13:13:25 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:34574 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab0DTRNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 13:13:24 -0400
From: Eric Anholt <eric@anholt.net>
To: Takashi Iwai <tiwai@suse.de>
Cc: David Airlie <airlied@linux.ie>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i915: Skip wrong TV outputs on HP laptop
In-Reply-To: <s5htyr6jnip.wl%tiwai@suse.de>
References: <s5htyr6jnip.wl%tiwai@suse.de>
Date: Tue, 20 Apr 2010 10:13:20 -0700
Message-ID: <87sk6q82tr.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Tue, 20 Apr 2010 14:50:54 +0200, Takashi Iwai <tiwai@suse.de> wrote:
> A new HP laptop with GM45 seems detecting wrongly TV outputs
> occasionally.  Most of time it detects the TV output as disconnected,
> but spontaneously it detects NTSC 480i although the laptop has no TV
> output at all.
>=20
> A simple (but ad hoc) fix is to add a DMI check as below.
>=20
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

Does this laptop have no TV connector on the laptop or the dock for it?

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvN4LAACgkQHUdvYGzw6ve+1gCfVN48zOm20AZfEPlj/osX/LDZ
ncIAoIPhKEM2ayDsPzkS1hGYf6NNf+aP
=vbLN
-----END PGP SIGNATURE-----
--=-=-=--
