Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760601Ab2CMXNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 19:13:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55116 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760201Ab2CMXNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 19:13:38 -0400
Date: Tue, 13 Mar 2012 23:13:36 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@smasung.com>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Check SET[1|2|3] GPIO settings earlier
Message-ID: <20120313231335.GQ3177@opensource.wolfsonmicro.com>
References: <1331607500.11322.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8G1nIWD3RY794FAy"
Content-Disposition: inline
In-Reply-To: <1331607500.11322.3.camel@phoenix>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8G1nIWD3RY794FAy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 13, 2012 at 10:58:20AM +0800, Axel Lin wrote:
> Unused GPIO is marked as -1, we need to check if one of the gpio is set to 0
> here because gpio_is_valid considers 0 as a valid gpio.

This will break existing boards, we need to manage the transfer more
gracefully and complain if we're using a GPIO 0.  Though I'm not sure
it's worth bothering, I hope no modern gpiolib implementation will do
this.

--8G1nIWD3RY794FAy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPX9SZAAoJEBus8iNuMP3dwHwQAIYYxD7oHmpW5kEF1nZfMARP
IdbdZTB/qyKB3DAtdc+qgRnR+lNXqAAPtmPIzPOm/SKm9wFaopHonm6446JqsMkJ
CpOJ3x920HpFbZxxKlLjtM3BDaioL9w7iy+7QitDXxPOOuBk32ajDCO1soZARy62
m+RBnpqugweitsqYgCdGaU6v139CwGggFoH/mw1oz3N6eBmDN5RqwfQBkxbGgb0/
QF58KvuAPhddAclav6zNaAozwZiuJw106Gj1wmY8Kk4XXmz9ZwxPye/jkyQdVbl6
0EQO6bMcdpj/qg5XashBZ6T2fFXwZ+R5qzcOfYgCepD79SBQslmUNY/bYuzi/L6H
iGEabAy+ZXBl0ioLLr74sc5CuRZJlgVyCNohFo9wzt622em++pd3KqNyQrhZdyow
f3f2L/4UjZv/8TOMdnDBrqxcfPp++bOFqeeajTCEAKbl7TavzG3QL/w1X7EJ+P4W
ZrmfxzGMxft2fymUnYo18oYQS9uX9xxKnFEq5mKNg1wCHsroqp2lxjBY8PRDFECy
0j9HNiRlJxhrxPnrbWJ+QYSZabTE9skj6IIWkEYYqYkaKLsYDqSMIrL6p188+El/
QlaKOj1XUgejBb8wMAMZYtar7St82wRr0Zmxn2DYHM5l6gtzqTIvfZvdkxl8zAO1
Z5OdJb6CEgpRz4UCq6ec
=ahoi
-----END PGP SIGNATURE-----

--8G1nIWD3RY794FAy--
