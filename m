Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab2HUNtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 09:49:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53107 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751090Ab2HUNti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 09:49:38 -0400
Date: Tue, 21 Aug 2012 14:49:37 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Sourav Poddar <sourav.poddar@ti.com>, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 1/4] mfd: smsc: Add support for smsc gpio io/keypad driver
Message-ID: <20120821134936.GH7995@opensource.wolfsonmicro.com>
References: <1345545940-2232-1-git-send-email-sourav.poddar@ti.com>
 <1345545940-2232-2-git-send-email-sourav.poddar@ti.com>
 <20120821124146.GA21557@sirena.org.uk>
 <20120821124243.GG10347@arwen.pp.htv.fi>
 <20120821132222.GF7995@opensource.wolfsonmicro.com>
 <20120821132741.GI10347@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="54u2kuW9sGWg/X+X"
Content-Disposition: inline
In-Reply-To: <20120821132741.GI10347@arwen.pp.htv.fi>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--54u2kuW9sGWg/X+X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 21, 2012 at 04:27:44PM +0300, Felipe Balbi wrote:

> I still beg to differ. Even if it fails, dmesg will still contain the
> message (provided you have it enabled). I really don't think we want
> this to print to console on every boot.

Only if it's enabled which is the trick...

> If you're still testing your new batch of boards, you're not just a
> simple user and you will have debugging enabled anyway. dev_info() will
> be visible to anyone who's got a console running. Not sure how useful
> that would be to my neighbor.

Also think about hobbyists and so on, and ideally at some point the
people using distros.  We shouldn't be requiring kernel rebuilds for
this sort of diagnostic information.  I guess sysfs is another option
but frankly the overhead on boot just doesn't seem meaningful in the
context of the overall kernel boot style - I'd really expect people who
are bothered by this sort of output would be raising the minimum log
level appearing on the console.

--54u2kuW9sGWg/X+X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQM5G+AAoJEFJkBDiqVpZ4KPgP/1ncZmg3IFkYUQvHIn0p9fj9
RveFzhmi9xQC/mxxjd6lj68OU2Lz1PaU2FiD9K5Edq7QZn8Xcmt3lqYeQnD1LGWN
Gvjaxx/igxw+C4NPDmAwlmqk0EcMkSP2gnctbpD8b+TL9nqxZqldsDHbhU59meF2
kUDrEvfFTsuqkZ14Jpk5Ac6OVniPXS9WByH2nImXsu2jsbYjBYqlHpRrNhwYOeLF
nzfFGoLOkYxk4anOSiB8UYEbaLqVDU0PYRFW10ufTcg2q0VP2LZ1p9H7l7+Lqz15
euY97cCk13wc2dEhGME96xBD7j6Zce/vpm4yHD2qVpcxDpP0bTAp35gxVKLjJUjl
UGkUoNG6eDs8c9v4ILhFhxD3ZoBM1y55V5uodAO45yJRYzpXBKy8BOasdPdExqXk
tJo2J+CJOFeT5VGn1Sct3JKwGa3z0rWtEfv56trWhxW6mKwYqiHaKrcI5JQ6mkGF
unPylJYGIbnuQ3YqayJU5WUT2g7IRs9iK1I7neD5ggFqNuWjoQfh9XRp7cio26tH
3CDXsB2LzEhKBQ3jSxnI++b/J/vIKJ1p/XUMP07lz6cU1H/9pEzghVg8+VrmrCGG
I8V2p/mT4whY423fHMQJHiMn1oqab8UMWxrO/ypic6gwLs9zfaB3N6Lpx6llA4A5
hGi0o72Cf1SSoo1cFmt+
=5jIw
-----END PGP SIGNATURE-----

--54u2kuW9sGWg/X+X--
