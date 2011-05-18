Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab1ERVf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:35:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51225 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755031Ab1ERVfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:35:21 -0400
Date: Thu, 19 May 2011 07:35:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ian Campbell <ijc@hellion.org.uk>,
        Xen Devel <Xen-devel@lists.xensource.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: linux-next: manual merge of the xen tree with Linus tree
Message-Id: <20110519073512.6bd503b4.sfr@canb.auug.org.au>
In-Reply-To: <4DD3D8CA.90509@goop.org>
References: <20110115120544.98a1f091.sfr@canb.auug.org.au>
	<20110517211234.472e32f4.sfr@canb.auug.org.au>
	<4DD2C947.9050501@goop.org>
	<1305721938.20907.132.camel@zakaz.uk.xensource.com>
	<4DD3D8CA.90509@goop.org>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__19_May_2011_07_35_12_+1000_SZhuXQxuwpyNA6nB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__19_May_2011_07_35_12_+1000_SZhuXQxuwpyNA6nB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jeremy,

On Wed, 18 May 2011 07:33:46 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wr=
ote:
>
> On 05/18/2011 05:32 AM, Ian Campbell wrote:
> > Perhaps resetting your branch to some commit on Linus tree in the
> > meantime would mean Stephen doesn't have to see it everyday?
>=20
> Ah, good point.  I've reset it back to v2.6.38 for now.

Thanks for that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__19_May_2011_07_35_12_+1000_SZhuXQxuwpyNA6nB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN1DuQAAoJEDMEi1NhKgbsD90IAJe9V6cnakM2qldbPOrGvqM0
yF8mTk/by4E8CUrFjTzIoyAVBPWcU9zGo5onbYpel6PqFQU797Tb1UkNPwlvScuG
NpRVX9Efmlo5hxgJI+2S3lvJmAGe5Fnn50h2dFMGiGSRi3CBJVy6bSSzR9ViHcAQ
h9nJsRP2Fd3ee8N5GhNP96QUHYXY3VlKQWIjetKTBVh7Ar4phGeTZbYpBh746RjD
slWjDCji7AHgEcHOeMg4onNo60EFyM8aqs1+bwufLZX1aSq9qArzDGnLejBlZIh+
/HmDbBp0YLfjp+uWqMtnHCth/pNWojd5wEeCpA1GGI3gaw+EYF6RbAC3xOJVDa4=
=RorI
-----END PGP SIGNATURE-----

--Signature=_Thu__19_May_2011_07_35_12_+1000_SZhuXQxuwpyNA6nB--
