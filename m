Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab1DKVTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 17:19:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41667 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944Ab1DKVTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 17:19:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rouCnet8txk+/L8ao1T8mbAdQWXs3mfDVqaviDMiuNrLIbqDDE9a9mqKsq+do3PHep
         ZGKHGiGzLPrYbI87jACrW0e6C7izgOFMccrfZ8/n/8fCAiUVDrsxjfZ1Cl/v08eoMMWf
         KA1gRqiJqrcouPQ0TvJ0OwrsVQHn789oDv7Dk=
Date: Tue, 12 Apr 2011 00:20:06 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Changli Gao <xiaosuo@gmail.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: rndis: dhcp discover stopped working
Message-ID: <20110411212006.GC4227@swordfish>
References: <20110411205440.GA4227@swordfish>
 <20110411210247.GB15419@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ncSAzJYg3Aa9+CRW"
Content-Disposition: inline
In-Reply-To: <20110411210247.GB15419@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ncSAzJYg3Aa9+CRW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (04/11/11 14:02), Greg KH wrote:
[..]
> >=20
> >=20
> > kernel: .39-rc2-*
>=20
> Known bug, a patch was posted that fixed this already...
>=20

Good to hear it! Sorry for the noise.


Thanks,
	Sergey

--ncSAzJYg3Aa9+CRW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAk2jcIYACgkQfKHnntdSXjSi1QP/c0SVA7inAMPCF6JfjRdTMZmP
CT8kSxuN9qjZDdGc/KqXDvxQo9E2uBum1b4WCbHBi1fr9kV9fN8kCamMqRXmYyzD
bOtSv+DyK3v8h3wyCdseLiWDH9UzQ4TLuqWrUvT0giRsWyWPnQedQgAUsSTYuChQ
TNApBGV++jUtopODJjI=
=v3Tb
-----END PGP SIGNATURE-----

--ncSAzJYg3Aa9+CRW--
