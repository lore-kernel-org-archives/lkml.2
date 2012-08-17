Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab2HQNgr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 09:36:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:23680 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806Ab2HQNgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 09:36:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,784,1336374000"; 
   d="asc'?scan'208";a="209891153"
Message-ID: <1345210884.27859.90.camel@sauron.fi.intel.com>
Subject: Re: UBI fastmap updates
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Richard Weinberger <richard@nod.at>
Cc: nyoushchenko@mvista.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro
Date: Fri, 17 Aug 2012 16:41:24 +0300
In-Reply-To: <20120817153348.7a0a50a0@spider.haslach.nod.at>
References: <1341836323-43916-1-git-send-email-richard@nod.at>
	 <1345209115.27859.84.camel@sauron.fi.intel.com>
	 <20120817153348.7a0a50a0@spider.haslach.nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-d4NPKFzMMc/5TLuxaVS0"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-d4NPKFzMMc/5TLuxaVS0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-08-17 at 15:33 +0200, Richard Weinberger wrote:
> Am Fri, 17 Aug 2012 16:11:55 +0300
> schrieb Artem Bityutskiy <artem.bityutskiy@linux.intel.com>:
> > We do not do anything like this in UBI because UBI does not need this,
> > it does not have any complex data structures on the media.
> >=20
> > With fastmap - I am unsure. I think it is not a problem, because
> > probably you never append more data, you just re-write everything,
> > right?
>=20
> Yep, the on-flash fastmap is immutable.

Here the question is - if you have PEB containing fastmap data,
half-filled. Will you ever add more data there to the empty space in the
PEB or not?

--=20
Best Regards,
Artem Bityutskiy

--=-d4NPKFzMMc/5TLuxaVS0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQLkoEAAoJECmIfjd9wqK0tm4QAKGjy3YOD8OPMmWQFqXFLkos
MVTkd0t34a8jzZJyvrCVh91D/On8Xrf6blaXa7cUZbrq8C1RSNv9Gi7eYEj0UBEb
aia6BnSVWNeJ5H4PVl0COiLh9yKg4sB992POMX1ZADW6DA/mTvtyxzBCvGGoNxfO
U7rR+EAksSWJ7VHMc/L+66yFOPdYw/r43N8dO7GawRjME8eBtGAQBrlpkZz8uKNS
aWbslXfDg1q8ia9BEq/1ZL7PHp3V2EjTvOTUXg1wy4qInMYpnzsUZ1JLc17agfV/
Rn8LaZALnwPZGAyFTrbDaIk80oK2w+ZGAHpeGzaY+a9vACX21/aGEUkAQ/692Iuy
yDgY/sGi5e809sQBpdUomNSLR+PMmLfYSyiNXohQWoUqlrQzMs3Cbn+aGT8Ycd01
ox+uaGuRoAaw1djX+uyMbNXBMAra02L42blHBeME6kYKngGRcPKIoRUaTndN9etB
hk4PiP73DaS5nlSVGOyOr/cyhh2QaoPXtp10rbwO72eQ4qrXqH7hvkbhPtinoL+b
yyYGMIMtoBCr7TKhH0MJN9uALcJ3aj+H6ENSQo8KxDm8Y2R9tQU+TM22HxfkwUcy
T0IxGw9IP6fKfYRKGBKSp1B00bFPww8/+uv+dlx8nGkXpTHKxmeKKZ2Ae7Mu3ogk
uyQsOGoIjo8H26YOl7G9
=loKh
-----END PGP SIGNATURE-----

--=-d4NPKFzMMc/5TLuxaVS0--

