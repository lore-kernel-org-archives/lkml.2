Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254Ab0EUAzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 20:55:21 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53476 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754991Ab0EUAzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 20:55:20 -0400
Date: Fri, 21 May 2010 10:55:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: minskey guo <chaohong_guo@linux.intel.com>, linux-mm@kvack.org,
       prarit@redhat.com, andi.kleen@intel.com, linux-kernel@vger.kernel.org,
       minskey guo <chaohong.guo@intel.com>, Tejun Heo <tj@kernel.org>,
       stable@kernel.org
Subject: Re: [PATCH] online CPU before memory failed in pcpu_alloc_pages()
Message-Id: <20100521105512.0c2cf254.sfr@canb.auug.org.au>
In-Reply-To: <20100520134359.fdfb397e.akpm@linux-foundation.org>
References: <1274163442-7081-1-git-send-email-chaohong_guo@linux.intel.com>
	<20100520134359.fdfb397e.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__21_May_2010_10_55_12_+1000_dmKoVdhhBYvCft9A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_May_2010_10_55_12_+1000_dmKoVdhhBYvCft9A
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Thu, 20 May 2010 13:43:59 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> > --- a/mm/percpu.c
> > +++ b/mm/percpu.c
> > @@ -714,13 +714,29 @@ static int pcpu_alloc_pages(struct pcpu_chunk *ch=
unk,
>=20
> In linux-next, Tejun has gone and moved pcpu_alloc_pages() into the new
> mm/percpu-vm.c.  So either

This has gone into Linus' tree today ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__21_May_2010_10_55_12_+1000_dmKoVdhhBYvCft9A
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEUEARECAAYFAkv12fAACgkQjjKRsyhoI8xHmQCUDkmYehloK9dIzgnFGC9c0USU
8QCfYkwGEe1GPduhl33b6nKkAJ+qW1c=
=hYuv
-----END PGP SIGNATURE-----

--Signature=_Fri__21_May_2010_10_55_12_+1000_dmKoVdhhBYvCft9A--
