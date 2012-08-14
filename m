Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab2HNLgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 07:36:35 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:56355 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755815Ab2HNLge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 07:36:34 -0400
Date: Tue, 14 Aug 2012 14:32:47 +0300
From: Felipe Balbi <balbi@ti.com>
To: Ajay Garg <ajaygargnsit@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to hack syscall-table, in kernel 2.6+ ?
Message-ID: <20120814113246.GH11416@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <CAHP4M8WV64UMor_oU4UNgGx7P0Zet_M3yJrAZaCR+yYQmmeEYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mhjHhnbe5PrRcwjY"
Content-Disposition: inline
In-Reply-To: <CAHP4M8WV64UMor_oU4UNgGx7P0Zet_M3yJrAZaCR+yYQmmeEYw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mhjHhnbe5PrRcwjY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 14, 2012 at 05:01:56PM +0530, Ajay Garg wrote:
> Hi all.
>=20
> It is well known that the syscall-table had stopped being exported
> from version 2.6 onwards.
>=20
> So, now as a developer, if I wish to hack into the syscall-table, and
> change the syscall-function-pointers to my custom-function-pointers
> (mainly for the reason of adding/preventing access to certain files,
> via Kernel-Loadable-Modules), what is the recommended way?
>=20
> I have already tried extracting the address of the "sys_call_table"
> from "System.Map"; however, I am still not able to replace the
> function-pointers with mine.
> Trying to do gives me page-faults, apparently meaning that the
> syscall-table memory area is read-only.
>=20
>=20
>=20
> I will be grateful, if someone could point me to the recommended way
> of doing this.

Have you looked into selinux [1] ?

[1] http://selinuxproject.org/page/Main_Page

--=20
balbi

--mhjHhnbe5PrRcwjY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQKjddAAoJEIaOsuA1yqREztQP/3c7+KEzXOv9a3N9djWIknJa
V/UleYNYRQIueJS7SnRTp7LmloLiyNDMngwMhpvnUaByomFeZ7N/wXbZ9s/BrHU0
jjv9fSfyJAvQpVF6CeE5LQfFInJdsdmkePGvZDf3vJX4MSvpDE4/UNjc9uGPbEWO
woR31gMTp4pHK/HOe72jsAwjMHx0YFSDDk/A8QolreRvoucjTE7uVK2rSngLn35P
vmQKZVZIYf7FLAQx3M5p9A71rfgvqnh2dph5VaFPaMMsqo5tpGMXhDo3ZHre/FMU
kSn4I9Evqm/tWGDH9UlCEHIMe92e94+oJWbR5w3ryIZPSlydkCY2J4t799sr0eDS
NX4U1CkZ2fIneOOu7nYeHjt2hHPCY+qIcwH6KkbWUY8ZPORh1ghO6ZfbgN63uozj
nrWXQTRP+1CRlzhgg2k7r1Jv1bMbexHzpqW4551XlXlhPlxaamO2WvGKIwiKU+rY
FGbbAczntqQjuyGOBTS+KYhs7u/jH+qFJ1LpUrSov20Qd0w6Reg0D56ER1vUIYQj
kY355aY90Q8WBBxCjS47/7Su3R/Q8YO/yuSRE7MZp2NUiUpbAOmjE10jV7QRI1dk
9cIyEDkv1jyswjDJ2tE99fssPp2d8AzVDm71xB7s1QUpXQt1z7ZtSmugbfHTrc0m
rpIwCMtUuXN+7mVrh85b
=ggW7
-----END PGP SIGNATURE-----

--mhjHhnbe5PrRcwjY--
