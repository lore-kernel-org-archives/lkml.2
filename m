Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab1KZCcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 21:32:46 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:29200 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab1KZCco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 21:32:44 -0500
X-Greylist: delayed 587 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Nov 2011 21:32:44 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap8EAH9M0E5bdWOb/2dsb2JhbABEhQOnAoFyAQEFIzMiARALGAkWCwICCQMCAQIBJx4GDQEHAogDBqRgkS6JTIEWBI4BgRSFNZIM
X-IronPort-AV: E=Sophos;i="4.69,575,1315173600"; 
   d="asc'?scan'208";a="443131971"
Message-ID: <4ED04D73.7010703@igalia.com>
Date: Sat, 26 Nov 2011 03:22:43 +0100
From: Carlos Alberto Lopez Perez <clopez@igalia.com>
Organization: Igalia S.L.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
CC: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 3.1+ iwlwifi lockup
References: <20111031143408.GA17152@redhat.com> <1320179254.31823.130.camel@wwguy-huron>
In-Reply-To: <1320179254.31823.130.camel@wwguy-huron>
X-Enigmail-Version: 1.1.2
OpenPGP: id=6B95F882;
	url=http://key.neutrino.es
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig6BA58511676EDF93F870BCDA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6BA58511676EDF93F870BCDA
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 01/11/11 21:27, Guy, Wey-Yi wrote:
> Any more information to help us understand how to re-produce the issue?=

> without more data, it is really hard to root cause and fix it.
>=20
> Thanks
> Wey


This bug (or a related one) triggers on my laptop (Dell Latitude E6420)
since I switched from Kernel 3.0-debian to 3.1-debian (AMD64). I believe
that the bugs happens after waking up from the suspension-to-RAM.

Since I switched to 3.1 Kernel after waking up from suspension my laptop
freezes very often and I need to hard reboot it, this is really
annoying. This wasn't happening with 3.0 Kernel and I believe that
iwlagn is the cause.

I have an Intel Advanced-N 6205 (rev 34) wireless card.

The other day I was able to get the following kernel errors after waking
up from suspension with this 3.1 kernel[1]

This 3.1 Kernel is the Debian precompiled one (linux-image-3.1.0-1-amd64)=


$ uname -r
3.1.0-1-amd64


[1] Find here the dmesg part that comes after the wakeup from suspension:=


http://people.igalia.com/clopez/iwlagn_dmesg_3.1.log.txt


--------------enig6BA58511676EDF93F870BCDA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBCgAGBQJO0E1zAAoJEJZQic5rlfiCtUkP/2NFV+JWfaJUEiYK1a2c5XlU
pkR3gk+LuZLz7ruOe6+wYDtGZ+bKkzbRAPtpr3dTGpkR1XrxGnzrTISux4vF633O
h4tZZ+uMHyXzdUYuOIpYmwIPsBCnueMK/i2clv+3tA0Ew5MSwrqfVXdRB+eNIQ/K
+r81WLXO/PXpa4QdqSXQf3wXuESxyUADGusKobFasASOdAkyK1BeDOPcL9c/WqB0
/1Hi91eFf911j8qvOLqMnrxK/iCkwZLPeO/XR5d4k+q+AGDxB6G3V8LQWgKJ18WW
smD75wits+V9ekmrq1tdywlTsDGO+kkmL0L4HTg2vlevFJt0Q8hQjp0WrWRgcBK8
C37GfM2BpAPZH+epO3fqQsTa1JqqQpIG89mbKjU4LRuI6tCtTtHp2AD8Ht7sHgys
nzFlDLYi9lCA+f8pUaznOf9VeoX+wchlFfXvPkbw1edEto5heMQ1VRzC+Z7Q1ugp
C95xQ5F7tAyKk+b+9MTO9DEIGPgS43XN3drdIfbqlR4fs/F17e3MWhFUBT8iY706
LTBJ2H4ndrLZfjuTNvJ3IiYYcFc5eeTjvEs8V6ExTQ1ORDnbOlIIteLYmgBOuh0L
STwlY+MHcauCCyQFEvH/Za4ZvwIDgMD89FgAQimtc9lpXwhFPNcIlChahnbiHXqH
nEOAFO6FImB691jK52QQ
=yj11
-----END PGP SIGNATURE-----

--------------enig6BA58511676EDF93F870BCDA--
