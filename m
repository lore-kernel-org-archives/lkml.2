Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630Ab0ECEoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 00:44:46 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36996 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868Ab0ECEon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 00:44:43 -0400
Date: Mon, 3 May 2010 14:44:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
       yjwei@cn.fujitsu.com
Subject: Re: linux-next: build failure after merge of the net tree
Message-Id: <20100503144437.dda9df45.sfr@canb.auug.org.au>
In-Reply-To: <20100502.193756.106812290.davem@davemloft.net>
References: <20100503120847.e9328e75.sfr@canb.auug.org.au>
	<20100502.193756.106812290.davem@davemloft.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__3_May_2010_14_44_37_+1000_LHAWwNe9SWzHW2Is"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__3_May_2010_14_44_37_+1000_LHAWwNe9SWzHW2Is
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Sun, 02 May 2010 19:37:56 -0700 (PDT) David Miller <davem@davemloft.net>=
 wrote:
>
> Thanks Stephen, I'll do a merge of net-2.6 into net-next-2.6 and fix
> the build for you.

Thanks, that will help.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__3_May_2010_14_44_37_+1000_LHAWwNe9SWzHW2Is
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkveVLUACgkQjjKRsyhoI8xXfwCgv1A5DTnkoiJFCQubM8QuxIYV
aucAoLy511+gmhQmpTj2/pRITXEBgyhG
=3We8
-----END PGP SIGNATURE-----

--Signature=_Mon__3_May_2010_14_44_37_+1000_LHAWwNe9SWzHW2Is--
