Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab0KWPQn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 10:16:43 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59843 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318Ab0KWPQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 10:16:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Of47hyJ+Ds0IDUQYCqtVqAl845es6UeQV8rC9tVtSwI6dMK6cRdMm5anM1EbYoPH0R
         PT9joRPTuWmIF9PBN1bEvMfHTgXfysFc2sC7xspR3UlR8mXLRdnKQM4VLRqp7yx5WQeY
         Z3kr3NYmQSwHd/hUd8cei/qE5ZnrhQ6gi2p2k=
Date: Tue, 23 Nov 2010 17:17:07 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: Re: addrconf: refcnt with  IPV6_PRIVACY enabled
Message-ID: <20101123151707.GA4076@swordfish.minsk.epam.com>
References: <20101123134003.GB4142@swordfish.minsk.epam.com>
 <1290522803.3046.11.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
In-Reply-To: <1290522803.3046.11.camel@edumazet-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (11/23/10 15:33), Eric Dumazet wrote:
> Are you sure the problem you try to solve is not already solved in
> commit 88b2a9a3d98a19496d64aadda7158c0ad51cbe7d in net-2.6 tree ?
>=20
> http://git.kernel.org/?p=3Dlinux/kernel/git/davem/net-2.6.git;a=3Dcommitd=
iff;h=3D88b2a9a3d98a19496d64aadda7158c0ad51cbe7d
>=20

Seems to work for me.=20
Sorry for noise, thank you.

Tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>


	Sergey

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAkzr2vMACgkQfKHnntdSXjRqSgP/aBgyAjrdSbujD1o4fH0c3F7c
yIruwfy+WWsHUaQV/THiWI7jupYW2DTrwZQZa9PpH9IWh5Bp9DmQ5XcKXQsYv+1R
OZ0mKmFGbl63kH+BXhdMZIFdU4Oe5JsVuMNismb3g6jOndVv/umXrMpjHaeC+bUS
st5Y7f5vkQnvP0ecqTo=
=BMCe
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
