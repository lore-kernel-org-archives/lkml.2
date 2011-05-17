Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab1EQLM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 07:12:56 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54557 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149Ab1EQLMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 07:12:54 -0400
Date: Tue, 17 May 2011 21:12:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
        Xen Devel <Xen-devel@lists.xensource.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: linux-next: manual merge of the xen tree with Linus tree
Message-Id: <20110517211234.472e32f4.sfr@canb.auug.org.au>
In-Reply-To: <20110115120544.98a1f091.sfr@canb.auug.org.au>
References: <20110115120544.98a1f091.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__17_May_2011_21_12_34_+1000_WW=NwSEmwnG5MbzO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_May_2011_21_12_34_+1000_WW=NwSEmwnG5MbzO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jeremy,

On Sat, 15 Jan 2011 12:05:44 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the xen tree got a conflict in
> drivers/xen/Kconfig, drivers/xen/gntdev.c and include/xen/gntdev.h
> between various commits Linus' tree and various commits from the xen tree.
>=20
> As previously discussed, I have dropped the xen tree for today (as it
> contains an older version of the changes that were merged into Linus'
> tree).

Just wondering if the xen tree is ever going to make a reappearance in
linux-next?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__17_May_2011_21_12_34_+1000_WW=NwSEmwnG5MbzO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN0lgiAAoJEDMEi1NhKgbsWocH/27UodpEsWOZbpUz8FzjXHl/
71YtN6seVERwFXpM2HYuEv5w9Wo4FOZ22zZKwDKA700U37bLJt01AZLtZGgAIr02
IWNI0fMB15qNsFRuRmTQ1OXUnB6ig+ZGPccIzU6DKY1/Y/Bb2b+i1phdxUEzF/QT
pwe+C7HTVd6ucCev/CHVm0hF4A1XBhrJnlkY7GVDjixoMUEC3HLLVsMkddUuD3zi
swPJIT678uyyafBiTBKsYen+lAEvpSRCAXCtLAxT2HJ0HJ1S0si4f1eWXN1fEK/R
VA5hdyPo6iZvbETVbe7qniEJfNKW3Cz/frFW5Fz52WqTn69xrwCzrtT+eweIp5E=
=Muaa
-----END PGP SIGNATURE-----

--Signature=_Tue__17_May_2011_21_12_34_+1000_WW=NwSEmwnG5MbzO--
