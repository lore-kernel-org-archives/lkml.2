Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058Ab2GCNTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 09:19:54 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53222 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab2GCNTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 09:19:53 -0400
Date: Tue, 3 Jul 2012 23:19:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Walleij <linus.walleij@linaro.org>, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org,
        Lists Linaro-dev <linaro-dev@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Amit Kucheria <amit.kucheria@linaro.org>, linux-next@vger.kernel.org,
        Colin Cross <ccross@android.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rob Lee <rob.lee@linaro.org>, "lenb@kernel.org" <lenb@kernel.org>
Subject: Re: linux-next : cpuidle - could you add my tree please
Message-Id: <20120703231948.33cca18e3cc3d6e497ab022d@canb.auug.org.au>
In-Reply-To: <4FF2EC1A.7020702@linaro.org>
References: <4FDEE98D.7010802@linaro.org>
	<201207022149.36629.rjw@sisk.pl>
	<4FF21D48.50301@linaro.org>
	<201207031059.13758.rjw@sisk.pl>
	<4FF2EC1A.7020702@linaro.org>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__3_Jul_2012_23_19_48_+1000_hRH164ZDft9sCcxL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__3_Jul_2012_23_19_48_+1000_hRH164ZDft9sCcxL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

On Tue, 03 Jul 2012 14:56:58 +0200 Daniel Lezcano <daniel.lezcano@linaro.or=
g> wrote:
>
> > So do you have a branch in the cpuidle-next.git tree that isn't going to
> > be rebased?
>=20
> No. I am following Linus tree and adding the patches on top of it.

Please don't rebase your tree more than necessary - it just makes thing
hard for anyone using your tree as a base for further development and
throws away any testing you may have done.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__3_Jul_2012_23_19_48_+1000_hRH164ZDft9sCcxL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP8vF0AAoJEECxmPOUX5FEHCAP/jkckjXoXFxvHuKhbDrntbXV
aBrcfSuvOtK0iXA3BvP2z6H/6Li42FLYToj+yE4JiR7Mz0MiNUEvHaS5zEBT3hVt
FP98lk6TR05tKdElu5aY7uyqnsbpxfnNHX0MNg22yk8/RSp7cLlnUCU8+IAxiyxH
3ZAf24uo7kSPtZJBPjvbo1KPKEbeNNpQXQYySNIptzSJnANyNUJr/qk5fnM9B4sE
AWy/M4Z0Gy1BLYY2sd4QQQ6mPAP3F30rQ1XzwxkpUoViie4BXnbzCrz9/sTJsmEL
3ttQfl5xVTrNmPSb7U3B8vVY2uygI61Au4yxTThk/1/6QMajTLhd13I+zzZyp9WM
HNOpDUAFt/o3xW3+LBqiATncrAfZrFdDz6jcKtQI/3J3vaqwYxOvPamv+108kxjr
s4IWP7MAB6xg2SP2aqjXV+0lhi6QtVkR+UDXYiYw7j6vnMetL5k0W0r23boXu14Z
XIviy2Vyk4gqtMfLb2kI7EemMEHUCqhGjq3ITgWWooSJ9oc8qEwPyqsWqhR1/fEx
3Nn/8xmIW0H3UJbyuzhuW00C793rXq5X0l3sR+QT26xH2BkOTY8CUDEiWDFqr0IF
A1gtaiyMft3drCSZdJJsdAMnlif/JViMMaZwYQFbFsGFNNBbWytg+o5c27spCNq3
CuJtLkb/rGRVAsGuckfL
=2V98
-----END PGP SIGNATURE-----

--Signature=_Tue__3_Jul_2012_23_19_48_+1000_hRH164ZDft9sCcxL--
