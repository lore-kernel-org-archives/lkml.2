Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab2HBRqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 13:46:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:29401 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754796Ab2HBRqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 13:46:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="asc'?scan'208";a="180837983"
Message-ID: <1343929829.25013.207.camel@sauron.fi.intel.com>
Subject: Re: UBI fastmap updates
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Tim Bird <tim.bird@am.sony.com>
Cc: Richard Weinberger <richard@nod.at>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "Heinz.Egger@linutronix.de" <Heinz.Egger@linutronix.de>,
        "thomas.wucher@linutronix.de" <thomas.wucher@linutronix.de>,
        "shmulik.ladkani@gmail.com" <shmulik.ladkani@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Marius.Mazarel@ugal.ro" <Marius.Mazarel@ugal.ro>,
        "nyoushchenko@mvista.com" <nyoushchenko@mvista.com>
Date: Thu, 02 Aug 2012 20:50:29 +0300
In-Reply-To: <501AB2C8.9010805@am.sony.com>
References: <1341836323-43916-1-git-send-email-richard@nod.at>
	  <1343916747.25013.112.camel@sauron.fi.intel.com>
	  <20120802161512.5ac7a303@spider.haslach.nod.at>
	  <1343917741.25013.114.camel@sauron.fi.intel.com>
	  <20120802165132.1bf1e5d7@spider.haslach.nod.at>
	  <1343924267.25013.156.camel@sauron.fi.intel.com>
	  <20120802183210.7076aa48@spider.haslach.nod.at>
	 <1343925930.25013.163.camel@sauron.fi.intel.com>
	 <501AB2C8.9010805@am.sony.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-B4d5JcB7BaIO4wQ3BTkE"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-B4d5JcB7BaIO4wQ3BTkE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-08-02 at 10:03 -0700, Tim Bird wrote:
> > So can I interpret this the following way. Not only fastmap give no
> > guarantees that it exists after an unclean reboot, it does not even giv=
e
> > guarantees that it exists after a clean reboot.
> >=20
> > Unless I am confused, the fastmap design is over-simplified.
>=20
> Fastmap is an optimization.  Maybe I'm missing something, but
> I'm not sure why, if the optimization stopped working, you
> would want to reduce the functionality of the file system.

Fastmap gives huge improvement in attach time. So big that it becomes
not just optimization, but a selling feature. Or very important
optimization.

If you design a system which requires 1s startup time, you probably want
to always guarantee 1s startup time. E.g., if we are talking about a car
system.

You probably may get away with the fact that in case of power cut your
system starts up 10 seconds at the first boot (no fastmap).

But you probably would be disappointed if I say that even if you do
_not_ have power cuts, your system may still startup 10 seconds,
although most of the times it will take 1s.

Does this description help to accept my POW that while we cannot
simplify fastmap and give no improvement for the power cut cases, it is
quite important to guarantee that in normal cases fastmap is always
there, and UBI will always be fast.

If I buy a car which runs 200Km/h on the asphalt, I am OK if it cannot
do this on the cross-country trails, but I am not OK if it sometimes
cannot do 200Km/h even on the asphalt, when the moon is blue.

--=20
Best Regards,
Artem Bityutskiy

--=-B4d5JcB7BaIO4wQ3BTkE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQGr3lAAoJECmIfjd9wqK0LWYP/RESE+0GIliWW89cAuCzr5Sa
yEXs26ORMu0wOTFzA7cEIRu8+IpS9OLTkuLl+TmLfYtzEenDc+qSp87SxBYJ+Zh9
cuQ7yvAdczXOxLUSaYdjVYUXWbr8DTrTlpOYZBx32rjENYF928ZzUm/qfYLLO/i1
lMmjUNX3hGhfRaJocNT+2HHHsVsczOn0+GRNLrZyKAWDjbNJD/gdcSVVsbPbx50q
mRzp4fVxmV4TXFyxgZavPoMIE5hXhyrxrz7FbgC7BlBSAWeAFV18+R7U8egnibaC
0xfBADU05B3W8EPrHT3wAtWxsKrJN9/Ao/sGwiTHttgW57TmCh/Nojr9ZnhSPRzs
F7w7J24ac6KX+wRoelD8y0fqo5BwtyunFzUnjtZn6jj65zAjql2kqG0A2fPJRj4m
hCi2Dw8+116An/M/BcJlQSExAcdzNd/ySdYmaJrwJe3ogha5QStJDp4WGCfM4Wtr
IGtr2VdaqI/iPpwJNHxp9pHt/sraJTEoTTgSiybDZMPcxh5Lx270OZsPX2nwb+0e
x9OlObCnR4bJgsmTc+V7MH/FIWB25Tbe1dkga+/kwgfuNNszE+87BSwVKhiZiDGX
QK/9zfAzNVyXD9jrbXVqILawgWVuuHtv1+52FVDed8EwoaBubmq71lJ0ooRLDmsd
E6obqsP4DNKsfseYeL2t
=N+jG
-----END PGP SIGNATURE-----

--=-B4d5JcB7BaIO4wQ3BTkE--

