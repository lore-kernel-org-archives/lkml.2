Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab2GNLXw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 07:23:52 -0400
Received: from mout.web.de ([212.227.15.3]:53390 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752849Ab2GNLXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 07:23:50 -0400
Message-ID: <500156B3.6040205@web.de>
Date: Sat, 14 Jul 2012 13:23:31 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>
Subject: Re: [GIT PULL] KVM fixes for 3.5-rc6
References: <4FFEBB39.8090308@redhat.com> <CA+55aFwAXbrQRKg_cJT04H_XnoEPjJ0O711C5uA6fRY35DVhKQ@mail.gmail.com> <CA+55aFy=ogfJu3WuoCCDseysxOOn_UEAnv_7Ldsa45VV7fMVPg@mail.gmail.com> <alpine.LFD.2.02.1207131928000.32033@ionos> <alpine.LFD.2.02.1207140208270.32033@ionos> <500118F1.8060300@web.de> <alpine.LFD.2.02.1207141253490.32033@ionos>
In-Reply-To: <alpine.LFD.2.02.1207141253490.32033@ionos>
X-Enigmail-Version: 1.4.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig24E792CD3F43AD76B41FE366"
X-Provags-ID: V02:K0:WWQzrM1MXrGaJDAKxT4K+WVT46UCgeRqiI8rYZzn4Mh
 4hvXXCoOOpZal1uxE4UWtO/Mt6xWh9kAgPCrnWy6oalr9bzAYw
 hmtwJGcMW5eUekPWdJc81ojShB7yYIqkDJjUXFMGcqaLhepTrU
 u0DpInVIK+0F8vZ2I7B+ROl3sp3CXmttlROM2gSXsCWoLznjji
 hOSLj83Y6waOKp0b6fo8A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig24E792CD3F43AD76B41FE366
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2012-07-14 13:16, Thomas Gleixner wrote:
> On Sat, 14 Jul 2012, Jan Kiszka wrote:
>> On 2012-07-14 04:25, Thomas Gleixner wrote:
>> This patch here is a workaround to unbreak devices assignment in 3.5
>> after the IRQ layer changes without regressing noticeable /wrt overhea=
d.
>=20
> Yeah, workaround and regression are the proper marketing buzzwords to
> excuse mindless hackery.
>=20
> It took me a minute to figure out that there is no reason at all to
> use a threaded interrupt handler for MSI and MSIX.

Thomas, we also explained to you in the cited thread that your simple
approach for this doesn't work as is. We will have a proper solution
soon, but it takes a bit more than a minute - at least us.

Jan


--------------enig24E792CD3F43AD76B41FE366
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAlABVrYACgkQitSsb3rl5xSgSgCdGMVV5uZrCZaMFTwhwlq3Z+h8
pXkAn2mBU4EHqWH9igxqdjDjGJQbMAPS
=uVRM
-----END PGP SIGNATURE-----

--------------enig24E792CD3F43AD76B41FE366--
