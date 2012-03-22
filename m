Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953Ab2CVDBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 23:01:46 -0400
Received: from ozlabs.org ([203.10.76.45]:39841 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758290Ab2CVDBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 23:01:44 -0400
Date: Thu, 22 Mar 2012 14:01:38 +1100
From: Tony Breeds <tony@bakeyournoodle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] Please pull powerpc.git next branch
Message-ID: <20120322030137.GB18735@thor.bakeyournoodle.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Grant Likely <grant.likely@secretlab.ca>,
	Kyle Moffett <Kyle.D.Moffett@boeing.com>,
	linuxppc-dev list <linuxppc-dev@ozlabs.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Russell King <linux@arm.linux.org.uk>,
	Linux Kernel list <linux-kernel@vger.kernel.org>
References: <1332377206.2982.60.camel@pasglop>
 <CA+55aFz-pyBHa73zkbkub4czwnU+k4_qKzBEaAGvi66MBBUTpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="61jdw2sOBCFtR2d/"
Content-Disposition: inline
In-Reply-To: <CA+55aFz-pyBHa73zkbkub4czwnU+k4_qKzBEaAGvi66MBBUTpQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--61jdw2sOBCFtR2d/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Wed, Mar 21, 2012 at 07:02:00PM -0700, Linus Torvalds wrote:

> Ok, so this conflicted a bit with the generalized irq-domain stuff
> from Grant Likely, and while I tried to fix it up I can't even
> compile-test the end result, so you really need to verify my merge and
> perhaps send me fixups. Ok?

/me pimps his toolchains on kernel.org :)
	http://kernel.org/pub/tools/crosstool/files/bin/
Bug reports welcome.

Yours Tony

--61jdw2sOBCFtR2d/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPapYRAAoJEEsCiJRY75GK3jgQAMeWPk0DepxwvhKVYH7mLgTU
DQNULfyEVjZqHhCas4oLsq3z0gB3iSRPhck1Lld6tOCiFzRoQeRVjf0/z57yiJpv
c09IuNtBmuYFplt2nKxwLbskAapRr18gRvJAcYhQFEaseR8f4/t5hV8m6Ic8VPeH
V96lGYHGInh+Dbw7qgl3qewM8WzkcPC0WhyWE5V54cRS5JVQbBbAEDdBsjGTEWZ2
/RVORaw0tkzo9Z4GXfeTJHpsRC/gpN8q5AY8TvXRQhB2CosvxYXNa8keCK0bbbBo
GCv+Tm7qPnEXln33S0imgGGukI1qKRcX1LzUxXtCbUX6VjGDUR0o1keZ68YRROD8
IA95LAPKXOVD+P9JdUNzozUujZZmBqwwpfqboCYAnsfJZV6HB5xqMpdh3fSABP2L
SKlBAW/t9ngUIbYxNsV4PdgKvRVZd1Wmul5V0nF1nAZkT+q8QGiMPhgBJoh93+/U
3z0JjNSfu0bFqpComN0mCzW5MAoS1ymD53fSQfiuD3N4JNqE8McO980jAABfBxFb
paCH8NAeRi8QHlqbGkuqmx49EJB/PnpO3cM0+ttgyZ8RG5TOy9dK82ecDGa2otbM
tqp0Pq4QSqxGrKY+34LprI/UT3gE9JSGZhILAHznYm53ntWRPJWNREUzNhh/o3UV
5oed62Qx0VAE+Thr2+E7
=u9FK
-----END PGP SIGNATURE-----

--61jdw2sOBCFtR2d/--
