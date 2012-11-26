Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab2KZJvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 04:51:46 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49636 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753175Ab2KZJvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 04:51:44 -0500
Date: Mon, 26 Nov 2012 10:51:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        myungjoo.ham@samsung.com, linux-samsung-soc@vger.kernel.org,
        kgene.kim@samsung.com, t.figa@samsung.com,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Rajendra Nayak <rnayak@ti.com>, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 3/3] regulator: add device tree support for max8997
Message-ID: <20121126095141.GC9411@opensource.wolfsonmicro.com>
References: <1353657795-1725-1-git-send-email-thomas.abraham@linaro.org>
 <1353657795-1725-4-git-send-email-thomas.abraham@linaro.org>
 <20121124175954.GI4719@opensource.wolfsonmicro.com>
 <CAJuYYwThsFutYnYg2scmfqUAGxBM2pWmRmoTww+OyZgUuA-7vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i7F3eY7HS/tUJxUd"
Content-Disposition: inline
In-Reply-To: <CAJuYYwThsFutYnYg2scmfqUAGxBM2pWmRmoTww+OyZgUuA-7vg@mail.gmail.com>
X-Cookie: Chess tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i7F3eY7HS/tUJxUd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 24, 2012 at 11:46:51PM +0530, Thomas Abraham wrote:

> The max8997 driver is mainlined. I actually meant to say that, this v6
> version of dt support patch for max8997, is similar in functionality
> to the v5 version of this patch. I did prepare this patch based on
> your latest for-next branch.

I find it hard to believe that this was generated against for-next, this
was where I tried to apply it...

--i7F3eY7HS/tUJxUd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQszumAAoJELSic+t+oim97eUP/1vobgggSsowIJv4iToOA0+g
kQ2gOnvsUBWrgJI/WBiNeQMKNBigMK4/IBn0Rlrct089lifZqLt2flSHLDQk5dKc
U5qOqRGwg/qEnN0hQcolBC9KZiGHh3nkbMo3H0Xn+ZZj1p6j3cbVAISUJP9WiJGf
Z1weZ6C7B3Gbu4Nobo3/nNZ43U5oTiuJqW9yUSkyanHE5ObPIN+SvzworOzqRX4B
wYhUSrsEKH07q67ZS3Rbikj+roTX+/GikQt+3YpbVhsw7XJ97msd7OeokMBLNhhG
iKSRO5SlEOpvZD1meZ9sVn4MpqTKw85YUp8eO5KnhDhRz+XCMLC4bWfvspdalYUC
kxJIKJ6fgQ0xhRJoHIvVPBlXDCBSCfYspDNz9K55UZ+N6IUygkLLul/cSMUTDc8+
mWdgLAGAqiO6MH8jrU9MqvD5l1QDtRJVdQPv3oG1cNoGdycrJ91SKosgSSt4t6PS
raSw8gxM4MNiITO2a8Fv41UAJkhzh0A7yUVC1Mh6mq9yQop/1a7hSlVQ0/1otqmh
A7X/MhFZ7ecQE7648Il05NqEO7y2Z/weeetcrU5IZBOpO0lV2stZ472+FUQE3B2v
Y6G0WNkzPeTXRkyhMpynD9dhAuu5SVXgrLjROZb9lruP3J2FcKd3UuUvaoWXmk+x
IYNkbsFAvhbk/0awrQnJ
=5QOm
-----END PGP SIGNATURE-----

--i7F3eY7HS/tUJxUd--
