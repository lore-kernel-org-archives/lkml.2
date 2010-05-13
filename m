Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131Ab0EMBC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 21:02:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45253 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947Ab0EMBC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 21:02:56 -0400
Date: Thu, 13 May 2010 11:02:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: reinette chatre <reinette.chatre@intel.com>
Cc: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
       <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       "Berg, Johannes" <johannes.berg@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: linux-next: manual merge of the net tree with the
 wireless-current tree
Message-Id: <20100513110248.06cc6ee7.sfr@canb.auug.org.au>
In-Reply-To: <1273680943.2370.9533.camel@rchatre-DESK>
References: <20100512121539.8956720a.sfr@canb.auug.org.au>
	<1273680943.2370.9533.camel@rchatre-DESK>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__13_May_2010_11_02_48_+1000_RdT26GH2h/3z9OPG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_May_2010_11_02_48_+1000_RdT26GH2h/3z9OPG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Reinette,

On Wed, 12 May 2010 09:15:43 -0700 reinette chatre <reinette.chatre@intel.c=
om> wrote:
>
> Please note that this member of iwl_priv is now located in two
> places ... here and also in the device specific union a few lines up
> inside the _agn struct. In the code it is indeed the one in the _agn
> struct that is being used (see usage in iwl-agn.c), so adding this line
> is not necessary.
>=20
> This should not cause any problems with driver operation and can
> probably remain as such if indeed it is cleaned up somewhere else before
> it hits you again or linux-2.6.

Thanks for pointing this out.  I will update my merge resolution in
linux-next and I assume it will be done correctly when Dave or John also
do that merge.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__13_May_2010_11_02_48_+1000_RdT26GH2h/3z9OPG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvrT7gACgkQjjKRsyhoI8yKIQCdEdoBjymrK72iUFURllMjQUuW
bMkAn0DfK3r029BFvcXcsqJbZEhf1OLD
=eWUG
-----END PGP SIGNATURE-----

--Signature=_Thu__13_May_2010_11_02_48_+1000_RdT26GH2h/3z9OPG--
