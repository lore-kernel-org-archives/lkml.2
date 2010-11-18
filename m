Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760714Ab0KRV5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 16:57:53 -0500
Received: from ozlabs.org ([203.10.76.45]:52144 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769Ab0KRV5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 16:57:52 -0500
Subject: Re: [PATCH v2] iSeries: Remove unused mf_getSrcHistory function
 and caller.
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Jesper Juhl <jj@chaosbits.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.1011182044490.3651@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1010301911220.1572@swampdragon.chaosbits.net>
	 <1288609842.10671.7.camel@concordia>
	 <20101102071025.2fe5e6ca.sfr@canb.auug.org.au>
	 <alpine.LNX.2.00.1011012104050.12889@swampdragon.chaosbits.net>
	 <20101102082634.65342ce6.sfr@canb.auug.org.au>
	 <alpine.LNX.2.00.1011012218420.12889@swampdragon.chaosbits.net>
	 <1288657250.16790.4.camel@concordia>
	 <alpine.LNX.2.00.1011050026220.16015@swampdragon.chaosbits.net>
	 <alpine.LNX.2.00.1011182044490.3651@swampdragon.chaosbits.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4BJN8Wjt2wBvi4xzZk3M"
Date: Fri, 19 Nov 2010 08:57:50 +1100
Message-ID: <1290117470.29105.9.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4BJN8Wjt2wBvi4xzZk3M
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-11-18 at 20:45 +0100, Jesper Juhl wrote:
> On Fri, 5 Nov 2010, Jesper Juhl wrote:
> > =20
> >  static int mf_src_proc_open(struct inode *inode, struct file *file)

> PING.
>=20
> Is this going to get merged somewhere or is there a problem?

Yes, no.

It won't get lost:
http://patchwork.ozlabs.org/patch/70201/

cheers


--=-4BJN8Wjt2wBvi4xzZk3M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzloV4ACgkQdSjSd0sB4dJHIgCgyXtCb2bwWcKLFacEvA7LNsyp
aPoAn3Z2Z773EE8BQ3m1P3bi7dY/o6fi
=yvXG
-----END PGP SIGNATURE-----

--=-4BJN8Wjt2wBvi4xzZk3M--

