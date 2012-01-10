Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab2AJWfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 17:35:09 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:56709 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756549Ab2AJWfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 17:35:07 -0500
Date: Wed, 11 Jan 2012 09:34:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: linux-next: please update the i.MX tree
Message-Id: <20120111093457.af3caeabe2dbf50b70942334@canb.auug.org.au>
In-Reply-To: <20120110083020.GR5446@pengutronix.de>
References: <20120110115218.e00ab8c01abd5b9ae9a3b166@canb.auug.org.au>
	<20120110083020.GR5446@pengutronix.de>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__11_Jan_2012_09_34_57_+1100_ewBTBK0nYb7RKcxd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__11_Jan_2012_09_34_57_+1100_ewBTBK0nYb7RKcxd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sascha,

On Tue, 10 Jan 2012 09:30:20 +0100 Sascha Hauer <s.hauer@pengutronix.de> wr=
ote:
>
> On Tue, Jan 10, 2012 at 11:52:18AM +1100, Stephen Rothwell wrote:
> >=20
> > It looks like most (if not all) of the i.MX tree has been merged into t=
he
> > arm-soc (and Linus') tree, so could you please update the i.MX tree to
> > eliminate the conflicts I am getting.
>=20
> Did this. Sorry, I was not aware that there is something in this branch.

Did you push it out? I just checked and it hasn't changed. Just to be
clear, I am fetching git://git.pengutronix.de/git/imx/linux-2.6.git
branch for-next and it hasn't changed since last September.

Should I, instead, just remove that tree from linux-next and let you send
stuff just via the arm-soc (or arm)tree?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__11_Jan_2012_09_34_57_+1100_ewBTBK0nYb7RKcxd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPDL0RAAoJEECxmPOUX5FEUoMP/243xCqyxcWiRe4bL2bclcmB
7pS0RD9pQErxeO4atQ+HKtFnlNXhOPMjtvQDsx64oHBaOJnTDAA3bEt9buCw959R
rwPcjGaSXVJuU4uNdKZHPxAsNDpFQyDKgbNz22crQuzc4s1HjeBCfUqqVQDB4H9Z
VmWkE9bNxEMDdUb0slaShbA7a6LSQOnVlgIR68nM340yUgNYAKlJUaXgpr2ksATq
bcpE+IPCp2ZHOdWhKGWtEOEmYwlteQeO58Kx+AO2S8cfc0+sazVcNL/9MwzbIoPz
1HcjtdBh11j99bMvlG7VE/5F2L14Z9vbq5uYE8iKDa9f/WUsN26RMmpNBqgkehN7
QOoyR2WFlZ0Z94CsxB/dkn7HCHek1wGzyO8GIjCPKfeWmN8/EAFalFgVFDvtgcrJ
Qif0zcNs4DgHzGuidYWMIJ6vVhS75GXDY1IHe9ZtEmdcAKv+ltWLRLVoHojymZzg
ITwa2AJobpabL57keLiOTCDUy7fbVHhf0oNg4hRJ5MsdTjLfEaDh5bmeqVlTlXH/
Tx+dbWldWLm7QTfCQtO8EGnF9RvS9+ruttrFkZiDzhr0AlNKQg5itMqOA2zBka4A
Wlpnscf/3O7KfqbJ4a2/Mzo8Gpeiit1KlHJXIWCp2EPm8lHdireAzi+06HSOaGu/
96KAzY/JTifdvmpFyGKk
=yXMf
-----END PGP SIGNATURE-----

--Signature=_Wed__11_Jan_2012_09_34_57_+1100_ewBTBK0nYb7RKcxd--
