Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab1LMPuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 10:50:40 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:43430 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab1LMPuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 10:50:37 -0500
Date: Tue, 13 Dec 2011 10:49:39 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: greg@kroah.com, stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stefan.bader@canonical.com
Subject: Please put e5fd47b xen/pm_idle: Make pm_idle be default_idle under
 Xen in 3.0/3.1 stable tree.
Message-ID: <20111213154938.GA4955@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090208.4EE77448.000D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Greg,

I was going to post the "e5fd47b xen/pm_idle: Make pm_idle be default_idle under Xen"
with the CC stable@kernel.org but Linus picked up the patch soo fast that I did not get to it.

So please manually back-port the e5fd47bfab2df0c2184cc0bf4245d8e1bb7724fb in the 3.1 (and 3.0)
stable tree. It does not need to backported in to  earlier trees.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Thank you!

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJO53QNAAoJEFjIrFwIi8fJ1eUH/19pIsCh3QwsRjfvMC6pxA8t
Z0Kqtsmqb+QovSWc9IL6qvojnjBaDqna6mcbUIq6sc4DBiWDh1GkdE/lhMAnET9X
IDlqr1UVrIl77sKBN5CFjFo1T2QsoPrwV0TkS4I+UIbVIBcyOcZ2ozbGi19Q9F0X
/FlBXszBYRHLaJj/kUZjnrhp+K39XUxa4CqLsDaRVElt+ekH+j+Q+89wlpp/bbjK
w7a7FH60Z0XuThesLQFBDF0E31lYtzjO3bqVv/LC8xbVfco65n9/oI42GAhFrtGQ
PU/QUALb82MjBvM4GupBeCoMMSS2STK6oqRGK95w8i7RgcmLc9oSGBtE3DSdkiU=
=5aOp
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
