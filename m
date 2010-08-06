Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934150Ab0HFAY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 20:24:28 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34603 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756530Ab0HFAY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 20:24:26 -0400
Date: Fri, 6 Aug 2010 10:24:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: linux-next: manual merge of the input tree with the s5p tree
Message-Id: <20100806102419.3e875933.sfr@canb.auug.org.au>
In-Reply-To: <20100722114655.1140fb61.sfr@canb.auug.org.au>
References: <20100722114655.1140fb61.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__6_Aug_2010_10_24_19_+1000_X+sJZW5aoIUSUG03"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Aug_2010_10_24_19_+1000_X+sJZW5aoIUSUG03
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 22 Jul 2010 11:46:55 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the input tree got a conflict in
> arch/arm/plat-samsung/include/plat/keypad.h between commit
> 1e3241300503df18a098dd35098f6975dcf622e2 ("ARM: SAMSUNG: Add keypad
> device support") from the s5p tree and commit
> 0fffed27f92d9d7a34de9fe017b7082b5958bb93 ("Input: samsung-keypad - Add
> samsung keypad driver") from the input tree.
>=20
> This just looks like two versions of the same driver (or two drivers
> sharing the same header) - please sort this out.  I have fixed up the
> header for today (by including both versions where necessary).

I got this again (something obviously changed a little) but the input
tree version is now in Linus' tree.  Please fix this up.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__6_Aug_2010_10_24_19_+1000_X+sJZW5aoIUSUG03
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEbBAEBAgAGBQJMW1YzAAoJEDMEi1NhKgbsG48H91G7QEqU4sHSnyYxUesgmsLk
XY24AGh4PRIjp3xy3nGRVR1IIKLjX0LHfo7L1wGuETAEmjtoLHtcLFoAySmu+MHt
DQQaz8uuUx1UFBboJf/sgr4xV2Y7HJ0XefVz6GxCy0MsHRqF8wTO5ILhPDht6b+N
9bzKsEaX1cO9AjcyscdFzMQhPuOLlhqipyN6BHjmPLctZViAsJRxcNtnyXyWuP6Q
3+5/BQHPajyPdPCyZLuSG1C9t/n3fmDjbw7UCmoYq9FbYq6wNpYf584NNMRFAqiS
TwCQNvsZGWskQC3SehVyWVzN10WL0K8ctmci4+C2cOWifFDQOiZvz20PimGKdA==
=8Dt9
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Aug_2010_10_24_19_+1000_X+sJZW5aoIUSUG03--
