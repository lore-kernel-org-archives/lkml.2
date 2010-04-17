Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab0DQRoP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 13:44:15 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:45404 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab0DQRoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 13:44:13 -0400
Date: Sat, 17 Apr 2010 21:44:05 +0400
From: Eric B Munson <ebmunson@us.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-rdma@vger.kernel.org, rolandd@cisco.com, peterz@infradead.org,
       pavel@ucw.cz, mingo@elte.hu
Subject: Re: [PATCH] ummunotify: fix umn-test build
Message-ID: <20100417174404.GB3579@us.ibm.com>
References: <1271053337-7121-1-git-send-email-ebmunson@us.ibm.com>
 <20100414094341.ba69842d.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Yylu36WmvOXNoKYn"
Content-Disposition: inline
In-Reply-To: <20100414094341.ba69842d.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Yylu36WmvOXNoKYn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Apr 2010, Randy Dunlap wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
>=20
> Add ummunotify.h to Kbuild list for export to userspace,
> fixing 27 build errors in umn-test.c when O=3Dbuilddir is used.
>=20
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks, will wrap this into V2.

Eric

--Yylu36WmvOXNoKYn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkvJ82QACgkQsnv9E83jkzrrtwCgvJ1CtcloQrQ9idKWHPb+2gZt
M4YAn32kcEhDiFFTVe6uTIF2PEY1v8cd
=0JkT
-----END PGP SIGNATURE-----

--Yylu36WmvOXNoKYn--
