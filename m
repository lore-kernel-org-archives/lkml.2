Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab2GOVGF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 17:06:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45808 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750865Ab2GOVF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 17:05:57 -0400
Date: Sun, 15 Jul 2012 22:05:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Rajendra Nayak <rnayak@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFT 1/2] regulator: twl: Fix the formula to calculate
 vsel and voltage for twl6030ldo
Message-ID: <20120715210554.GG4041@opensource.wolfsonmicro.com>
References: <1341804151.14367.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2FkSFaIQeDFoAt0B"
Content-Disposition: inline
In-Reply-To: <1341804151.14367.1.camel@phoenix>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2FkSFaIQeDFoAt0B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 09, 2012 at 11:22:31AM +0800, Axel Lin wrote:
> In twl6030ldo_set_voltage, current code use below formula to calculate vsel:
>         vsel = (min_uV/1000 - 1000)/100 + 1;
> This is worng because when min_uV is 1000000 uV, vsel is 1.

Applied both, thanks - even if we need to fix some of these to be using
tables again this set of changes at least maintains the status quo.

--2FkSFaIQeDFoAt0B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQAzCqAAoJEBus8iNuMP3dlpQP/jswK68zTbGLpcGnjFzQokgq
+ch9z6twk/U4LC4+Bf3HlZiVc5tRgtFlcPnH2eZaH9l5ogdlw7AB5uPt/xvJ5it6
KhkksLXPva+OsjKz0N7mFqFv/YXI7OzoeSdey1cHEBqd9a7sBGO0zpnMqeScoAI6
B9v7+3cSr+vjdloDlooLKt74hg5mRA81gcVZnAcKc20O69yFNM1f3NCZDlTE6IRw
ilq21fwxHDepxd5U/IcmXQblQFXVUrxRcJbQrRE1YZOQnmCrp6hSeIYJsa6J7CR6
ZBe6jY0t4BPoPi39v5CoLYgdBtMG+OwvW2P3F4+QL1hy14I5YLEjw9BXzJ+BRaLk
0Z4o2SSZjHRLj/CUZK8vXwvjcG6sNQKgoZq8ss6INqOAFr2sDT2B2I7mzapeNFJ/
3G0Rtm1LVLf8EJccdre0kKXCz9Uj/qB+JLwWN/lq4H5AtCWAnNelV0YoOju9BgNH
4mkF0CZEayuqfp/TATH6TSa3NwwSTMAiCizG2KAcU4MU1Lty5axclsU7ALj7ylXk
uDDAoyLLv7AXIwVfWY5fARLxgUxJW0gyGmjr6mp0nfl5sN3RUT2VlP4tmNF2wCIm
cwLbspFzvSQfwnQZzPF4uMWKZ6grl8RaIz4WSAJisg7JLZLrztetvQ/+kmXKn6DN
/pFnlt25d5rd+d4z9mRA
=FRYo
-----END PGP SIGNATURE-----

--2FkSFaIQeDFoAt0B--
