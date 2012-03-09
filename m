Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab2CIMbf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 07:31:35 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36427 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753074Ab2CIMbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 07:31:34 -0500
Date: Fri, 9 Mar 2012 12:31:30 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Nancy Chen <Nancy.Chen@freescale.com>, Liam Girdwood <lrg@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Axel Lin <axel.lin@gmail.com>
Subject: Re: [PATCH v10] Regulator: Add Anatop regulator driver
Message-ID: <20120309123130.GO3273@opensource.wolfsonmicro.com>
References: <1331200744-5986-1-git-send-email-paul.liu@linaro.org>
 <20120308141847.GG27213@game.jcrosoft.org>
 <4F59B899.2080704@linaro.org>
 <20120309095834.GM27213@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="keoAwTxaagou87Dg"
Content-Disposition: inline
In-Reply-To: <20120309095834.GM27213@game.jcrosoft.org>
X-Cookie: You will be successful in love.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--keoAwTxaagou87Dg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 09, 2012 at 10:58:34AM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:

> > I've modify the patch based on your review. However, the last one cannot
> > be made because regulator_unregister is void return.

> so we have a issue here regulator_unregister MUST return an error conde

The error handling on remove is totally irrelevant to merging this
driver.  If you want to work on changing this in the core you're more
than welcome to spend your time on it, I'm really not sure it's really
worth the time or effort for the systems we currently have, if someone
actually has a system where it becomes relevant then they can work on
it.

--keoAwTxaagou87Dg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPWfgbAAoJEBus8iNuMP3dw2YQAIVU2qc7SFq2FyYXmMVgN9+m
b7n8RC53gIRqXeXhbZ1f/i0dAo6mLPeyG5uBAy8e+cEqEg+ih03x0jCAnBxLv0DA
VjKT5UtQVPLGTgZOVPpjvru2HN5IDm5kbSu7ZcyZlPjVTyYDB6p2TNJGGabD5ggp
n7jTr7EiOBnoe/n/SG2QH1NuhsCdV3qYeCpzz7IWCS3re9E4HrZ/XiBSj5i5/KU4
HF5PY9kPM6Ku5LTL4fMmj+F3pj1G6eMY54biM0DzYiVyXd8VYdxoYCaRBLj21tte
OOgbV6vT8nFCgBjznBWTp3SYTVMIEv9CH0cP+/mhiZbBWRVgKufEKfJYeuZa8bws
2E+lSHfsQcp4fe8pGd5EiGXdEjiu1lNfo/YPMaiNecBcWkAcdtkJP+daYBYX7GDy
Zg9ZdefyhqLsKzjilRcEzbye8bLK1AcGIylE0nd32S+qdXx5YSnfrEte13z3edqR
SvmKAJnRBYnsZIZvqZIwTWils5PEEaRwJlLXF8gBAj3p6zPKlrN2D+cpGg/0tQNO
Gl/wsaPoNR5DgJ53VQtEevvr9SUvIsvLLDxBheuUhDINA+VdLnH5PSNoRKctzpNw
S8kbRB7D4q3PeOI9hSlHlhUS3gldnbWU2h9IOR0gSmiau0a4TH6PZCqNaQPXMJb7
Z8afANs+eN54ssYlVkW5
=u39J
-----END PGP SIGNATURE-----

--keoAwTxaagou87Dg--
