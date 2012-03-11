Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab2CKMtJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 08:49:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44881 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751965Ab2CKMtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 08:49:05 -0400
Date: Sun, 11 Mar 2012 12:49:03 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: Fix missing prototype of devres_alloc() and
 friends
Message-ID: <20120311124902.GF3233@opensource.wolfsonmicro.com>
References: <1331324248-1599-1-git-send-email-swarren@wwwdotorg.org>
 <20120309203000.GA10835@windriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ChQOR20MqfxkMJg9"
Content-Disposition: inline
In-Reply-To: <20120309203000.GA10835@windriver.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ChQOR20MqfxkMJg9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 09, 2012 at 03:30:00PM -0500, Paul Gortmaker wrote:
> [[PATCH] regmap: Fix missing prototype of devres_alloc() and friends] On 09/03/2012 (Fri 13:17) Stephen Warren wrote:

> > regmap.s uses devres_alloc() and others that are prototyped in device.h.
> > Include that to solve the following:

> Thanks, I've already taken care of this earlier today.

> http://marc.info/?l=linux-next&m=133130596327850&w=2

So, I was going to repeat my question to Stephen.  But then I looked at
-next and found that someone had gone and randomly deleted the inclusion
of device.h without ever telling me, looking the git logs I see that
this was done in commit 3a55cc ("device.h: audit and cleanup users in
main include dir" - notice what I'm doing here and including the human
readable subject line and not just the git hash) which comes from you.

In order to avoid breaking bisection I've applied Stephen's fix.

--ChQOR20MqfxkMJg9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPXJ82AAoJEBus8iNuMP3d/IoP/j+yjzZ5BmnDHJv4EZCF8NSd
Z/+3apl+25iCe+pttbfZd5IaHJ7i2OHnv9yKa40oncQIYEP21T2QtrcwtVLgxvee
M/As/HhLEn51ovioJ3Jwo9T8BBwoIXXyXS2yft2GTPLT+wf0TrLfk+PqrIc63RIj
FTe6lX5yADs4+kgsvRxEMv3kFtTCNtgOcW+r5b+IKe3YbJiTjVXrGkrFNPOUyQss
nGFFxpucG4oy36/oR/xMCkYx/GNYuFkZ3q6Hi/jv8rq43ccZxT2GFIYkxZZkF/Qg
Bq/Nq5yU+AxsUwVQkKCd+Qg2Xl/CPSwbkHlRq1A+Op7L5z9WUCQZYwWSQv+jKNK8
5TD1svdbAncbLtgugIWRKVHdjze8uXvflXGGDoDaQKGy+OHvOro6XWqju0LWCu2D
YGCxxWNPaMblhv7FldNd4f8WOZF2wAmm0/JAcoot1cuBQf3hGBglXVucG7uQdTpi
W8Pe55qGoFnY/7gEnI9DEugVNZqn9U1bCBvH6AZNFvubuwJ7Gs+pnTaM61/jIhSR
xnpXV5YJ+BlnzlOX3LXTEW2ay1kJjDEPu5Hz8W2SAqiEtmNNZWQI7mpSStzfk95C
s0MdA0jtYeN+rIo0aqcOc+Cwq1cwZ3lcdeqfvQpdW+QY+ejRhIyDO27ewtv+mkAH
rQGkCck+0H4GdDxHoj7V
=tynU
-----END PGP SIGNATURE-----

--ChQOR20MqfxkMJg9--
