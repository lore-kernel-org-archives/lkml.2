Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab2CIMYE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 07:24:04 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60140 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753349Ab2CIMYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 07:24:01 -0500
Date: Fri, 9 Mar 2012 12:23:59 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?iso-8859-1?B?IkhlaWtvIFN0/GJuZXIi?= <heiko@sntech.de>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Axel Lin <axel.lin@gmail.com>, Liam Girdwood <lrg@ti.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the regulator
 tree
Message-ID: <20120309122358.GM3273@opensource.wolfsonmicro.com>
References: <20120309181755.256b898808bd14726de0e977@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EOHJn1TVIJfeVXv2"
Content-Disposition: inline
In-Reply-To: <20120309181755.256b898808bd14726de0e977@canb.auug.org.au>
X-Cookie: You will be successful in love.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EOHJn1TVIJfeVXv2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 09, 2012 at 06:17:55PM +1100, Stephen Rothwell wrote:

> Today's linux-next merge of the arm-soc tree got a conflict in
> drivers/regulator/Makefile between commit 8aa1ab9219e7 ("regulator: Sort
> Kconfig and Makefile entries") from the regulator tree and commit
> 8a16a701ad78 ("regulator: Remove bq24022 regulator driver") from the
> arm-soc tree.

Both fixups look good, thanks.

--EOHJn1TVIJfeVXv2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPWfYkAAoJEBus8iNuMP3d14oP/A/ctZDBOIY0Etp7TrqHNdS/
HWoB/uwM6vcpfmxwxMEeyJkjBDvyzRhg8+HQd3OCK7i9JEDNEmYsbcsEs1fPI/Y+
0cdt/ErIasz6VRqnPlY9TbJxGzqSDswytuFBPRV4ltxykeVpdEcJfjr4Ha472xsQ
SStsZngBDKXTIy+wCz7YZDm76j4vunxhpZM1ulGRA8c/8YFLlCig99YLX289Eq/q
RP9d5lUtRAAj74DB87yIDe0Yfga9KFe9l3HcjFxvlsWukq2NmW8pIQ+w9eRQ/xK+
e4TAboBoubMhMnpWdYKLZ3G9AMfh95JauIQBCfJHPWCq9RMgdCIrCwRjnWCf4N3a
R8qmvTJemtUGUgyxY7zPasQiiAEOIAQw0MPmRSnQGMFTZv7F/Ez0uyORwW1aGc8d
FFYfAhXeBpVgnWKNaT3fsJ1LBspM5ZmBKX03kN4//rYuDObeBJoHkMwtuGBJ9ZtO
hU94nOSONa4HKnQWhlA/Em7JyjZUd7xGI7unplkZK1WPRbsqJOQYXNDKb4jAI13O
5Z3HY5p0B+OH6u7I58nZKZSxWSSlthJ7EkcmaooAGzSOthifJP0xjgXuddRST7cq
SwiD3oze7DRO20+5jBDrMfYWCXZfy4/5DFlU/64B+mth+t7L3NTt28+IqxNmJ5Wh
2XEnhQj/bvPEZQ9FBLdu
=4mEX
-----END PGP SIGNATURE-----

--EOHJn1TVIJfeVXv2--
