Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab2BPXaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 18:30:25 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:58976 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026Ab2BPXaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 18:30:23 -0500
Date: Fri, 17 Feb 2012 10:30:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Yuval Mintz" <yuvalmin@broadcom.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, eilong@broadcom.com,
        eric.dumazet@gmail.com
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
Message-Id: <20120217103011.b2223e28a89839d09a4a4053@canb.auug.org.au>
In-Reply-To: <1329391450.16698.27.camel@lb-tlvb-eilong.il.broadcom.com>
References: <20120216123803.8efe3d23eee5c3a80aceef61@canb.auug.org.au>
	<1329391450.16698.27.camel@lb-tlvb-eilong.il.broadcom.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__17_Feb_2012_10_30_11_+1100_qVTHZNImqUhwVK3/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Feb_2012_10_30_11_+1100_qVTHZNImqUhwVK3/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, 16 Feb 2012 13:24:10 +0200 "Yuval Mintz" <yuvalmin@broadcom.com> wr=
ote:
>
> I don't fully understand your merge - it seems to create a mash between
> the "bnx2x: fix bnx2x_storm_stats_update() on big endian" patch in net,
> and the "bnx2x: consistent statistics after internal driver reload"
> patch in net-next.

That is exactly what the merge conflict resolution did.  i.e. the patch
you supplied below is not needed in linux-next because that is
effectively what I did.  It is the same as Dave will do when he merges
the net tree into the net-next tree as well, I assume.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__17_Feb_2012_10_30_11_+1100_qVTHZNImqUhwVK3/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPPZGDAAoJEECxmPOUX5FELbMP/ji5hCU6x69EkPJpjn8jy7Nx
+hF802yCYxJgdg+dtnm2nWYKtHJbpVhFlov++Gm/U632LkltXhne/stdtXkpfUCy
huEAr5wYWcRCLScNkQ3Dy3AFN1BQkmUo5L9J/XWyGgK2Sv+poEdchOIXvqgdITJP
EPtqAACAaFWc130LGZiephxycO9nBj+6SV/N05c345pWPGOUobPWlT3v/cN83ETx
sH89WYLDyutyMoH3dG43fr77iKze+xVjoxTT/j+nV161QLphf00M+LfZ5RYEWUbS
FIWHtrzUblBxu3zonZ3IKC76goKsGygXrjL6+jokqASEqGsr77SpHmU7Ee4qlFJ9
YzJuu8mYXFf9UzrdiCWyJg5fYtHcSqTAdft40wSTWIcojhTXIvJIICHmddlIvLv2
mv2y0mxiw76M8EYHfXyO3b/fFWfhLlPvIGr9A++e6PJYtSeuoduAn6t4lejIOves
TyJ9ty3GMYcIpaQ6tT1k3vUEkuc+db8c5srlavTI3GV5/WBPJIXxx1xMePYBYTQX
SOOI8AMuqQ51zwcF6sxIqI8vRSzTlT1mbw0cnkwyYnZ71fYt0XZLtuwTI7ep4vki
JVzn8YwdD2BmyPhtTUhMkT8GBA+Aljf8Ha1cddU4kZqmSG4FkDBo3Jrygx7uusVL
ephc5i/DxLPstpyzKMcI
=6nhC
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Feb_2012_10_30_11_+1100_qVTHZNImqUhwVK3/--
