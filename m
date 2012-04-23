Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab2DWGtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 02:49:11 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42427 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748Ab2DWGtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 02:49:09 -0400
Date: Mon, 23 Apr 2012 16:48:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Ben Dooks <ben-linux@fluff.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Sumit Semwal <sumit.semwal@linaro.org>, Rob Lee <rob.lee@linaro.org>
Subject: Re: linux-next: clean up time
Message-Id: <20120423164859.082b5c53b5d9bd9a524ec864@canb.auug.org.au>
In-Reply-To: <20120402112009.3477dad7deff0f4d87f49b29@canb.auug.org.au>
References: <20120402112009.3477dad7deff0f4d87f49b29@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__23_Apr_2012_16_48_59_+1000_gS5ke6Py16BsgN4J"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__23_Apr_2012_16_48_59_+1000_gS5ke6Py16BsgN4J
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 2 Apr 2012 11:20:09 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Can people please clean up stuff in their trees that has been merged by
> their upstream.   This is especially useful where the upstream merged (or
> applied) a slightly different version of their tree.

There is still much cruft in the linux-next included trees ... The
following trees appear empty (relative to Linus' tree) but cause conflicts:

bjdooks-i2c
xen
dma-buf
cpuidle-cons

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__23_Apr_2012_16_48_59_+1000_gS5ke6Py16BsgN4J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPlPtbAAoJEECxmPOUX5FEoCsQAKT6k2HQFywvsFfXeOJcDKWb
uWGyArrjRt8RKSPbCVQuGrzkQkC7AFHINAigm/8YQ3hwJX7++z5MPmUhNgIjzdFN
ZFN5+FbMBDERI7yuiYXMapUjx/13nSntbanAlCT2+9Na3RKFdzXi2gz+VEbzOiYs
UmYuXIRgsuhBYiclG68wI+eotRv8GU5qbje06GrlRwBIGOgsBywtvRwc2pzfwGTT
Uc2xmb5+EIy3XLgmp/d03I9nuxoLihNdSPoOR228/LCgdIILBFb2D+ZihMa5yU6a
l9S4wMRI+E1dsLbmAHCHgEanoTxtXCfnjdRTKmFBtAzBV+eaAG4RB1BOCvqdFsRN
NDLFIcDC/WvbLymk31l1nx4rAFE9IiE1H0cyFy3lEKpTBlT9EVYc9H4/l7p0Q3JH
tKaAc9kDQCDCK1Fne/SMknEpvzcHRyjvjjvstNpMyfP4+9dhTeS3wprjWC7tvfoa
Kt5NyWvDf5Lll118xrXXEBQpGoys03orll1Fi3ki7i7kzPu+NdwTYqKQGVu2HxAi
P5WSvNVntJrp1vgHHsHGoujzMmj3o2jjXHuFwYwlcDTtQws6BsIaPW785FtoHGQ+
gEiQeykb0h/HRq7jEuzsfUtd+u6yLr5gwos1TBrnX13yA/1Qbe7R7WUidgwxy4E9
6kMnejc7wy0pTyJ0HGVD
=pV7+
-----END PGP SIGNATURE-----

--Signature=_Mon__23_Apr_2012_16_48_59_+1000_gS5ke6Py16BsgN4J--
