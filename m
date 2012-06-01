Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933352Ab2FAO3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 10:29:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37155 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932185Ab2FAO3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 10:29:38 -0400
Date: Fri, 1 Jun 2012 15:29:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: fixed: Use of_match_ptr() for of_match_table
 entry
Message-ID: <20120601142936.GS24139@opensource.wolfsonmicro.com>
References: <1338524185.3017.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+bDoS+V4AJZnUgoC"
Content-Disposition: inline
In-Reply-To: <1338524185.3017.1.camel@phoenix>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+bDoS+V4AJZnUgoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 01, 2012 at 12:16:25PM +0800, Axel Lin wrote:
> Use the new of_match_ptr() macro for the of_match_table
> pointer entry to avoid having to #define match NULL.

Applied, thanks.

--+bDoS+V4AJZnUgoC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPyNHJAAoJEBus8iNuMP3de5AP+wfn5OHckSx+9KRmta01KKsR
eTRj671wm7otC9uiZUjPzPM175eHuT4A1kVrx1OoT6vD3uU8Z9TSoYVbo2qXzCtT
Cgd7A9MPp+SpQ4wogCVgXGzSrspCLjN4e54W7PK7xQJvrTw6nriIi1exoRZLiYbf
sIVItfeb4XZk+/k/BFRLyKAldkfUrkILulgkaAbdGdDUtLYF22j6SYGorRlBsqLX
bAKZyVYpuwQWpaqZsfBN4A5i0VbTiRrsqbekzkuYNhjN7xKhoRh6YJ2HTuw570St
g2tUZCjB2VKGelb8iLwkH3ox7qpZqCsfBVws15w3y4uiohU5a27IY7eIa/o2xICy
w6OS7jcweNsN9TNI9hhnR9zDn13MmQBUQqT5EOBxMA8pEXWi4xrtFOjsHRZTvQVG
IAN4kOyXb6ugfXGc2eiX0pju9UUVjo3kNXTW3WRg+tvd7wLTf4TDVRCvSHILLs+V
gBZF4kgcjmsV9IklHLz922SSFg1U+5oWEu7ls4zr6I4nGXw0CEeuiaUxKxjPNAUv
TTYcS0FwJqw0atLsislvfz/Z/RR66u1hmeTx9Y1DtrwSAGt7f/NjR+PE/PfWWsxL
1M+xR3lm/M0TSn8b8HqNUmx/zG8bNUCE9046GxnZAyLk+s8X8tqIGKdhfI1AQge1
R8q7SV6D/0clXz7WS3kT
=6rSH
-----END PGP SIGNATURE-----

--+bDoS+V4AJZnUgoC--
