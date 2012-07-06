Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601Ab2GFSRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 14:17:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46218 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753031Ab2GFSRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 14:17:50 -0400
Date: Fri, 6 Jul 2012 19:17:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        Liam Girdwood <lrg@ti.com>, Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: Re: [PATCH 6/6] regulator: max77686: Initialise rmatch.of_node to
 NULL.
Message-ID: <20120706181748.GJ5437@opensource.wolfsonmicro.com>
References: <1341566408-17105-1-git-send-email-yadi.brar@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oplxJGu+Ee5xywIT"
Content-Disposition: inline
In-Reply-To: <1341566408-17105-1-git-send-email-yadi.brar@samsung.com>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oplxJGu+Ee5xywIT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 06, 2012 at 02:50:08PM +0530, Yadwinder Singh Brar wrote:
> Now of_regulator_match() returns without finding the match if match->of_node
> is not NULL.

Applied, thanks.

--oplxJGu+Ee5xywIT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP9yvAAAoJEBus8iNuMP3decsP/imsi02rMmaqQ3TQSxmj+gf3
0n9yFQzNF/92ACgvO35pzYICSFY9cGb/BiHO5d0fFDUhI7BGys3HcKTq9gCKRJX7
LQfMhbnn5mFnBeSYPBpmPxXBRLMuCFfaiFU9EOGdaWOZR0B3bHSLcqVYkQwIn824
vW8tiyKBDhHFcBigXOJ/r8zIs6v+dSo+ADi+u/2/z3J6aC12FXMmx8gQNS1qlCRp
k1/w5C3sJUs5VbWPOYrjIlV15+2GJhMx0+9NXxkQqMvIt+vpq7ZWoUOVb1pnnudF
kQZsES1ffqeGu+9leCNMP6zg8WsZfvln4PHFW9HQgPi1wPDvxLZ+XuIsI6gvYsKs
B0ezY8YQu4+k2LlxS6DIFIFgWJSygIFY8Xd4d19HUioAsaVoApaY4AKvMionKX6C
6rgD6o7caSNNt+gu9f1Almx319OSG2K1VM/CVcuNN4V9P8r4Vn6AvzBHDhsTjyC7
Ggkk9YAJFSs7vSdRUPByEbcmKTFSr3b15aZF3FYWg/Txnx0h73PbP+d8KFCbZYRG
iSg2cdSVoKzkYqlmcCClyp1MmfAEDhZaua62I0cj7BTkeYg10PMa3Be5j97dKGh/
v+q8NVTLaaFmx4Wyj71g1DuKYF6Kkq/ISL7nBFJVX3ixzpYtsXkZA72CzyeMrOGh
7MD89P1SsW5EyBAR0r0J
=tU/t
-----END PGP SIGNATURE-----

--oplxJGu+Ee5xywIT--
