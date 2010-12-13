Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab0LMW7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 17:59:46 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:39358 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab0LMW7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 17:59:44 -0500
Message-ID: <4D06A555.2010103@web.de>
Date: Mon, 13 Dec 2010 23:59:33 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
        kvm <kvm@vger.kernel.org>, Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v2 0/4] KVM & genirq: Enable adaptive IRQ sharing for
 passed-through devices
References: <cover.1292152963.git.jan.kiszka@web.de> <20101213101048.GE25590@redhat.com>
In-Reply-To: <20101213101048.GE25590@redhat.com>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig162FAC23995D3A5D49C2F6AA"
X-Provags-ID: V01U2FsdGVkX1/qmL07kqY3w0qBEGjIPvpufpw1mK+OYBlP62Jh
	IADI8FV8vf5gi9lTrHf1C01OKqg5FFdUjyEEvKc+PCCGV7tNEA
	+61pkC24Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig162FAC23995D3A5D49C2F6AA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 13.12.2010 11:10, Michael S. Tsirkin wrote:
> On Sun, Dec 12, 2010 at 12:22:40PM +0100, Jan Kiszka wrote:
>> The result may look simpler on first glance than v1, but it comes with=

>> more subtle race scenarios IMO. I thought them through, hopefully
>> catching all, but I would appreciate any skeptical review.
>=20
> Thought about the races till my head hurt, and yes, they
> all seem to be handled correctly. FWIW

Ouch, I'm endlessly sorry for causing this pain.

>=20
> Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
>=20

Thanks!

Jan


--------------enig162FAC23995D3A5D49C2F6AA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk0GpVgACgkQitSsb3rl5xRBHgCfRFFm58XdQXwISZess1nn9VwI
ohAAoK7P7liYqPZSou7lbMXQzoV93qg4
=gBts
-----END PGP SIGNATURE-----

--------------enig162FAC23995D3A5D49C2F6AA--
