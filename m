Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750946Ab0EZEJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 00:09:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42738 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727Ab0EZEJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 00:09:06 -0400
Date: Wed, 26 May 2010 14:09:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Subject: Re: linux-next: build warning in Linus'tree
Message-Id: <20100526140900.5b091c16.sfr@canb.auug.org.au>
In-Reply-To: <20100525182040.f1882d0a.akpm@linux-foundation.org>
References: <20100526110506.f2f4f22c.sfr@canb.auug.org.au>
	<20100525182040.f1882d0a.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__26_May_2010_14_09_00_+1000_qSTmVapZ+=n.z0JG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__26_May_2010_14_09_00_+1000_qSTmVapZ+=n.z0JG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Tue, 25 May 2010 18:20:40 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> hmpf.  Does this fix?

No.

The problem is that __LITTLE_ENDIAN is only defined in
linux/byteorder/little_endian.h which is only included by little endian
architectures ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__26_May_2010_14_09_00_+1000_qSTmVapZ+=n.z0JG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv8ntwACgkQjjKRsyhoI8xBRgCgjVtlDbkd15QAIRph9wkC8zIs
IzkAn1xDGJbmMTMr6Wk1yswYPuMgRD5p
=vrnU
-----END PGP SIGNATURE-----

--Signature=_Wed__26_May_2010_14_09_00_+1000_qSTmVapZ+=n.z0JG--
