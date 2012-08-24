Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab2HXGTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 02:19:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:44502 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756005Ab2HXGTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 02:19:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,302,1344236400"; 
   d="asc'?scan'208";a="184868782"
Message-ID: <1345789460.2848.249.camel@sauron.fi.intel.com>
Subject: Re: linux-next: build failure after merge of the ubi tree
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 24 Aug 2012 09:24:20 +0300
In-Reply-To: <20120824113439.6fdb432e7d6057b3fae27d3f@canb.auug.org.au>
References: <20120824113439.6fdb432e7d6057b3fae27d3f@canb.auug.org.au>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-dKtEwZ6BzLO6pY5cVa1Y"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-dKtEwZ6BzLO6pY5cVa1Y
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-08-24 at 11:34 +1000, Stephen Rothwell wrote:
> Hi Artem,
>=20
> After merging the ubi tree, today's linux-next build (x86_64 allmodconfig=
)
> failed like this:
>=20
> drivers/mtd/ubi/build.c: In function 'io_init':
> drivers/mtd/ubi/build.c:658:3: error: 'mtd' undeclared (first use in this=
 function)

Thanks Stephen, fixed, sorry for the breakage.

--=20
Best Regards,
Artem Bityutskiy

--=-dKtEwZ6BzLO6pY5cVa1Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQNx4UAAoJECmIfjd9wqK0aO0P/RDDnUkxtdyojUlk+73uoBG6
m+EKcULpWrItWyg49xuXqkHhjt015GwOvmz/w+2PPzDYrPOAz1rd72QqVun/3oli
5o1ygxr+uZ2HjNT+4UhuwwXaaEIWy//jkboTfwaWvRMrGGIWfuG7hbnpLLLmu8iw
0mhYO8v99eDiXMhVrlFpO+ZihkzoBu6bmEt21hk892Oqkb9+Qazu5cca+b5UekAy
814prbZaiGmDHM8J0nkECb8CeMX73zge4clkKNw4M1VyNxTWUx/e96DbaEsX5Edt
mGVsbhDxjmDvUE5kV3MQxXdMfXCZKpXdLSL1VYJREHHoz3SdWEpuyrmBaqDntTXp
dJF0GpkQET/NicDd8kb9vyIuk7dYFQBEmdE4VBi85psiKEap14rThCenhKyx8o5T
mevqZmmApWaf47tLt1w2ZvRxAX9TRUkW5aVrFGxdefkskpSDaI0DPy6W1EfLt4xf
ZpZmpq9+ke+nyzJUiqqgmAKFf+sTvvkzhlxow+OC+DG3oDW5kG7rCRX8u84JMm5h
xoNgAHSvSwuMviHoOtcxNVC3VRinFQNof7K8t6pXvs2/9/Th7z9CwwdsF/ITCLwg
BL6G47MIDdPQZb+ertVb7jgbmkyiym9xWA3JDFEMb1fGfrby+z8EorSDGwZUqCE5
QDiWogHemdG21sGZqf6z
=Ng61
-----END PGP SIGNATURE-----

--=-dKtEwZ6BzLO6pY5cVa1Y--

