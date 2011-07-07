Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab1GGDze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 23:55:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33845 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753186Ab1GGDzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 23:55:33 -0400
Subject: Re: Bug#632923: linux-tools-2.6.39: perf tries to read ./config,
 fails if it is not a perf config file
From: Ben Hutchings <ben@decadent.org.uk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: 632923@bugs.debian.org, Christian Ohm <chr.ohm@gmx.net>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110707024506.GA32088@moongate.localnet>
References: <20110707024506.GA32088@moongate.localnet>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-Kw5rg2zDNjGvzNLnUKVE"
Date: Thu, 07 Jul 2011 04:55:13 +0100
Message-ID: <1310010913.4280.36.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Kw5rg2zDNjGvzNLnUKVE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2011-07-07 at 04:45 +0200, Christian Ohm wrote:
> Package: linux-tools-2.6.39
> Version: 2.6.39-3
> Severity: normal
>=20
> Hello,
>=20
> When running perf, it looks for a config file in /etc/perfconfig,
> ~/.perfconfig, and ./config (according to strace). If ./config is not a
> perf configuration, it fails (or possibly does unexpected things). Since
> "config" is a quite generic name (I have 175 files with that name on my
> system) it would be nice if this is changed to e.g. ./.perfconfig.

This indeed seems like a misfeature.

Is perf supposed to be invoked in directories dedicated to its use?  If
not, why should it expect a generically-named file to belong to it?

Ben.

--=20
Ben Hutchings
The most exhausting thing in life is being insincere. - Anne Morrow Lindber=
g

--=-Kw5rg2zDNjGvzNLnUKVE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUAThUuGue/yOyVhhEJAQrJQA//WDiXqjvagX1lx9K+M/3lK0im/ee852aq
raj6vVdGFkdjrdifc1VcwYDNF2bv6pyLxamiO7eWb93ZAWCEWnWTyFtaVZ+4na00
XorkV7VNQW0g6hTWQGuuKI+LvyQPGvzJNXntu5U9nomJV5Y3pFAcR5KD/2ZPTcjh
iLM5Ck/LgIswTNfj47rC7ntR6HP1A1qrn7kCP/paKgvd8GK9mAKRGW+VOTaZ2lKI
N0mAFY4nDQGgksV5OUoBc/3vDhkIKiS+uhthksHIncjT50i6N9Tvu42xJj2WTplA
ZPjipwOqm/F3Jzrz8V9jrFs3tuhSC2fmF2X0BEri2RI7CPaBXX7AsJsxKIjwHwCR
sST8f6bzDPI/rtnd9DD57tHFRzJ2EWpR4MWbG9ApGE0t04RD5I/SvKSkFUtBnYsh
c/Fnr/lMIvaR2bI99EJTLqh4y2TB1WdIpyf1r4cRehOf8eVXXcj/2iiI+VaFfzI/
KZZboQZqcDZaGvjon6qt3X9UMctfL1EmQO5pAUHBpIY4YApq+DwzOCS6my2Y9KxL
6oVxpbFp8h6Or22K7gTbBi6UVj4bqFuCX9Qz2VidhAZUquh8yIaT+tlYzlp6sMfj
NwIXHUWJgTGR8PkgB71qc2mY329d6bWoaYvEugPrpUrEiTGdneNkN2VqtNXcSlj7
IqUcsH9UfJw=
=vjk0
-----END PGP SIGNATURE-----

--=-Kw5rg2zDNjGvzNLnUKVE--
