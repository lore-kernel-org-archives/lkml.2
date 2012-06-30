Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab2F3OYU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 10:24:20 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41081 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028Ab2F3OYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 10:24:19 -0400
Message-ID: <1341066255.2115.11.camel@koala>
Subject: Re: UBI fastmap updates
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, nyoushchenko@mvista.com,
        artem.bityutskiy@linux.intel.com, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, Heinz.Egger@linutronix.de,
        thomas.wucher@linutronix.de, shmulik.ladkani@gmail.com,
        tglx@linutronix.de, Marius.Mazarel@ugal.ro, tim.bird@am.sony.com
Date: Sat, 30 Jun 2012 17:24:15 +0300
In-Reply-To: <4FEEDAA4.30105@nod.at>
References: <1340982869-77042-1-git-send-email-richard@nod.at>
	 <1341052998.2115.3.camel@koala> <4FEEDAA4.30105@nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-hanPIbi4WpDE1CixyZsI"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hanPIbi4WpDE1CixyZsI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-06-30 at 12:53 +0200, Richard Weinberger wrote:
> So basically you want me to get rid of any vmalloc()'ed buffer?
> That's not easy.

Yeah, I guess it is difficult, we probably can let it be vmalloc() since
we already have plenty...

--=20
Best Regards,
Artem Bityutskiy

--=-hanPIbi4WpDE1CixyZsI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP7wwPAAoJECmIfjd9wqK0+PAP/1LClWFUYFoHdjEamkDV+d6E
F+KFtmC3s0ayD8bMa4nlcbnmGTpu0gqrdakS+WIARsVVRdwJM+Ni4izWeMfRG4P6
jwTmFuG6gDI2alFvy3ThZ2yhH/6ZpjMFtt/Ut6LruogMKymupgGQhai272LWXN8T
3vTxMlXKdhunK21YrY5ZuP1l2xYRuuhsSeWcvOzTiImOsIz71dCHqI9fGYERImhH
hczssMxXSm0T44nH/kusLo3rzRO7rHE+H3MD99xHLyfVWIyKi96ru7O0gBjtY7TL
tcylSbX9HHjJSTHo+ziK7v0EzceOPG8TEaiJxML1BR6reAVd2iQt+4Ug8qKyViyq
K7S9043OzSUUqIIsSH/vXXOWNu8lcSvSL4DcXGjWKss55NWu0s91HPb13KIiJIsQ
41DRr17D/j4z4qY+2JuEimoctXrfdTAGgltHABnTfAB8UtMUp+EnI4v2IAM9Xbme
bilYKDy212+ZKVGlmzLTQdSC0wlc0JemmCCdfTjsS8wEhwaqFHKhDJOR9Wo0xBAq
3Fiab877K0bPCbFK0GTjJWlXmHN7jGMEaxCiGK3LU6+V7mWsIcO3Li476o6y+tpC
ajyRcpDvG2eYcR1arKiQXMz9nmsuLpPl7DeuiqHoG7GKZoMyQG0KMVW4nt3wURC+
pN31D1YV3x5EEBO0JNRR
=EDFu
-----END PGP SIGNATURE-----

--=-hanPIbi4WpDE1CixyZsI--

