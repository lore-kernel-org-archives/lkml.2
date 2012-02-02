Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab2BBQ7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 11:59:55 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:28284 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab2BBQ7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 11:59:53 -0500
Date: Thu, 2 Feb 2012 20:01:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Pawel Moll <pawel.moll@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: params: <level>_initcall-like kernel parameters
Message-ID: <20120202170125.GU3356@mwanda>
References: <20120202095612.GA30632@elgon.mountain>
 <1328180937.1888.18.camel@hornet.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H/DU/KGSZaQxued3"
Content-Disposition: inline
In-Reply-To: <1328180937.1888.18.camel@hornet.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090201.4F2AC101.006D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H/DU/KGSZaQxued3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 02, 2012 at 11:08:57AM +0000, Pawel Moll wrote:
> You're right, of course! The initcall_level_names is missing "early
> parameters" string as the first element of the array. Well spotted - may
> I asked what tool did you use to get this message?
>=20

It's a Smatch thing, but it requires the database to be set up
first.  It's a new-ish feature.  I should clean up my build scripts
and publish them...

regards,
dan carpenter

--H/DU/KGSZaQxued3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPKsFlAAoJEOnZkXI/YHqRC2wP/2seOVO9W3zzPJkGq8SLaJ5G
iub65rQthAGhW3qWc++ODNQwpofAZMlXyTmVU3vmVZg5YqmnbabjKwZdOp+UMOio
pSuwG4LNcfjwybUL7URW3tnmnrE3zJJJrMOuGfVfgvgwQAsPscfupp5wCherMHnN
CnGtBGQV/j7iHCx6mClMSZTo9RTWHz6VE48L4CugA+JUQXADCuuHSJrshLQsqBSS
d0JuP/fgzlMwsXi3qE5cnmzjTBvd/rQjM8sPU2tMt5ji51qaeAytvsiv747/16iR
7iMYN7cznavFk+CdCgHdfrdmqPxRt7bwhcp952yANmbtFxic48nzdnLRg+47uk+T
VWQgByBK8B3g8r/ySvVz3GTRwIKg8nDlFSSnU1jRxKAXJuyprkN1TxLR6+fjbT7E
egz6bOtqAagRsPOVZWpYV2vPh0eXukwEWBDlgDDpKeIIquLj0pZfcGyPAMZjkXtk
vnhz3ZoKPxnJxspgz0w6sogS19pAxnePCo71W+Xv1soXFFtNOh85m3rWRtWJclq6
GvvOOePofuQAPu/Qv91xFNX0ReEXNpABZCrM/4dsTEln6JMk0Xazj1p5gzMCtmfj
/MmrsM9zWHENUEY0htWk+GgJ0FFvAZxpgoWW0jUV4HY6NsJjX8NDQPJshVI2AdsS
wTRRUX7FBGxXMYh8+Rpe
=S+8H
-----END PGP SIGNATURE-----

--H/DU/KGSZaQxued3--
