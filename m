Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab1LLE0Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 23:26:16 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:38891 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab1LLE0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 23:26:15 -0500
Date: Mon, 12 Dec 2011 15:26:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-Id: <20111212152601.e03fe38dc6606f70d86a1cef@canb.auug.org.au>
In-Reply-To: <20111208214744.19117662.akpm@linux-foundation.org>
References: <20111209160856.d1f8de40a6d415cd5d9cafc7@canb.auug.org.au>
	<20111208214744.19117662.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__12_Dec_2011_15_26_01_+1100_WRdmvxpXZhEjoG7p"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__12_Dec_2011_15_26_01_+1100_WRdmvxpXZhEjoG7p
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Thu, 8 Dec 2011 21:47:44 -0800 Andrew Morton <akpm@linux-foundation.org>=
 wrote:
>
> I suppose this is a good enough fix for that:
>=20
>  include/linux/mempolicy.h |   10 ----------
>  mm/mempolicy.c            |   12 ++++++++++++
>  2 files changed, 12 insertions(+), 10 deletions(-)

OK, I applied this to the akpm tree today.

> > I have reverted that patch for today (and the following trivial patch
> > "cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nod=
emask-fix-2-fix").
>=20
> And I'll drop that one now.

And dropped that one.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__12_Dec_2011_15_26_01_+1100_WRdmvxpXZhEjoG7p
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO5YJZAAoJEECxmPOUX5FEGJcP/37OOtW6o3XKML3r06nIu6X8
KsQMtey0pfLOa/SetJgc472c925cgXCEAdoDaM3pXMZL731pIvk/AIFJq8x9KGDK
+1cTKpN3OFyWRyfJnKH5SatXro8A+F92Gs/ZOFeuPSox9gtKJ5iqoxaehMFa69ry
BXP8nwrIi5Kx1m0x4AhgU68cqtP0xt2sAA05C5bp2rHSKQ1tZdjLNZRUMpPP+D1v
EaxQoSXcJJr4ts1bS1hYoMU34nuxbEtEaYjB7/mKjX/KY60xJ1pfMEBEpCTJx4M/
tzyWb+WoE8eSmjRxzdFkdmkbeedUyipfls8lviGd2n3JGShsSiXAZbJrbcqMAowx
9GaYmPq3Sdu9MB/eVLQb/ELTlAcPDX+0+WKEMEMiGgEldSxDUpDi1praZ/eYKFMh
Y4vGfDrwLhLmy8CI0pFSbuK7gVTt9hgnRsbZRd0R5ttb9m2BI7p6dy36Nowzckqs
YlM9awiw4+57+ZFkiPMRZ2ysItfmnr3JSOL0kyXTtFMIe/jnXzAtVoAHflweij2b
oQzxegTSQ8bTguH8lw/jEA0NqtH8PHrIUXgmg6d7yZEt/eEnG9qi0S+pALy50NF/
dfaNoLEyWYh8GT2yXs2veh3f0KmO/auSEfiUsTJqY4V8lulxbEhIqSlQmi1RgKMx
mLkxiXMkpAHBnlnF2Hcc
=CR4K
-----END PGP SIGNATURE-----

--Signature=_Mon__12_Dec_2011_15_26_01_+1100_WRdmvxpXZhEjoG7p--
