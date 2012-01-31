Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab2AaLXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 06:23:30 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42604 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752949Ab2AaLX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 06:23:29 -0500
Date: Tue, 31 Jan 2012 11:23:26 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Randy Dunlap <rdunlap@xenotime.net>, Tejun Heo <tj@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Documentation: devres: add devm_regulator_* to the list
 of managed interfaces
Message-ID: <20120131112325.GC18444@opensource.wolfsonmicro.com>
References: <1327992241.9257.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E/DnYTRukya0zdZ1"
Content-Disposition: inline
In-Reply-To: <1327992241.9257.1.camel@phoenix>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--E/DnYTRukya0zdZ1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 31, 2012 at 02:44:01PM +0800, Axel Lin wrote:
> Add devm_regulator_put() and devm_regulator_bulk_get() to the list of managed
> interfaces.

Applied, thanks.

--E/DnYTRukya0zdZ1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPJ88nAAoJEBus8iNuMP3dLEIP/jx8Q5cZjZOxLss8ClR8ovEd
761x+YXhKMYL44+0cjUpBp0H1a8aVrG6VfwcwMnPV4F0Qf1rOVWggLqYHv0/ba/n
k6Qm7+LHYYVgIlfvz5KGIMie96QH8mbSHTEil2xhEFaabpLA2oZa+dcPBsIi6wdw
u3g8wFIasf7KK4bzU6Nuo+OYBjcj7Qpr7UbnzxxYsvjUzA94f8KWCK82Z4nrthdl
ish2wajxxL6lWvoqpqarOHyvALh1KJ5SPG3Pw+SVuAlQepwVJcYAlgAe+wr3sPBF
UXumqVeFeShvRRBxAjkmQoRdhNHXjSSvzc/dET7qXcECSx642dqb3ZZzN54CcYzf
zqRqYxe5arHw1RljFp4T2dUt5S4+uBDG3VcR0xQ0jNYEAMhIYhhADLx1QSLwuQ17
Rm22cQK5ELyX89343JF4uthYfWV4w0k3v1V5meMN1PUH/i44mXZJPwrYcMdxkikV
Bl/H8ETI96mI9XKsxiZ5Gsnb+lYP6QhgQhVnHTcjfxWcAUX6Cstns6qz7DAE87ZU
SOCWqmu0EeaDtB0KdKw4S3fLIhzD6jJ2kRtfryuheesfmNNIwOszzN4IgtOD3hPR
bYn/WNWq334Rt1w+apYn92MJuAxAq91QnmE6ZKcb13o7MsueRvmmhvsgBThr/tZJ
Hbh2B4sPhQHselSh96xm
=Nz6X
-----END PGP SIGNATURE-----

--E/DnYTRukya0zdZ1--
