Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab2HCGnZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 02:43:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:41032 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483Ab2HCGnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 02:43:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="201782629"
Message-ID: <1343976472.1730.18.camel@sauron.fi.intel.com>
Subject: Re: Linux 3.6-rc1
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 03 Aug 2012 09:47:52 +0300
In-Reply-To: <CA+55aFy4vnD5-8SWF_WDC3oTGotzkDg2_4=YHXd6qMiJ=OKekw@mail.gmail.com>
References: <CA+55aFy4vnD5-8SWF_WDC3oTGotzkDg2_4=YHXd6qMiJ=OKekw@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-cw1UambkJ1rDivjBCdCa"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cw1UambkJ1rDivjBCdCa
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Thu, 2012-08-02 at 18:17 -0700, Linus Torvalds wrote:
> Yeah, it's actually only just over 12 days since 3.5 was released, but
> I hate the people who send me last-minute pull requests, so I like
> pulling the rug out from under people who plan on doing their pull
> request in day 13 of the 14-day merge window. If that was your plan,
> screw that.

We have had 11 of 13 pieces of the 'sync_supers()' removal patch-sets
merged. The 12th piece removes dead code in exofs was supposed to go
through the exofs tree and blocked the 13th piece which removes
'sync_supers()' and was supposed to go via the VFS tree.

Both 12th and 13th pieces zap dead code. I man not sure delaying that to
v3.7 would be very beneficial for the kernel (why having a useless
thread waking up every 5 secs?). Would you let us merge this to -rc1?

--=20
Best Regards,
Artem Bityutskiy

--=-cw1UambkJ1rDivjBCdCa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQG3QYAAoJECmIfjd9wqK0CsoP/3J6qkIPHLjZ86Raj8ScwzqQ
joMGsunT19+FgdQun7UBFeJ4nrZft8xfrjmdq0ljVBEddJQvk+SU/kPF33aUXhcz
OaO+0LmJD6URkwXCbT+foy4efGPAI8j3AwKihUfZn8ReHT8HqRTER6xH56a6s4ci
Uxy8LqfrBAi+0kCD21PfKG4LZbfEnXxvfFTJR7SIj/5HFqRzfExQKMZkEiT7eQCH
/QvAhXoKqm0R4HIJQB+z/I185rNadzVazrtMWpAJIvOLpc9dB+4CJy24b0kwwtAf
zMtk3hpY90a38hr4tXN1YNQy6+xN5ioHbM229c9A/MJA+n2SsDTFnVsmwOjoA97R
ZQSBu3IDVpmmaB4vH/fgO8ou3GeFxtgAqFeCz4n5ZUUIpvu4H76a1KGUnCwTkfAu
6wqU7w7a57lhE/4/dGxpip86YaLW9iZO2K1J4IUsrQgtzNMU8VS17qxFUaWAoOPj
ecvnuWS+s8oGObAGXZLtE1nHORlKVKN2iQvVasn26n7LEzz0LGgfXHtKL60G1Mvz
zXZMndSByVmNDY+pOjQPaaM9W+MyAUZ4YwoS2aHV1eLwH1g8ECaSTUAyjQaVJJZO
m4vE2nNmcYXE/3AOenb0xO2ELnRAVg1bbIaJ3e08sRIQLhMQ3vpz4Cjl2wNpH3mz
RU7SENNV+0k6IfuxH4Mx
=ILqo
-----END PGP SIGNATURE-----

--=-cw1UambkJ1rDivjBCdCa--

