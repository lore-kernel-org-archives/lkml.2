Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022Ab2C2LEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 07:04:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48581 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752424Ab2C2LE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 07:04:27 -0400
Date: Thu, 29 Mar 2012 12:04:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, lrg@ti.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Board breakage due to upstream patch
Message-ID: <20120329110424.GD3668@opensource.wolfsonmicro.com>
References: <4F7430C7.6060505@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GpGaEY17fSl8rd50"
Content-Disposition: inline
In-Reply-To: <4F7430C7.6060505@linaro.org>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GpGaEY17fSl8rd50
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 29, 2012 at 10:52:07AM +0100, Lee Jones wrote:

> Your patch "regulator: Support driver probe deferral" (below) prevents my Snowball Development Board from booting.

> What's the correct thing to do?

Provide a report with a little more detail on the problem:

   http://www.chiark.greenend.org.uk/~sgtatham/bugs.html

It's possible the patch I posted yesterday which fixes a deadlock in
error handling paths might help, though given that all we're doing is
changing the error code here I'd say regulator support on your your
board was broken anyway.  Given the lack of any detail in your report
I'm just guessing completely in the dark here.

--GpGaEY17fSl8rd50
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPdEGTAAoJEBus8iNuMP3dh8YP/24Ha9db4ph4BHqcYLj3I8by
hw1PCsl9pEvfbzKWlazpe4Qzb/bimj4Onqr+G0gPNvka5MowhjCTeWDUb3Ym2lSR
0HdXF+3PLMbiT6THW3PIObDOOVdQvxk7HCRJ9xiI2c0Oc21PFWsiWu4laEG6fhtp
KWxMqPRyulkSHXvkl9cH+iF7HAw+8JAfzE0/FUVyysBl76gOeo5Hqb5DOB0M87WX
tVRBolAP+ZXCTo7D23cyu7WkvFBq5sCaH6iFtYYncB5ZbiJ+Km9DijnOEQ+mUb0C
9vuhnKKQctgcOeRP6RzspMCvW9kHqdecm5YGdIXqnUsw8Op/uxumF406A8kwWbZE
8CMi+QBYkykm/yRVjY8mYBqYvTMbiKsWjE7JEw2p0As3/rOwiN9I6Y3/+OjGv91g
Lu9a7MYr+tqi5n/hJy8xWui0jh7ANLhN+QspmU670NRWuQsrR4qJZhDH9uc8vZK7
gXNTjluBrvWBAT+UTcTDLWE4Slq826JjjNb6qUc8ibc9ZkIoWLIkah31U4saRJY5
+8ezRYOMdqLawAkmw9SpIbPijdbPNJrRiH0n1sQcB7TZySsqzXVlpWfTYGCTtyk6
NGkhwmb/eYreKh5I3foGciQi0Gt0XiFkn3EvHVNujT6qhh/w42h+YQnF9z2d06Jy
6FG+4olQiQlVAcWVwXfO
=tYwB
-----END PGP SIGNATURE-----

--GpGaEY17fSl8rd50--
