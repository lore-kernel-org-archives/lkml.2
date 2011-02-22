Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582Ab1BVFaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 00:30:24 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41855 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316Ab1BVFaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 00:30:23 -0500
Date: Tue, 22 Feb 2011 16:30:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Venkateswararao Jujjuri (JV)" <jvrao@linux.vnet.ibm.com>
Cc: Eric Van Hensbergen <ericvh@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the v9fs tree
Message-Id: <20110222163016.aac65a7a.sfr@canb.auug.org.au>
In-Reply-To: <4D63479F.3060603@linux.vnet.ibm.com>
References: <20110222115340.da48b908.sfr@canb.auug.org.au>
	<4D63479F.3060603@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__22_Feb_2011_16_30_16_+1100_u4pApsgCM/RGPsrE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Feb_2011_16_30_16_+1100_u4pApsgCM/RGPsrE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, 21 Feb 2011 21:20:31 -0800 "Venkateswararao Jujjuri (JV)" <jvrao@li=
nux.vnet.ibm.com> wrote:
>
> On 2/21/2011 4:53 PM, Stephen Rothwell wrote:
> >=20
> > After merging the v9fs tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> >=20
> > ERROR: "p9_payload_gup" [net/9p/9pnet_virtio.ko] undefined!
> > ERROR: "p9_nr_pages" [net/9p/9pnet_virtio.ko] undefined!
> > ERROR: "p9_release_req_pages" [net/9p/9pnet_virtio.ko] undefined!
>=20
> These functions are defined by commit 249951bf66816128a7698caa826425e2994=
94c82
> ([net/9p] Preparation and helper functions for zero copy)

Yes, they are - but they are not exported to modules.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__22_Feb_2011_16_30_16_+1100_u4pApsgCM/RGPsrE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNY0noAAoJEDMEi1NhKgbsvCgH/2CkVR+842yOk2nlgDw92+8g
oGX5uSdOBKXzt0yy31FT1UN0PorMbOt5A+aLq1OaVS7caVfxyn5OSfr5ngPLyqYK
ZH9zPEevU411JNy+QcLjXsTXSmwW8u3vewc4v6y8c48rgUdM16YIFdaUeoTPWImv
MeAK38lC0dMmcpFn6u74RJS+L+0AzW4pSh0bIBW1w0Qj1QHcG/RO1O5r+g5TTolu
n6zvHpF0GHxGOUhxZvOoygG/1RVBO4ni5OGtDpnmb01Fimfr5TFuMrLWTBAkbIDO
SB2n8O63JoInnMJUKVLSi/2sFUndW44CIbmmdzYoCLA3kl2VVun2E31CMKfrgJc=
=kjZC
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Feb_2011_16_30_16_+1100_u4pApsgCM/RGPsrE--
