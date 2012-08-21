Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab2HUOUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 10:20:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47966 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752613Ab2HUOUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 10:20:11 -0400
Date: Tue, 21 Aug 2012 15:20:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Sourav Poddar <sourav.poddar@ti.com>, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 1/4] mfd: smsc: Add support for smsc gpio io/keypad driver
Message-ID: <20120821142007.GP7995@opensource.wolfsonmicro.com>
References: <1345545940-2232-1-git-send-email-sourav.poddar@ti.com>
 <1345545940-2232-2-git-send-email-sourav.poddar@ti.com>
 <20120821124146.GA21557@sirena.org.uk>
 <20120821124243.GG10347@arwen.pp.htv.fi>
 <20120821132222.GF7995@opensource.wolfsonmicro.com>
 <20120821132741.GI10347@arwen.pp.htv.fi>
 <20120821134936.GH7995@opensource.wolfsonmicro.com>
 <20120821135240.GJ10347@arwen.pp.htv.fi>
 <20120821140803.GK7995@opensource.wolfsonmicro.com>
 <20120821140923.GL10347@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nLMor0SRtNCuLS/8"
Content-Disposition: inline
In-Reply-To: <20120821140923.GL10347@arwen.pp.htv.fi>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nLMor0SRtNCuLS/8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 21, 2012 at 05:09:24PM +0300, Felipe Balbi wrote:

> You can't possibly understand what that'll print. First of all, VEN_ID_H
> and VEN_ID_L should be ORed together. Second, the user will see the same
> message four times in a row, with different values, but see that driver
> claims that all four values refer to the device id. What this should do,
> is at least combine all four messages into a single one of the format:

> dev_(dbg|info)(&i2c->dev, "SMSCxxx devid: %02x rev: %02x venid: %02x\n",
> 	devid, rev, (venid_h << 8) | venid_l);

> or something similar.

Yes, I agree that the formatting here should also be improved - as I
said in one of my earlier mails if any of these things are fixed things
that should never change the driver should instead verify the value
rather than log it.

--nLMor0SRtNCuLS/8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQM5kRAAoJEFJkBDiqVpZ4KhQP/1o7w7fe2GTTvVc7qfm+d3X5
u532XpyOa5Tq7pX9L1PzU6R78m0tPQaPnJ72Tl7UE1SDcHBLZ+fYoSMPK8a05/MA
5rnmkJUVR2qNRk/N+huwSxL06tQD8ZlLUVqua4Q7L5Ld7ntCRRDz1PrvOXJ9Bvbx
1M5uMsELnxCLeB3AHfic9f20rfIRZEyUGmnfGuHNRUxdtDUhTzK6i5fI6A5gRzFY
Y5SHfE5d/ppUW/fPCqlXGIM4966u3ulz5lf2J18CfBYJjYJ0XWaL36NMnJi+EpVr
pZzci/4ILm7tDUKPC/f3uL3EvjWj7oLSq5AsyE/S32zSf/shL2XIWKbun+7AKv2G
ei1uf81n+lj7HNqvcpL9e3cJRILjgT2eRyLqk3BlDOY6Pj9XL4bRMzD7pQEaD4S+
PkunNXeYT0QY5H9gZXPKjrotu1QjN2IA9MDGkQOFnzwApiFcUsHXFR4AKq79ye5E
J6SppALCtzmhNaNAMg0WgjFkpBYOc3Bgl7q82JeLby8EwOX5nMIenKh1U7g/hEyC
FoMKYJEnrnwb//6dysB3bDhdNM2CsFpGv0LPRoA+xnwFyOe2UDs6wOGMKg6Zu9aM
Xxfk0Vrb9EXmRkULRniVkJjHQzug5rukZTt8OzirEWdfsYYZSha+IgW+xCfObqKF
43CBrqsSW/RaTty/iwy6
=cnNl
-----END PGP SIGNATURE-----

--nLMor0SRtNCuLS/8--
