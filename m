Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab2B1Ijm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 03:39:42 -0500
Received: from mail.gw90.de ([188.40.100.199]:57800 "EHLO mail.gw90.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255Ab2B1Ijk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 03:39:40 -0500
X-Greylist: delayed 1527 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Feb 2012 03:39:40 EST
Message-ID: <1330416849.3899.11.camel@mattotaupa>
Subject: Re: regression(?) 3.3-rc4 -> 3.3-rc5: drm intel hangs
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: Norbert Preining <preining@logic.at>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Date: Tue, 28 Feb 2012 09:14:09 +0100
In-Reply-To: <20120228040327.GA9973@gamma.logic.tuwien.ac.at>
References: <20120228040327.GA9973@gamma.logic.tuwien.ac.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-JF8B4/rmE1LkA8Dzlj+/"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JF8B4/rmE1LkA8Dzlj+/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Norbert,


Am Dienstag, den 28.02.2012, 13:03 +0900 schrieb Norbert Preining:
> Dear all,
>=20
> (please Cc)
>=20
> since upgrade to 3.3-rc5 I see the following behaviour repeatedly:
>=20
> Feb 28 11:42:47 mithrandir kernel: [15627.756071] [drm:i915_hangcheck_ela=
psed] *ERROR* Hangcheck timer elapsed... GPU hung
> Feb 28 11:42:47 mithrandir kernel: [15627.756087] [drm] capturing error e=
vent; look for more information in /debug/dri/0/i915_error_state
> Feb 28 11:42:47 mithrandir kernel: [15627.758428] [drm:i915_wait_request]=
 *ERROR* i915_wait_request returns -11 (awaiting 7 at 4, next 8)
> Feb 28 11:42:47 mithrandir kernel: [15628.260094] [drm:i915_reset] *ERROR=
* Failed to reset chip.
>=20
> Is this is known issue?

I do not know. But it would be interesting to know if you just see this
in your log files or if you also see some effects like screen
corruptions. You can increase the log level by adding `drm.debug=3D0x06`
to the Linux kernel command line [1].

[=E2=80=A6]


Thanks,

Paul


[1] http://intellinuxgraphics.org/how_to_report_bug.html

--=-JF8B4/rmE1LkA8Dzlj+/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk9MjNEACgkQPX1aK2wOHVgeRQCfVSuOzFibatQxa/V4tGRpRY2p
ZyMAoIF7lcjH5Owva45l/0IKXOaJGJH4
=9Nk0
-----END PGP SIGNATURE-----

--=-JF8B4/rmE1LkA8Dzlj+/--

