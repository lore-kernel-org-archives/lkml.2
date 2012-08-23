Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030397Ab2HWOqO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 10:46:14 -0400
Received: from gerolde.archlinux.org ([66.211.214.132]:48822 "EHLO
	gerolde.archlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933655Ab2HWOqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 10:46:12 -0400
Message-ID: <50364230.2070606@archlinux.org>
Date: Thu, 23 Aug 2012 16:46:08 +0200
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Feng Tang <feng.79.tang@gmail.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Peter Tyser <ptyser@xes-inc.com>,
        Wim Van Sebroeck <wim@iguana.be>, Aaron Sierra <asierra@xes-inc.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-watchdog@vger.kernel.org,
        Tobias Powalowski <tpowa@archlinux.org>
Subject: Re: Serious regression in 3.5's iTCO_wdt, does anyone care?
References: <50363B12.4060009@archlinux.org> <CA++bM2tMVLQLn2=_MwhEp79xJpj6fjz+Smd5ZpE5dLKObe+hCw@mail.gmail.com>
In-Reply-To: <CA++bM2tMVLQLn2=_MwhEp79xJpj6fjz+Smd5ZpE5dLKObe+hCw@mail.gmail.com>
X-Enigmail-Version: 1.4.3
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------enig7BAFBA323F1005E6D9157BBC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7BAFBA323F1005E6D9157BBC
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 23.08.2012 16:35, schrieb Feng Tang:
> 2012/8/23 Thomas B=E4chler <thomas@archlinux.org>:
>> This regards the following commit in the Linus tree:
>>
>> commit 887c8ec7219fc8eba78bb8f44a74c660934e9b98
>> Author: Aaron Sierra <asierra@xes-inc.com>
>> Date:   Fri Apr 20 14:14:11 2012 -0500
>>
>>     watchdog: Convert iTCO_wdt driver to mfd model
>>
>> Ever since the Linux 3.5 update, the iTCO_wdt driver has been complete=
ly
>> non-functional on every machine I encountered due to the above
>> conversion. A bug report for this problem has been open at
>> https://bugzilla.kernel.org/show_bug.cgi?id=3D44991 for over a month.
>>
>> Yet, neither the author of the commit, nor the people who signed off o=
n
>> it have reacted to the bug report.
>>
>> At this point, I believe that none of you are actually aware of the
>> problem and I write you to change that unfortunate situation.
>=20
> There is already a patch posted for this bug, pls check
> https://lkml.org/lkml/2012/8/14/309
> and the discussion

And there I thought I had searched the LKML for lpc_ich and iTCO_wdt.
Apparently my last search was more than a week ago.

Would have been nice if you posted the link to the discussion into the
bug report, this would have saved me (and others) some trouble.

Thanks anyway, the discussion has all the information I needed. Sorry
for the noise.



--------------enig7BAFBA323F1005E6D9157BBC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBCAAGBQJQNkIwAAoJEChPw0yOSxollT0P/0RHYnRZ6BCncBeF9Mb0qPzJ
/+7mUWbz60Tr61pr0diqE0tXCVZxdDwUU8rUyC0h1pwZ2tP8Eoui7yP3dUB/Ncfv
FAeXDvbAc+qopP1flNmGhrJiBHrnplHqu6lMWJ4QR5kW6nN9d4KgMJIdZQgF5NLf
sz5C2Km4Pc/L2//Y0rGx+pByyaf8vg8/rdAWQtMoaKgUDAIXrX3oxKTWmYElRjgr
OOoaRgdB1JUu4dSKQd/W5gNsptHCqd5qjDQ7nyhdgxIVAuHDBvV6XpWIU9ixKnfu
OcCnJbSremL3ULBgxmKeVU36cy87MfxlNTcxvva/X3TI/9OVEu4KivEDBDwQKnlD
FvXQ89G0uJCzwNLwOAoSiZgSY3G83OfHlDwOYJa6kpeHMzrP2zTS8WAaPseAXeZi
R62YRQz7W9zbrl8FC3tU4IOda9lkHBxs/GaU7NgVrxI0IgX2Wvk+PxCM7WhfxZuC
LZDIHK0ZGnyFkHWdPj09A9B98RXeUWpa+BT3KXTxa1W8YraY7hJAL6n5zjgsK+LK
+L2HPSaw2IozYE4FLiUbtvEoHMZJZJ81Ohpdex62Hk4ltKBb8FCcyOHH+GCdwd+E
3dEfYkJPiaollZnl4zlJW+ICYy29DvLTL9UWIl21lOn8HscMpCKezg+U420ve+qe
8EJ+pnn6ItNaEIDNNQ/1
=zSbr
-----END PGP SIGNATURE-----

--------------enig7BAFBA323F1005E6D9157BBC--
