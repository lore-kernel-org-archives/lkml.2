Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab0KRC1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 21:27:33 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36378 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459Ab0KRC1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 21:27:31 -0500
Date: Thu, 18 Nov 2010 13:27:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: Re: linux-next: build failure after merge of the final tree
 (wireless tree related)
Message-Id: <20101118132724.f7d21899.sfr@canb.auug.org.au>
In-Reply-To: <4CE3FCB5.6030909@oracle.com>
References: <20101117134820.bca8d764.sfr@canb.auug.org.au>
	<4CE3FCB5.6030909@oracle.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__18_Nov_2010_13_27_24_+1100_uU3AaCT5d.+tDB/k"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__18_Nov_2010_13_27_24_+1100_uU3AaCT5d.+tDB/k
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 17 Nov 2010 08:03:01 -0800 Randy Dunlap <randy.dunlap@oracle.com> w=
rote:
>
> On 11/16/10 18:48, Stephen Rothwell wrote:
> >=20
> > After merging the final tree, today's linux-next build (powerpc allyesc=
onfig)
> > failed like this:
> >=20
> > drivers/net/wireless/iwlwifi/iwl3945.o: In function `iwl_legacy_mac_res=
et_tsf':
> > (.opd+0xf00): multiple definition of `iwl_legacy_mac_reset_tsf'
> > drivers/net/wireless/iwlwifi/iwlagn.o:(.opd+0x90): first defined here
	.
	.
> > I should have known when I reported the warning ...
> >=20
> > Caused by commit dd0dd411f7178a20ea93a3cfa39123f078a07e25 ("iwlwifi: fix
> > modular legacy build errors").
> >=20
> > I have reverted that commit for today.
>=20
> Ack.  John, please drop/revert that patch.
>=20
> Sorry about the problem.

Looks like John removed it but the bluetooth tree (which is based on top
of the wireless tree) brought it back in by rebasing on top of yesterday's
wireless tree. :-(

I have reverted it again today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__18_Nov_2010_13_27_24_+1100_uU3AaCT5d.+tDB/k
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM5I8MAAoJEDMEi1NhKgbsnywH/jk3Z3lZRTCgBVT+VsHS3AvI
rKvE77UbvuXwk4QqYal+JJ3rjGolKLHmuXCfA1J3mUNXvKToT8Rbt0+TYtLWxmuM
Uc816uMzj3YesT3YCQ8fnIsQzsCFfm2YO4GpHbBcyiCmT2V2+kGUSMgKXipGTHtr
c/ui+2NILbEpqSUxQIXdTX8FnRngF6W3QSotNN6oSto4ZYZsEXWBEw55X0Nk/RTq
TDZA8p/fC7anmJXsuTrWm4CFQfi79QylaPrRdE/moWPUs5M8KLmFlwxDU/PeehdY
tTnhHNz8RcvUIIxD60W7qUohjFHsBjQO9LXv8DGETeXwTPcrp6rS7ODqoaf8aaM=
=/mdB
-----END PGP SIGNATURE-----

--Signature=_Thu__18_Nov_2010_13_27_24_+1100_uU3AaCT5d.+tDB/k--
