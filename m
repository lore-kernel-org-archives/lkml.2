Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab0C3IXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 04:23:47 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52158 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754727Ab0C3IXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 04:23:45 -0400
Date: Tue, 30 Mar 2010 19:23:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>, Tejun Heo <tj@kernel.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 09/17] pcmcia: update gfp/slab.h includes
Message-Id: <20100330192339.46d5d079.sfr@canb.auug.org.au>
In-Reply-To: <20100330065605.GA12764@core.coreip.homeip.net>
References: <1269885165-18617-1-git-send-email-tj@kernel.org>
	<1269885165-18617-10-git-send-email-tj@kernel.org>
	<20100329193203.GA8450@comet.dominikbrodowski.net>
	<20100330103129.b76a70e3.sfr@canb.auug.org.au>
	<4BB14D7B.4010602@kernel.org>
	<20100330063609.GA4498@comet.dominikbrodowski.net>
	<20100330065605.GA12764@core.coreip.homeip.net>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__30_Mar_2010_19_23_39_+1100_WVIfq3RvvWzy_UZ_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__30_Mar_2010_19_23_39_+1100_WVIfq3RvvWzy_UZ_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dmitry,

On Mon, 29 Mar 2010 23:56:05 -0700 Dmitry Torokhov <dmitry.torokhov@gmail.c=
om> wrote:
>
> Yes, I will roll teh relevant parts into respective patches if you don't
> mind.

Great, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__30_Mar_2010_19_23_39_+1100_WVIfq3RvvWzy_UZ_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuxtQsACgkQjjKRsyhoI8zNkwCfQCBCL9XhvBMIMspWfgDe0H9g
hBcAniV2p7gt32WdOxKuSfK7f0F5NMwP
=FNfQ
-----END PGP SIGNATURE-----

--Signature=_Tue__30_Mar_2010_19_23_39_+1100_WVIfq3RvvWzy_UZ_--
