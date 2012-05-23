Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964897Ab2EWDIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 23:08:51 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51654 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090Ab2EWDIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 23:08:50 -0400
Date: Wed, 23 May 2012 13:08:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: triage for May 22, 2012
Message-Id: <20120523130846.24ba704d48f4e1ee25de4852@canb.auug.org.au>
In-Reply-To: <20120523010457.GA4816@windriver.com>
References: <20120523010457.GA4816@windriver.com>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__23_May_2012_13_08_46_+1000_zaWsiy8mtiH_Qgix"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_May_2012_13_08_46_+1000_zaWsiy8mtiH_Qgix
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Tue, 22 May 2012 21:04:57 -0400 Paul Gortmaker <paul.gortmaker@windriver=
.com> wrote:
>
> sparc:defconfig
> 	when:	May 22
> 	why:	sparc/kernel/time_32.c: inval use undef type 'struct clock_event_de=
vice'
> 	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6243021/=09

A bad merge in my tree - will be fixed today.

> sparc:allnoconfig
> 	when:	May 22
> 	why:	arch/sparc/kernel/time_32.c: invalid use of undef 'struct clock_eve=
nt_device'
> 	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6348424/

Ditto

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__23_May_2012_13_08_46_+1000_zaWsiy8mtiH_Qgix
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPvFS+AAoJEECxmPOUX5FEfIEP/1XPHSXWJm0qQOLm+707w8iL
Zjpq/wooIsEg5ch9JaecWqQ/v8m/sZonwEOMMsFylogcxk8lzj8+UDU4e+KiwTYu
jQhrYOM7TrmFnYtP9Kr0SE0zSUZ5ZfwR06FSSeBYxe6YCVKvH2+6P2WRfxiIjPNa
wk2Dv2aA1ESLoVjRWyDaNzDI4jTAkaF7RUpgJpJU4P4yIoE4XfufuxlIfRMFI6gV
nPtWGyuIiI3PFu5s3AE6Ex+jRweddlF6K2IZZZFJ55Yi1Na5bEbD7HpVpcTYx8+N
wmGGMF8QOUW4EjYkrQbzJxcMch0uCo9RI7EMmhDB5XiN/ovkoOcOuM/Kx8eHw4kF
duRaDT8N+fYE++T6D9GqHHmNOhpOUAFGxRMqIfDgdt6+HXfla5mDmia6NZnRw5hm
WsgJpfGl7pbQK+cgvv67JfAzIV8oaAXQ2CqGuETE3W5Rl4OBQaiQ2uFrsnKIoiHs
v9gV8JPttf185dCBupqOTP8lnZyTguRXNnAYZibR44jkmNLlg27EGOBhSY8sUph2
bWhKeCn91QURLixjlLE1jxwRlSsXJ6s1kIpRqynRsJasJntgowAD6QCb5n2ER2ab
j2EHuio/zrc8i+4nrAFgVy7Q0DoSSCw71u8lKTatMt33AUc5EtHMdRtSbL0LhdIR
W/is62q9u3nfqPn24lcJ
=zgc2
-----END PGP SIGNATURE-----

--Signature=_Wed__23_May_2012_13_08_46_+1000_zaWsiy8mtiH_Qgix--
