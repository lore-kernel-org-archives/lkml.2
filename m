Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993Ab2AKDCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 22:02:32 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:46751 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab2AKDCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 22:02:31 -0500
Date: Wed, 11 Jan 2012 14:02:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sage Weil <sage@newdream.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alex Elder <elder@dreamhost.com>
Subject: Re: linux-next: manual merge of the ceph tree with Linus' tree
Message-Id: <20120111140218.269abb02376954da5ef09a81@canb.auug.org.au>
In-Reply-To: <Pine.LNX.4.64.1201101732330.15859@cobra.newdream.net>
References: <20120111122744.7db3bfb91d79b1307db02228@canb.auug.org.au>
	<20120111013127.GE23916@ZenIV.linux.org.uk>
	<Pine.LNX.4.64.1201101732330.15859@cobra.newdream.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__11_Jan_2012_14_02_18_+1100_EzdhmxUA/H556H1N"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__11_Jan_2012_14_02_18_+1100_EzdhmxUA/H556H1N
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sage,

On Tue, 10 Jan 2012 17:35:36 -0800 (PST) Sage Weil <sage@newdream.net> wrot=
e:
>
> BTW, should I let Linus resolve this, or merge his master back into my=20
> tree, or rebase onto his master?

Let Linus resolve it (giving him a hint if necessary).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__11_Jan_2012_14_02_18_+1100_EzdhmxUA/H556H1N
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPDPu6AAoJEECxmPOUX5FE/NgP/j0Vur4HCUP+Oqil9DoFgv/y
74WxYuQWBtCfgR0YvkKQSiC189ZwlnUHRMQYnAYrmF882Vm2JlSI+7YdUVjIXnC6
RenmDkNFM3W8EO308zkmDfrP+l7L4MVU4njBdWRaILZoJOo5ALhD+Un3JtU95Sr8
fGJXqNkTouZCWZlqePtn/JgIDxxc8XwpMZ1k/8GGufy6icVB7WmfddnrsIF6mZQw
BThSn8vrQwEtZZbrlgC7V8fi776EAPXh9z29PdnPdaEZqRAEa8NXkyVfS19TZQ1B
mQY/g8AlBYtei0ssM3wWnSUGXlnmmMq8G8RHc4SZlTIkDVxzikK0BUFCxxA1ZB2k
MlwViE0fMn5jyyPv0zHSls3rbTOh9CuooZQkZqEKL+TYtllffqn2gEl+mIQIUgcF
NR445saKJjzM0i465gyxVBf7kFnWk9Ju2/SMYw2+LPWeC4yvQp4O4N59hbIk4An6
24xxyw3OQht5+nI5vT9VJ4PNV2EFGwFc44O5o4qL+Z3qNKM2oMJ4gdRZbZUwUGoa
DQbGzueIRqbn2OvPgVUGvzmk/MDqexn+1vhSXtoV078NGv7wHYSmXnM3rhCABbNM
j+8cALPKuptTXZzB4ICbxz7cIeWzvgbjVipxqX8cUYxlNjEflrnT2/JluyfQQJFX
jItctPt9LYuEvDMHy2nI
=PGO5
-----END PGP SIGNATURE-----

--Signature=_Wed__11_Jan_2012_14_02_18_+1100_EzdhmxUA/H556H1N--
