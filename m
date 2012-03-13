Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab2CMPNa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 11:13:30 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38919 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930Ab2CMPN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 11:13:27 -0400
Date: Wed, 14 Mar 2012 02:13:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: dedekind1@gmail.com
Cc: Stefan Roese <sr@denx.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Joe Perches <joe@perches.com>
Subject: Re: linux-next: manual merge of the l2-mtd tree with the vfs tree
Message-Id: <20120314021312.c15dc02ec501ceb0d98ea755@canb.auug.org.au>
In-Reply-To: <1331649633.3595.70.camel@sauron.fi.intel.com>
References: <20120313141859.302878a8e2246979c288440d@canb.auug.org.au>
	<1331649633.3595.70.camel@sauron.fi.intel.com>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__14_Mar_2012_02_13_12_+1100_k4mCqHIMRSSyf8w7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__14_Mar_2012_02_13_12_+1100_k4mCqHIMRSSyf8w7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Artem,

On Tue, 13 Mar 2012 16:40:33 +0200 Artem Bityutskiy <dedekind1@gmail.com> w=
rote:
>
> Thanks. Although I do not see the latest l2-mtd.git tree in the master
> branch of linux-next, I see some old version of it. E.g., the jffs2
> changes are not there.

I just checked and the master branch on
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git is
8ca39b0 "Add linux-next specific files for 20120313" as I would expect it
to be and the top of the l2-mtd tree that was merged into that is
4331c79c6895 "mtd: do not use plain 0 as NULL".

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__14_Mar_2012_02_13_12_+1100_k4mCqHIMRSSyf8w7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPX2QIAAoJEECxmPOUX5FE7pUP/ju0+CrNXU7lShyOk+8xE9xy
e6TPV2+3iqtKrtWTLP8hHFdfDwmDxuwbeOZv25otsJ8L/pT+9TFzUMevxHKrK1P+
LI5U9N69+NBcNKmWMVN4FRR2bh5OD95BHOLTgRtYRX19WSa4K3sDt44BMMdArN/D
oHXBfgKNVlgYCxAkAwGsBP3tfrpjygpM7cJQ72HlMnHzoZ00PAIkfELby/Ly1rbL
xQN1LjuvG9Tncz+bMrwie7C35QHhUeZMlvZ+fbtYMeXAzwOg9l308CAgInY7YbnQ
8lTXryqq+VPYrHZ7Xliq9tfZ3tLjae58L9XjrC9bAhbp8UbESk6TpbZ3WO2sjNH3
7NdH/i/zm+LtQhnuJlIbTWGdWPuO5+E2udQxWT2xUrr+XKA+ZBdVfRKHLVS0VYBU
dEHCXPpOtJVSm/pzdV3M1h//5E7/Q8CsCZIlrcqF0EYvNuJj/9rvDjLfOMgUeSkT
YSEMLuxqPsX/hK/ih2MV7wnsCtxQyE1xbTUhUfeD6TwTKHoraD3wT09FjPPWG5aB
8BLLzqH8iXIvo/ApHw164wXTzX8+7P+mnBvRPb9AIGo+x66gTi7Bm9Z59K1kjs2b
AERcaSb0xbzwLctTrAx8HcH1SJe03ho07tAuVMBxtkDo3R1aHV3xRcxnmgvjr3fQ
W7SLt2dOagRRuZSYIU2y
=5BjG
-----END PGP SIGNATURE-----

--Signature=_Wed__14_Mar_2012_02_13_12_+1100_k4mCqHIMRSSyf8w7--
