Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab1LUV1B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 16:27:01 -0500
Received: from os.inf.tu-dresden.de ([141.76.48.99]:58154 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab1LUV07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 16:26:59 -0500
Date: Wed, 21 Dec 2011 22:26:26 +0100
From: Udo Steinberg <udo@hypervisor.org>
To: Keith Packard <keithp@keithp.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: GPU hung with Linux-3.2-rc6
Message-ID: <20111221222626.0b8c3a30@x220.fritz.box>
In-Reply-To: <864nwty9sq.fsf@sumi.keithp.com>
References: <20111221195410.5e4c065a@x220.fritz.box>
	<864nwty9sq.fsf@sumi.keithp.com>
X-Mailer: X-Mailer 5.0 Gold
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/pq.Dowg.Cp=z7cgcTmzcP4n"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/pq.Dowg.Cp=z7cgcTmzcP4n
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 21 Dec 2011 12:00:37 -0800 Keith Packard (KP) wrote:

KP> On Wed, 21 Dec 2011 19:54:10 +0100, Udo Steinberg <udo@hypervisor.org> =
wrote:
KP> > Hi,
KP> >=20
KP> > With Linux-3.2-rc6 I'm frequently seeing GPU hangs when large amounts=
 of
KP> > text scroll in an xterm, such as when extracting a tar archive. Such =
as this
KP> > one (note the timestamps):
KP>=20
KP> Can you try with semaphores disabled?
KP>=20
KP> i915.semaphores=3D0

That makes the problem go away. If you need more help tracking down the
problem, then let me know. I can reproduce it fairly easily with something
as simple as:

	while true; do dmesg; done

KP> And, you should be able to remove the explicit rc6 argument now; if it
KP> will work, the kernel should turn it on automatically.

Ok.

Cheers,

	- Udo

--Sig_/pq.Dowg.Cp=z7cgcTmzcP4n
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7yTwIACgkQnhRzXSM7nSmk3gCfTOg8AE/rTkkT1w2LsJI+Lbm0
XeoAnjPscc6VayA608FmWBAtjkKphdnN
=4vWj
-----END PGP SIGNATURE-----

--Sig_/pq.Dowg.Cp=z7cgcTmzcP4n--
