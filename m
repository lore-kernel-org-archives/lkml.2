Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483Ab2K0VJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 16:09:39 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:59266 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375Ab2K0VJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 16:09:37 -0500
Date: Wed, 28 Nov 2012 08:09:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for Nov 27 (file notify)
Message-Id: <20121128080928.498fcbf68e9afac415bdc27b@canb.auug.org.au>
In-Reply-To: <50B4EDBF.8070304@infradead.org>
References: <20121127172548.cd502ebfb903face1dc98554@canb.auug.org.au>
	<50B4EDBF.8070304@infradead.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Nov_2012_08_09_28_+1100_m/c+HUBT.wzF_bxf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Nov_2012_08_09_28_+1100_m/c+HUBT.wzF_bxf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[Just adding some more cc's]

On Tue, 27 Nov 2012 08:43:43 -0800 Randy Dunlap <rdunlap@infradead.org> wro=
te:
>
> On 11/26/2012 10:25 PM, Stephen Rothwell wrote:
>=20
> > Hi all,
> >=20
> > Changes since 20121126:
> >=20
>=20
>=20
> when CONFIG_PROC_FS is not enabled (also seen in mmotm):
>=20
> fs/notify/fanotify/fanotify_user.c:436:17: error: 'fanotify_show_fdinfo' =
undeclared here (not in a function)
> fs/notify/inotify/inotify_user.c:333:17: error: 'inotify_show_fdinfo' und=
eclared here (not in a function)
>=20
>=20
>=20
> --=20
> ~Randy
>=20


--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__28_Nov_2012_08_09_28_+1100_m/c+HUBT.wzF_bxf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQtSwIAAoJEECxmPOUX5FEPWcP/jmFlcg21wn2d3Eobmfw1xG3
ngaDwu9exLBczWhxKPq6h/SHI7SQfSlugXk8zcjMh25+xe7Y+HCkcRFKeFzoNHpj
4x6AcLIvtmalZNDuK+xkm2IaSTZ/mOQda0SgVFYZiu2tRQgEn3AqiMaO5zuxvU6k
HA0kIhGE3KkTJ6P1UVRB3lw96O6hO66iOM+y7db/Zw+V+GeeBMO9IFRnYBcVoJXC
ljVw3qCa949C2QF/Qe8E1kuiGVNTMRoIhjZ4A9sV4jNAr9EhC312jJNCTaqb+VIs
Ld1nCR2Ha0N+tZ6ekhjMB8ND+lLOjYIF8v7eJChWxH+it5gd7KkOFVvE88xYwvtB
w8eoFANeCVg0zWaemmnJDeYSirlmez1cVgW7yhA85aNdVo44jh8JSSemfVK6y48v
69bb1wI1y2bOI776vQAWX07mz1h+UaRD2O7MIVDyr/cSK5tP4ubJgGjTsouvZzcm
5TGChWbiaRVgK3xZRi5o1bCEvTZ7tc024BGUa5LAuHvzpqKKzF7yHPEAWo7IpBwK
BEEEOhCDsf5I0/JA4pNBP54oaVRITSpsshjyQfa8Q2SnhJwqzDhaFfPzOgsoyFVc
kpXf56UX9HapBl/KTdi73MEWFJmuQlGHWz9xkra44BfwWshxhQyVKklXzcxRVEin
4mLuVIBkibTk4/wm8igP
=UXEX
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Nov_2012_08_09_28_+1100_m/c+HUBT.wzF_bxf--
