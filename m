Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab0ESP2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:28:38 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48905 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565Ab0ESP2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:28:37 -0400
Date: Thu, 20 May 2010 01:28:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 10/17] wireless: update gfp/slab.h includes
Message-Id: <20100520012829.709931dc.sfr@canb.auug.org.au>
In-Reply-To: <20100519144505.GD2412@tuxdriver.com>
References: <1269885165-18617-1-git-send-email-tj@kernel.org>
	<1269885165-18617-11-git-send-email-tj@kernel.org>
	<20100519190230.52385a65.sfr@canb.auug.org.au>
	<20100519144505.GD2412@tuxdriver.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__20_May_2010_01_28_29_+1000_wPx7j2PANUtaX4m2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__20_May_2010_01_28_29_+1000_wPx7j2PANUtaX4m2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

On Wed, 19 May 2010 10:45:05 -0400 "John W. Linville" <linville@tuxdriver.c=
om> wrote:
>
> Looks like this was part of a series...who merged the rest of it?
> I guess I presumed they would take care of the series.

It was a series of patches that were only relevant to the trees in
linux-next (for a change that happened in Linus' tree).  My hope (and I
assume Tejun's) was that each maintainer would take the patch relevant to
their tree (some did - I just checked I still have 10 of them being
applied to linux-next :-().

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__20_May_2010_01_28_29_+1000_wPx7j2PANUtaX4m2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv0A50ACgkQjjKRsyhoI8zDfACgqxKIp4o4khBMYX5n3cQ2W0PO
cqEAn3Huwu/uoOBuX22soA8XCTThDKHS
=kqur
-----END PGP SIGNATURE-----

--Signature=_Thu__20_May_2010_01_28_29_+1000_wPx7j2PANUtaX4m2--
