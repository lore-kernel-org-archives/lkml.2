Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275Ab2CaKdg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 06:33:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37991 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756455Ab2CaKdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 06:33:33 -0400
Date: Sat, 31 Mar 2012 11:33:30 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RESEND 1/4] regulator: Fix setting new voltage in
 s5m8767_set_voltage
Message-ID: <20120331103330.GD3163@opensource.wolfsonmicro.com>
References: <1332130930.26765.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LTeJQqWS0MN7I/qa"
Content-Disposition: inline
In-Reply-To: <1332130930.26765.2.camel@phoenix>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LTeJQqWS0MN7I/qa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 19, 2012 at 12:22:10PM +0800, Axel Lin wrote:
> Current code does not really update the register with new value, fix it.
> I rename the variable i to sel for better readability.

Applied, thanks.  I'll apply the others after this has been merged with
Linus since there's going to be a dependency there.

--LTeJQqWS0MN7I/qa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPdt1yAAoJEBus8iNuMP3dmTYP/1b00LuIYmoIHG4G76HIrlb3
UUAByifWLrDyyG1TkO+8m1cOqrqPoYPgGVETt0EpLm5rU6cY+WJFUuUNMJJM3jPl
mspsKYPo6PnaMgKwOxHfsXkzdDHqe6UGVY+Ab5HylorOXNdk8/OZAlS5W2seKh5m
wGVH5lJymbvfJ3h6LwDT6tFL2prHiRB2bura5kUuG7h+lzZXPH4QeAnmUZQQ6ZCF
C2nlbXan+qG3MQXOl11TZwBt0BMXCaUkQg3XOvb4t9OWpZiqqJO0eo6PiQhEh7P3
k4btAinHjNUxjsp9NasHGtr+GFa7lYm+ySVfxp9j9j70wk420mtSey7SxJJqVyku
W7maHBuwjyNgcMFCNlxw3sOERLAxMVjv6lrNOWJI/BnP/yCITlXcnFQyMEc+zjb0
ab0HZGnDQtooAvBYqJFRe522nLiFRlqiPf1Di+TUMkSZAurniJwZERzSJSS1+p4r
SCEfVYuZ+fK9GcCDo8mfRO9L1giMjRbp3Ohdgr+2A32Sl1V/5cue0GfIUmjuYvTY
ynmQB4sIUyvonuAErv17XjvNEVxItulWsvk7d7x152qrpO9UgjafisqNotqZ9TMH
hEhYcZcyVe+i04cEqXYx3rJCLiANi/SCPTvdlK04DcyzOCzx6bNNqliWy1WHlCq+
hk88cAwYAp2r1B4iUU7F
=iEFQ
-----END PGP SIGNATURE-----

--LTeJQqWS0MN7I/qa--
