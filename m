Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250Ab1GZFPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 01:15:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60274 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000Ab1GZFPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 01:15:03 -0400
Date: Tue, 26 Jul 2011 15:14:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: linux-next: manual merge of the writeback tree with the vfs
 tree
Message-Id: <20110726151451.e3385a5d969fddc210f186f8@canb.auug.org.au>
In-Reply-To: <20110726045812.GA32517@localhost>
References: <20110718173409.2885649b65937eb7caecf943@canb.auug.org.au>
	<20110726045812.GA32517@localhost>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__26_Jul_2011_15_14_51_+1000_u4KYhRIfrCAiQlPL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__26_Jul_2011_15_14_51_+1000_u4KYhRIfrCAiQlPL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, 26 Jul 2011 12:58:12 +0800 Wu Fengguang <fengguang.wu@intel.com> wr=
ote:
>
> What should I do with the 2 conflicts for upstream merge?
>=20
> I noticed that Linus just merged the vfs tree. So the obvious thing I
> could do is to rebase writeback.git to Linus' tree and fix the
> conflicts, and then ask Linus to pull the rebased writeback tree.
>=20
> Or are there better practices?

Normally you just ask Linus to pull your tree and let him know that there
are some conflicts and also ask him to let you know if he wants you to
fix them up before merging.  He is a smart fellow, and if I worked it out,
I am sure he can as well.  :-)

Some people pull Linus' tree into theirs and resolve the conflicts, but
he prefers to do them himself usually.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__26_Jul_2011_15_14_51_+1000_u4KYhRIfrCAiQlPL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOLk1LAAoJEDMEi1NhKgbsIaEH/0jr1uBjCJwAWQJVZ5k8A020
WmeU0hWINNNMTzkC0N8tY0UmOvCRbm6pUiUfqliCeVCBhYp6oCHD/lHjGC53Za+u
iVWT0POEy/ZePazG7G2cYIivwH69xK8cK78UtVoifcrTVVwNffrowV9uqemyygFJ
Vu4aguLYyNn1pf79quxK0O388Sr1SIXP3I1varRWB14aPnwf7AmqTVxMccVhktmX
zZZYKeBDKS3n2ynmvOjgmC521/5eMsiYsaYavQRwLhCRWdVBubCBRyO95Bp8IKKp
lq+mjt+4rwFEMklIxaxt3cJk2rQuR4iG/9GxKcoe4hKO43DxwjANJTwniHGO3x8=
=EQ2p
-----END PGP SIGNATURE-----

--Signature=_Tue__26_Jul_2011_15_14_51_+1000_u4KYhRIfrCAiQlPL--
