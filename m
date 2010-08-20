Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab0HTBd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 21:33:56 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56708 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab0HTBdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 21:33:54 -0400
Date: Fri, 20 Aug 2010 11:33:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the input tree
Message-Id: <20100820113345.dc8f2a1d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__20_Aug_2010_11_33_45_+1000_hgeV9xlYd+Db+rmo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__20_Aug_2010_11_33_45_+1000_hgeV9xlYd+Db+rmo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dmitry,

After merging the battery tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

kernel/debug/debug_core.c:763: warning: initialization from incompatible po=
inter type

Introduced by commit 18a2700652683a04cceccbd08d5b415f7246cc26 ("Input:
sysrq - drop tty argument from sysrq ops handlers").  Grep is your
friend ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__20_Aug_2010_11_33_45_+1000_hgeV9xlYd+Db+rmo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMbdt5AAoJEDMEi1NhKgbsXroH/j3ao07h5PQeaR+b5dcEEKcG
RJa2wlX4VYCcW7VM9FckhjiYrwyY/nyH96iRoFD0O8JIlN4s+EINciQIZD84sTSG
XK3q1ZFDDleSr/manXfGjtuAjjE41EpuQuwl1dRVKBNYFgTEC2KhuykczUNUgHY3
Sn8I9HHpVzxfmyMwKvSIWKvYOluBnlclAOrbry5912N4PvdbCFD+c11Xofp43R/+
X2BYW6q2TuO8eBD2Oz70/K/y7xWx4ALqnYiSll3KeQIrXKJBKDtSGK3qdTy3bsvM
k77SLY1UXAtbBQZsKuMjDkXNQ8Fcgc6ZlkwlLlXbu+6OTZ7+NBTnCsLAOfIk90E=
=xMkx
-----END PGP SIGNATURE-----

--Signature=_Fri__20_Aug_2010_11_33_45_+1000_hgeV9xlYd+Db+rmo--
