Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab2EUN5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 09:57:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:31089 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755616Ab2EUN5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 09:57:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="169160708"
Message-ID: <1337608854.2483.71.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 1/7] [RFC] UBI: Export next_sqnum()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, Heinz.Egger@linutronix.de,
        tim.bird@am.sony.com
Date: Mon, 21 May 2012 17:00:54 +0300
In-Reply-To: <4FBA4448.20509@nod.at>
References: <1337101871-31181-1-git-send-email-richard@nod.at>
	  <1337101871-31181-2-git-send-email-richard@nod.at>
	 <1337173272.24809.52.camel@sauron.fi.intel.com> <4FBA4448.20509@nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-ZVmqaDdU6kPZ8Mtmfu2+"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZVmqaDdU6kPZ8Mtmfu2+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-05-21 at 15:34 +0200, Richard Weinberger wrote:
> > +	/* TODO: Before checking version - check the CRC.
>=20
> The CRC covers only the fastmap data, not the super block.

Everything should be protected with CRC.

> >   	for (i =3D 0; i<  nblocks; i++) {
> > +		/* TODO: you basically perform the scanning here - you should
> > +		 * share the same code as we use in scan.c: use process_peb().
> > +		 */
>=20
> What exactly do you mean by that?
> process_eb() will not help much because the fastmap data is written=20
> "raw" to the flash. (Without any interaction from the WL sub-system)

It still contains EC and VID headers. So you can use the existing code
for scanning it.

--=20
Best Regards,
Artem Bityutskiy

--=-ZVmqaDdU6kPZ8Mtmfu2+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPukqWAAoJECmIfjd9wqK0vGkQAMkOgV6tOpMnivvD8/gCQWNu
sgvjZ7IkmcdvcJRyemYNGpVHaA/vvwTAjFh3fOnPLB+3dmJoJdGRSTQ0CQt1kYFN
34US9nCapc82Jq2LapUngJ/AiPfV4QO6NoN25PMcZHTQsNsy8JGWTXbi7pFsS/Q8
kK8A6mghzQDE08up6q00+NuZrhe8eOmz09GviIod+JIpKVfIU34z7sKcghFdceZw
GibPxJcFyngBwdFs24gB6rMwUC1mnKZzRxpPv+s/0RBoWoXCZEXe1AWDPhFPoyL2
79yAQS2XHOe/95mjfweJEVKct5x2Eb9XU7WLSdqz8eum/u7kU7+/gw3YfDrO2nLh
PYb6MVkxcE5mZBj8/+l7i3EaaF43YKXmWi3kbR2p+JGiK+qmGBQL3sYRVRqagXSW
B3L2GYc8fzCiIeMY372SuwOhvNeQYT9NMQ1ti+iSmxyLHEW31lePOYDpP9km2Z+V
EYZkQA6MYXF2/ZgtWCKq3lkDyfBx3HxX7XkznduiV6DAbzwXkSC5f3yltd/Qtycx
73T6NtSiRoOgMVtaP8S+a7MaKYp5WDGUD1AvwpII4BJ2nA6G6zozYMBZvrt95Zev
CvdMXLJTvQ2DClbfhG5/CLRwEj5yMvyQ5thNarlGOa/5t3bPuo8xmBIf4zdERj4d
5AudAdcZLTTgG50ulGBV
=3/dh
-----END PGP SIGNATURE-----

--=-ZVmqaDdU6kPZ8Mtmfu2+--

