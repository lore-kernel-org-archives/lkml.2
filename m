Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab0EXHla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 03:41:30 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55586 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab0EXHl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 03:41:28 -0400
Date: Mon, 24 May 2010 17:41:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree (acpi
 tree related)
Message-Id: <20100524174123.87a33cc1.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LFD.2.00.1005240227580.8813@localhost.localdomain>
References: <20100524134105.6bd4e82e.sfr@canb.auug.org.au>
	<alpine.LFD.2.00.1005240227580.8813@localhost.localdomain>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__24_May_2010_17_41_23_+1000_6WBVRsiNvLYGw.F0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_May_2010_17_41_23_+1000_6WBVRsiNvLYGw.F0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

On Mon, 24 May 2010 02:31:25 -0400 (EDT) Len Brown <lenb@kernel.org> wrote:
>
> I've just now pushed fixes for those two build issues.

Thanks.

Can you pick up the gfp/slab.h updates patch I sent you the other day,
as well, please.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__24_May_2010_17_41_23_+1000_6WBVRsiNvLYGw.F0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv6LaMACgkQjjKRsyhoI8xfSACgrA7xIEFQw66pFyL4BTRA+dOQ
4toAn39v3N5z9IQmBNs77VfJqpyBR/ZR
=VsFE
-----END PGP SIGNATURE-----

--Signature=_Mon__24_May_2010_17_41_23_+1000_6WBVRsiNvLYGw.F0--
