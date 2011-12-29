Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599Ab1L2GwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 01:52:14 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:36121 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab1L2GwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 01:52:11 -0500
Date: Thu, 29 Dec 2011 17:52:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>
Subject: Re: linux-next: build warnings after merge of the rr tree
Message-Id: <20111229175200.76ab57b3b0cb7d5e2e87e172@canb.auug.org.au>
In-Reply-To: <87mxacgj8r.fsf@rustcorp.com.au>
References: <20111228135817.5b92debf636e1fd1c0c68310@canb.auug.org.au>
	<87mxacgj8r.fsf@rustcorp.com.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Dec_2011_17_52_00_+1100_Ae1RJpYx5CC7=JiI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Dec_2011_17_52_00_+1100_Ae1RJpYx5CC7=JiI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

On Thu, 29 Dec 2011 13:46:36 +1030 Rusty Russell <rusty@rustcorp.com.au> wr=
ote:
>
> On Wed, 28 Dec 2011 13:58:17 +1100, Stephen Rothwell <sfr@canb.auug.org.a=
u> wrote:
> >=20
> > After merging the rr tree, today's linux-next build (x86_64 allmodconfi=
g)
> > produced these warnings:
> >=20
> > security/apparmor/lsm.c: In function '__check_debug':
> > security/apparmor/lsm.c:712:1: warning: return from incompatible pointe=
r type [enabled by default]
> > security/apparmor/lsm.c: In function '__check_audit_header':
> > security/apparmor/lsm.c:724:1: warning: return from incompatible pointe=
r type [enabled by default]
> > security/apparmor/lsm.c: In function '__check_lock_policy':
> > security/apparmor/lsm.c:732:1: warning: return from incompatible pointe=
r type [enabled by default]
> > security/apparmor/lsm.c: In function '__check_logsyscall':
> > security/apparmor/lsm.c:736:1: warning: return from incompatible pointe=
r type [enabled by default]
> > security/apparmor/lsm.c: In function '__check_paranoid_load':
> > security/apparmor/lsm.c:747:1: warning: return from incompatible pointe=
r type [enabled by default]
> > security/apparmor/lsm.c: In function '__check_enabled':
> > security/apparmor/lsm.c:751:1: warning: return from incompatible pointe=
r type [enabled by default]
>=20
> Hmm, I thought the lsm guys had taken the patch for that.
>=20
> James said he'd applied it.  Repeated below...
>=20
> From: Rusty Russell <rusty@rustcorp.com.au>
> Subject: apparmor: fix module parameter handling

Indeed it has been applied.  Unfortunately, I merge the rr tree before
the security tree, so that warning appears between the two merges.   I
will ignore it.

Sorry for the noise.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__29_Dec_2011_17_52_00_+1100_Ae1RJpYx5CC7=JiI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO/A4QAAoJEECxmPOUX5FEjIcP/i6u8U2tUDT84rpIJeLitaI+
J3ptb+y6cDjhXThSbg+mmoAdc8uBv73N7PDq+nSquTeHFyPoe/x+1saOwOBKBpB+
HfDCvYKZ+S21safiXG1Rvsl5lics8Pi4DqDLoQoT4dEhJlhuKDqB4qDDh67xaKNA
VusQwJ1pPYQU4gQ2OS714yi+U2SR4GxtiCyGa8s1eEEAW1/mp5KF04LrIrxFxx+e
s1zNR9ckQVzvOLIDsCl1umncF1fLjETmbtNM6go38QNMGRPsUdnqz+dwHwK5Qo64
feobSvaAqcspKD56Tnz4uP1qfsqnHMrE4IqX/YltaUwgoksI6WZZyiiLPRh+okrJ
YHlf+AewZUPvEFxfP5fPsevZejAlZ9iMCTiIJ2FFwtbmydVRgSx95tRd6NK7P831
PJTvoOkJdLg6lCqtiDmCRIs+b3PDKnbYIcOsW0QUWXXZTZLnz0xHtyTutRk0366T
9Dvy2quMlBAjRvMRiDiU0d5Hd5yXKCApGBU/y75i5B2no6uY9kC7a/IlgMCZ9wHI
OR3DozV2E9Lfb3VX2fCealukY5i+Gjf7lgpTjgSjht1DVzhfGhhdDYWMIWWGiHyX
6GXpfZLld4txMf6WtutPnht8op6WdGvs4uumljYPH03q9g9+tBAU/bX6tl0zUUtO
Y0AHLEXjz4i3MT9riPsd
=0WgL
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Dec_2011_17_52_00_+1100_Ae1RJpYx5CC7=JiI--
