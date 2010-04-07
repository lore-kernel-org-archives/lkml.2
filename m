Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab0DGF2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 01:28:22 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56062 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091Ab0DGF2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 01:28:16 -0400
Date: Wed, 7 Apr 2010 15:28:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, dm@chelsio.com, jpirko@redhat.com
Subject: Re: linux-next: build failure after merge of the net tree
Message-Id: <20100407152809.b684539e.sfr@canb.auug.org.au>
In-Reply-To: <20100406.201220.195404728.davem@davemloft.net>
References: <20100407125817.e8e1d174.sfr@canb.auug.org.au>
	<20100406.201220.195404728.davem@davemloft.net>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__7_Apr_2010_15_28_09_+1000_JuKlPbJam7eVql12"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__7_Apr_2010_15_28_09_+1000_JuKlPbJam7eVql12
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Tue, 06 Apr 2010 20:12:20 -0700 (PDT) David Miller <davem@davemloft.net>=
 wrote:
>
> Thanks, I'll merge net-2.6 into net-next-2.6 and fix this build
> failure in the latter.

Thanks for that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__7_Apr_2010_15_28_09_+1000_JuKlPbJam7eVql12
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAku8F+kACgkQjjKRsyhoI8xzHgCgoC2XN98m9GqOV0sh9JJts055
izcAni41W+NnfZDxmgFrm4/lWY2VbUDl
=YCBT
-----END PGP SIGNATURE-----

--Signature=_Wed__7_Apr_2010_15_28_09_+1000_JuKlPbJam7eVql12--
