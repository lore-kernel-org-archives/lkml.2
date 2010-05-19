Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab0ESQbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 12:31:25 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34353 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723Ab0ESQbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 12:31:24 -0400
Date: Thu, 20 May 2010 02:31:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 10/17] wireless: update gfp/slab.h includes
Message-Id: <20100520023111.1755c938.sfr@canb.auug.org.au>
In-Reply-To: <4BF407C9.2020202@kernel.org>
References: <1269885165-18617-1-git-send-email-tj@kernel.org>
	<1269885165-18617-11-git-send-email-tj@kernel.org>
	<20100519190230.52385a65.sfr@canb.auug.org.au>
	<20100519144505.GD2412@tuxdriver.com>
	<20100520012829.709931dc.sfr@canb.auug.org.au>
	<4BF407C9.2020202@kernel.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__20_May_2010_02_31_11_+1000_QcFKjUYA.tF4B8sv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__20_May_2010_02_31_11_+1000_QcFKjUYA.tF4B8sv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

On Wed, 19 May 2010 17:46:17 +0200 Tejun Heo <tj@kernel.org> wrote:
>
> Yeap, I hoped that more of them would sort themselves out during devel
> cycle, but I guess rc1 window isn't too bad.

I have now reposted all the outstanding ones.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__20_May_2010_02_31_11_+1000_QcFKjUYA.tF4B8sv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv0Ek8ACgkQjjKRsyhoI8yCBgCgs8/xghUAHWQNxvUTZDf7Kzfe
vA4An2i3zlRxMHrELwxd1W/zkZvjfuLH
=nYmD
-----END PGP SIGNATURE-----

--Signature=_Thu__20_May_2010_02_31_11_+1000_QcFKjUYA.tF4B8sv--
