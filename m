Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab1DFHp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 03:45:26 -0400
Received: from home.keithp.com ([63.227.221.253]:48822 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481Ab1DFHpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 03:45:25 -0400
From: "Keith Packard" <keithp@keithp.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: 2.6.39-rc2 regression: X201s fails to resume b77dcf8460ae57d4eb9fd3633eb4f97b8fb20716
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i486-pc-linux-gnu)
Date: Wed, 06 Apr 2011 00:44:51 -0700
Message-ID: <yun1v1fj024.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable


=2Drc2 was causing resume failures on my X201s -- the video mode would get
reset, but the system would then lock up. I bisected the failure down to:

commit b77dcf8460ae57d4eb9fd3633eb4f97b8fb20716
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Thu Mar 24 20:16:42 2011 +0100

    Bluetooth: Fix warning with hci_cmd_timer

Reverting this on top of -rc2 makes resume reliable again.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFNnBnzQp8BWwlsTdMRApYpAJ0U13mda91TAfaSP9dMZOGJnb8BUwCg40h8
Opfkrb3dsZOXYlOWsZSwYwU=
=lT/m
-----END PGP SIGNATURE-----
--=-=-=--
