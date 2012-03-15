Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031331Ab2COAOf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 20:14:35 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43338 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760903Ab2COAOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 20:14:31 -0400
Date: Thu, 15 Mar 2012 11:14:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: akpm@linux-foundation.org, rob.lee@linaro.org, j-pihet@ti.com,
        khilman@ti.com, deepthi@linux.vnet.ibm.com, dan.carpenter@oracle.com,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        hughd@google.com, amit.kucheria@linaro.org
Subject: Re: [PATCH] cpuidle : fix random hangs with intel_idle
Message-Id: <20120315111415.cd119171ac86967aebe85545@canb.auug.org.au>
In-Reply-To: <1331770181-800-1-git-send-email-daniel.lezcano@linaro.org>
References: <alpine.LSU.2.00.1203131454500.1335@eggly.anvils>
	<1331770181-800-1-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__15_Mar_2012_11_14_15_+1100_0+_eXdBPP6Wa/e+I"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Mar_2012_11_14_15_+1100_0+_eXdBPP6Wa/e+I
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

On Thu, 15 Mar 2012 01:09:41 +0100 Daniel Lezcano <daniel.lezcano@linaro.or=
g> wrote:
>
> The cpuidle consolidation inverts the local_irq_enable for
> the poll_idle function with CPU_RELAX.
>=20
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Reported-by: Hugh Dickins <hughd@google.com>

So this needs to go into Rob's tree.  Maybe after Hugh verifies that it
fixes his problem.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__15_Mar_2012_11_14_15_+1100_0+_eXdBPP6Wa/e+I
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPYTRXAAoJEECxmPOUX5FEE2EQAKf2ZI6e/WnSOU+jQulIHOI4
ZF6glVtXlsh+ueQWNNnTwTApP/kz6S0w+/fKVKr+h5a1O4JkmJX/EcjjG/dx5gAA
15+Sgqx2k2gQU2WHtaKHqYSqHoKLUYYEtD8seU1VhpvuXYBOxwkyH4w1JtDvQzuz
w/wMQbnC5fsvMNeZ3o7S1F5v0nuJt3epGovmN+a1adWyLl7NDJAtZ6KxTnSa0d1F
XyuSO060pmlpV8rXm+S+u7NkJKgwbVQI5U1kCU0/k1i29jRVq0UTikvGFaUdUxHd
d1roy430ivBwxGfRd8rJ3aiHnP0xyiyjjf4gd7MnhTs5MLR19kp7n0W57EH91YgR
dS2O8hSWgbdQmUROy3IhC9ex8XkuzC0iAZHTnasi7rBHLFxqrrwgj0wwM2yESAjO
+RK1Y6sLxfXBGJtEFs6XAb08IZ4ym5dfv4WV5CaxYWb+dnaHHREjfj2mTvvvLj9k
16PMLYF7xETsPQ78CFlRbl1ECsOm0plRnJ6dNlRv3g0sGsXBTy7EvmWOQwTSxTI4
wTyeuPlDg4zS7kiR/juyejGb+8NJvHV3VplYo9Bn5SoLM3foNHyM9fsvYa54IWiQ
aPHxZ/ueLJn5jWdIw0Tprn7CrnvDISOyd1tEfjSBTztM265eN8E+6ABzHYCKLUoZ
MNEkQOabEMbFaqIaMuX2
=aEc+
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Mar_2012_11_14_15_+1100_0+_eXdBPP6Wa/e+I--
