Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab2EBJCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 05:02:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57512 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755319Ab2EBJCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 05:02:19 -0400
Date: Wed, 2 May 2012 10:02:17 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: NeilBrown <neilb@suse.de>
Cc: linux-serial@vger.kernel.org, linux-pm@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Question:  How to power-manage UART-attached devices.
Message-ID: <20120502090216.GD4075@opensource.wolfsonmicro.com>
References: <20120501082209.0b560708@notabene.brown>
 <20120430223322.GA3951@sirena.org.uk>
 <20120501093559.5c14087d@notabene.brown>
 <20120501163303.GA4089@opensource.wolfsonmicro.com>
 <20120502091516.20d87fc8@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pZs/OQEoSSbxGlYw"
Content-Disposition: inline
In-Reply-To: <20120502091516.20d87fc8@notabene.brown>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pZs/OQEoSSbxGlYw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 02, 2012 at 09:15:16AM +1000, NeilBrown wrote:

> However it doesn't suit my need - I want something more abstracted.

> I can see there may well be a place for a simple on/off switch for some
> components, but then I would prefer to see it as

>    /sys/class/power-switch/$devicename/state

> rather than

>   /sys/devices/platform/reg-userspace-consumer.X/{name,state}

That's a simple matter of programming if someone wants to do it, can't
say it seems worth the effort personally though especially when classes
are supposed to be going away.

--pZs/OQEoSSbxGlYw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPoPgSAAoJEBus8iNuMP3dDj8P+wY8WEvmCIAi7pSkvPXj6mgw
Q/Kyee+8GxJ9h2VYbiQt3bGQijQyie3pGVRHf809I3sVIu9KCsXWHtAsrGwDXT/3
InCAmC7ZWMABNJMbx9Gqj/hUfXHVJQ2RUEz5Rjn8QVBUoOxlTpFUApG0hcDhx9yL
CSTj4dUlvzOAVfbcSbf+xOiL8UQ3RkinB1eTXaqXoM8NZn8dbagzJC4/oHqbLpdA
KWhb+k5wvabl4ffcNFZ6U01ddkWPMBCUSIqdcwlUcT02SSzIOL3j3VsapYOHYxkd
kFaEYjYmuao0Zcv5N3A61XwtpZ//pb0BcaOZGtth6bNuwSjRoN1bVThEJJ/4IQ79
MPMQb9G60j1hgOW3xao51ME/P2ypFKPHTnorYV49U1PnB8N2i1tyo6uJlbEj2uTM
OqfuVjt7HtBX11Mxpzfsb/xXus1J5YA2NFFB+1uNYoLUscyaITspocV1wgOCIBQl
lxBKuq3q3wkvDdG+kZn3UIUbq50WEtS726leS99RWURG2d2NsEeONyC44jAKGEYa
H/2kh43ecuBc2MUCDWq4m/V6xLfbrK7hz5/gq/E/e8JxvenoKqJQt6vHHiAp5R0/
8AtSx/4Jm6uLhgcSzN+ybQeKYaVYQAL5f+uzGYLnzhd7qhOsja5mWICQxNISYdNA
n5RXNIIkyOQPHjJNijr9
=75l3
-----END PGP SIGNATURE-----

--pZs/OQEoSSbxGlYw--
