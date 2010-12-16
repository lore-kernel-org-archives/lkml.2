Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320Ab0LPV6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 16:58:50 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:57309 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab0LPV6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 16:58:49 -0500
X-Spam-ASN: 
Date: Fri, 17 Dec 2010 00:58:38 +0300
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, "Nikita V. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCHv5 06/17] pps: access pps device by direct pointer
Message-ID: <20101217005838.130c2b0e@apollo.gnet>
In-Reply-To: <20101216155237.GC10333@enneenne.com>
References: <cover.1290599843.git.lasaine@lvk.cs.msu.su>
	<a17c3d890e34d2d0faf24a5b7ea6205cd7a86aa4.1290599844.git.lasaine@lvk.cs.msu.su>
	<20101216155237.GC10333@enneenne.com>
Organization: LVK
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/Gy262pM0N4d1ngPyv_r7vMK"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Gy262pM0N4d1ngPyv_r7vMK
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=D0=92 Thu, 16 Dec 2010 16:52:38 +0100
Rodolfo Giometti <giometti@enneenne.com> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> On Wed, Nov 24, 2010 at 07:15:44PM +0300, Alexander Gordeev wrote:
> > Using device index as a pointer needs some unnecessary work to be done
> > every time the pointer is needed (in irq handler for example).
> > Using a direct pointer is much more easy (and safe as well).
> >=20
> > Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
>=20
> Acked-by: Rodolfo Giometti <giometti@linux.it>

Thanks, Rodolfo!
I'll resend the patchset now with all your acks and other changes.

--=20
  Alexander

--Sig_/Gy262pM0N4d1ngPyv_r7vMK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJNCouOAAoJEElrwznyooJb9HIH/2YqnYuEq6Ik0bzAwlC1y+zA
Hj69kaYyuzUeTkgaDeI0Rv9W5cNVuFbx0hfni5BOPkHtdPz/FYPVBBtuQI2dgCJc
Uwonev0lBs4+txez1xrpAVSKJwgISKTT1SixB68o0zBDPK1cg7mxm8tkDTMAFe82
BV2KVwzf/1EHOTGFSPWvj4Dsh4Gsi0sXUPiGNluwAtZhMMVfOgQIHB+MRoRQ/wM2
2Igconf9fD/SVpk0B5uFEy8rQLp2rGnk9iY341j12gn1o/9Zf0AvMJ0eFn0S3O7j
wR0WjqDqC4FrwV4hGIQKraD+UGTZDGpb36PyaDXWmF9u2FxUBIqWkqaNf8srq88=
=pLk+
-----END PGP SIGNATURE-----

--Sig_/Gy262pM0N4d1ngPyv_r7vMK--
