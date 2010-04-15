Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab0DOOUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 10:20:44 -0400
Received: from k66.ru ([87.224.128.21]:46520 "EHLO k66.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754141Ab0DOOUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 10:20:43 -0400
Date: Thu, 15 Apr 2010 20:20:40 +0600
From: Andrey Rahmatullin <wrar@altlinux.org>
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: linux-kernel@vger.kernel.org, lxc-devel@lists.sourceforge.net
Subject: Re: [lxc-devel] OOPS on lxc-stop
Message-ID: <20100415142040.GA5784@wrars-comp.wrarsdomain>
References: <20100411170542.GA5745@wrars-comp.wrarsdomain>
 <4BC2E918.50604@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
In-Reply-To: <4BC2E918.50604@free.fr>
X-Operating-System: ALT Linux Sisyphus
X-Jabber-Id: wrar@altlinux.org
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 12, 2010 at 11:34:16AM +0200, Daniel Lezcano wrote:
> At the first glance I would say it is related to the FAIR_SCHEDULER.=20
Here is the full stack trace:
http://img-fotki.yandex.ru/get/4210/wrar.4a/0_3a641_f9a80e04_XL

> Does sysrq + t show something ? Or the host is definitively stuck ?
No, even sysrq+b doesn't work.

--=20
WBR, wRAR (ALT Linux Team)

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJLxyC4AAoJEOih81koZvPBDeYH/A03WEm5zhdUQFzh0RDzc6oB
TSRFQAZ9sOEa6fJnpLxTmCVQFVEEXJul6TaRZYs4ya3J/Z0wU5SRaHsfy7z7xFtr
Y8G1UTkJwSRtHgTcQYMMuD4YJlW5042JIngJC4rQdMoggCRH/CX0fr5+g6MDW91E
XV+LfoI7+clI3kk6huqxKVFeAzBDWKLKmsG+s9wyeIWfjLYU5vrkt76fBdoqK2sj
aAFNskCSzuESE7QFuBJDtl6ONXxGwVdlBO3CyLGgXYD4xfXWJvnz+cHdBs0GGcvw
EV3WcnLyRl2SG/kRcBz2z+8u5gMXZcxmOVYd51AtS2qiFFX1oJ624gouXwlg1wA=
=w2Xy
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
