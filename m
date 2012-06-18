Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab2FRJiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 05:38:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33761 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751972Ab2FRJiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 05:38:19 -0400
Date: Mon, 18 Jun 2012 10:38:14 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFT 1/2] regulator: ab8500: Use
 regulator_list_voltage_linear for ab8500_regulator_fixed_ops
Message-ID: <20120618093813.GB3974@opensource.wolfsonmicro.com>
References: <1339122469.5794.2.camel@phoenix>
 <CACRpkdaUVMp+VstcSsWCQ-5Oe8QwcQL5Rt41Xm7kR2parUDgVQ@mail.gmail.com>
 <20120617165548.GA4267@opensource.wolfsonmicro.com>
 <CACRpkdYmTRRRf_gMg4R57r7yxgdyFU+LBfWhqqiZ1zFsar3kNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xgyAXRrhYN0wYx8y"
Content-Disposition: inline
In-Reply-To: <CACRpkdYmTRRRf_gMg4R57r7yxgdyFU+LBfWhqqiZ1zFsar3kNw@mail.gmail.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xgyAXRrhYN0wYx8y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 18, 2012 at 08:15:42AM +0200, Linus Walleij wrote:

> I was mostly reacting to the "RFT" keyword in the subject, so I tried to
> test rather than just ACK it, but it's applied now anyway so whatever.
> Acked-by.

Given the fact that lots of regulator drivers have no regular maintainer
and that Axel so rarely gets things wrong I'm usually OK with applying
things from him if I don't see a review within about a week (with things
where I just don't expect a response at all I tend to apply immediately).

--xgyAXRrhYN0wYx8y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP3vb1AAoJEBus8iNuMP3dMqIP/jBn7Tx/ISAnwQsOq9/BGPLS
SunAxM710LwthHfKBbxxIi5RRswiv9DchzFzRGUul2SZ0wjGH213V7dalgaPTv5h
RRklsobERLXabJrBqSRDnkqleN+BRKxE60zjKqPe7rebt1haiINTBqQOvWXhw8aW
0WZEFsbBvACYE9BsqvCXg9O4xzP/kU+CENNFksqAoS7v4YB5/wyGIDGG6fDefDTx
q41s9muWWjw9exD0+NUeST0pSWix3/gYtCR0FmHjZ3JjHPnA9/5QxAB2npWdTuEM
185UBXckOO9b1vV/6KQ6p09GN9qRRrfnSHfL9OI062FWEs7EOkK3d5D4dWcgRJBZ
Hd1rIhUDNkY5/vKP74naI77O+962pMG0/HrhM14xUqrZ27KvRjqKnMLzeOyBj11g
XSdHXDCx0QRWn1f+PN4RHxp9gfHx/fwxoAaQbLPLYgCCnVEaIyj435npDxNHkgAE
k6/+ooJGHRmdiMDhD+rS2WjKKEvVWDL3YHLUYlCI7RAdDQLI2rw3fFyatukmcw9/
w1VKPuGrCZAQ9sFIsE+HxDdDAqtUd/8fs9vZLWnI6WNFtjp0oDX0PXm2clMroiEw
jB2t6ZVNOg5t6LDNQCwwJ2rKRqAhB6nxUVH8Mg2oxwqdA31VykUmGxk9Nc+LmmI2
ldJ8Rb+EZNpOImnRrnZ/
=XKFU
-----END PGP SIGNATURE-----

--xgyAXRrhYN0wYx8y--
