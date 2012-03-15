Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031319Ab2COAF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 20:05:27 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38306 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031227Ab2COAF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 20:05:26 -0400
Date: Thu, 15 Mar 2012 11:05:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>, yinghai@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: 3.3.0-rc6-next-20120308 boot failure on POWER7 blade
Message-Id: <20120315110516.4112fe49dac537b52d4ddc25@canb.auug.org.au>
In-Reply-To: <20120309102846.51f0df89@jbarnes-x220>
References: <20120309142555.7ec5e0ac@kryten>
	<1331263785.3105.52.camel@pasglop>
	<20120309144645.5b5997d2@kryten>
	<20120309102846.51f0df89@jbarnes-x220>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__15_Mar_2012_11_05_16_+1100_5IUSp=U23Q=poG5c"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Mar_2012_11_05_16_+1100_5IUSp=U23Q=poG5c
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jesse,

On Fri, 9 Mar 2012 10:28:46 -0800 Jesse Barnes <jbarnes@virtuousgeek.org> w=
rote:
>
> On Fri, 9 Mar 2012 14:46:45 +1100
> Anton Blanchard <anton@samba.org> wrote:
>=20
> > > Looks like something that got fixed but the new patches from Bjorn
> > > aren't in next yet. I'll fwd you the patch separately to apply on
> > > top of what you have see if that helps (to confirm that's indeed the
> > > issue).
> >=20
> > Thanks, confirmed that it fixes it. Patch below in case anyone else is
> > hitting it.
> >=20
> > --
> >=20
> > On Sat, 2012-03-03 at 08:52 +1100, Benjamin Herrenschmidt wrote:
> >=20
> > > Or give me a chance to dig :-) I'll have a look next week.
> >=20
> > This is indeed what bjorn suspected on irc, this patch fixes it:
> >=20
> > (Bjorn, please fold it in the original offending patch)
>=20
> Thanks guys; I'll push the fixes to -next when I get to a real network
> (at the airport now about to run out of battery with a crappy
> connection).

Ping?

I am also still carrying the build fix for arch/powerpc/kernel/pci-common.c
since Feb 27.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__15_Mar_2012_11_05_16_+1100_5IUSp=U23Q=poG5c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPYTI8AAoJEECxmPOUX5FEppsP/R9s6HRmtzav+HaJWMI9m+KO
/QGGns5Leu7nmBd92H+LtSfePp+D04kQs0Jxn0Jt8TRLmmtjYt0UCM6UWI9CVflb
Ex9C3CCRmBhNjRNN9iwdfqjdEvjcJ+fNZJnLSSogoGcV+y0YSpdy/L5mm5Tue+Ud
kj7xg+fiS7sdxqEPlljeSxFeokpXwB8a47nebgxz+/no0MozGUYtvHqfDlRvnHaZ
d+5ut7v2+eqNsIjmCJCkEARe1t5uNio/3hm56ZYgtPkd4v2h9nJnHOt4TUR+rIVl
0edddRd4IabHHG9olPUouZb188g645dUdPUdFGWeLdDtV5hHZqzFDxwDffej96Qm
pFPgd0xkNx6GdO1KQNVDgCVYG0snOWKEKbAbeztXUYzogmCOPt60ESUd/YkPUQyw
ioZNuS1MgJ1FBG1vtE3LF1SEI8qlqSDjJAJhA6oDp7wiSnITGVo0KTA81XgAXaIm
QuAMtRMgqtq5QJPUG/TB9y+vvqDGBWYCE08+ZWncGA+0u82472Pge2so9Wx7mz0F
5v0SSFNwiWQQnvpa1Yr1MMIFUi2jGmA2rEh7lLTZmplHeKvjSH5vdpZTvgxnunIR
jiPo4tXu9V1QHQl5iz26xmA1/7EVWSOeOZt1LKBfI8lltGZh/Kx8T1CJmk128j+f
tyRKfpSZK7a3IiPFno9k
=vkvs
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Mar_2012_11_05_16_+1100_5IUSp=U23Q=poG5c--
