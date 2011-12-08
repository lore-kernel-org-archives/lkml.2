Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab1LHWAa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 17:00:30 -0500
Received: from ozlabs.org ([203.10.76.45]:44656 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075Ab1LHWA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 17:00:29 -0500
Date: Fri, 9 Dec 2011 09:00:24 +1100
From: Tony Breeds <tony@bakeyournoodle.com>
To: Subrata Modak <subrata@linux.vnet.ibm.com>
Cc: Linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Mark Wizner <markwiz@us.ibm.com>, Naveed <naveedaus@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Manas k Nayak <maknayak@in.ibm.com>, Pavaman <pavsubra@in.ibm.com>,
        Vishu <svishuku@in.ibm.com>, "divya.vikas" <divya.vikas@in.ibm.com>
Subject: Re: [linux-3.2-rc4 PPC64] Series of "Section Mismatch" warnings, are
 they expected ?
Message-ID: <20111208220023.GA20353@thor.bakeyournoodle.com>
Mail-Followup-To: Subrata Modak <subrata@linux.vnet.ibm.com>,
	Linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
	Mark Wizner <markwiz@us.ibm.com>, Naveed <naveedaus@in.ibm.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Manas k Nayak <maknayak@in.ibm.com>, Pavaman <pavsubra@in.ibm.com>,
	Vishu <svishuku@in.ibm.com>, "divya.vikas" <divya.vikas@in.ibm.com>
References: <1323371433.23534.8.camel@subratamodak.linux.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
In-Reply-To: <1323371433.23534.8.camel@subratamodak.linux.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 09, 2011 at 12:40:32AM +0530, Subrata Modak wrote:
> Hello,
>=20
> While compiling linux-3.2-rc4 on PPC64, i get the following set of
> warning series. I wanted to know if they are expected, or, they need to
> be fixed:

If you have time they should be fixed.

Yours Tony

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO4TN3AAoJEEsCiJRY75GKwsAQAL9paf+ksuBD0EZSDQ5hBSYE
BGb6pPeMm+ayHXJuVuRIG8wA7FU350BNIq1AejCniIYtFDw1s60bFAYwYgG7xufb
vBBpF/7uAUfEArRWdVSirA/9bYQ0GDnt5sdL+wcO9mZdOYC+OfHcmPas5wLkLRCs
zUI7NF5fwc/bx9ua+VQ09nkGbbgCTs9TLcnw2+t9LRmLxj8k+aRjbYEd3+Ub+y0i
Pka86Vunm3rPDwP2oA95HruxKBX96E55EnC7nWxqwdrraLnuw+YlZui//vcXygar
y2H8/PvNCkbyzL7Aj4jLzsm25Lgg9NhyYr4r9qJb2qPk41RYukeoQWrMzwXv2tSg
EB5gC9lEiaSxyZm8xHRhgqwU01o/yN/oCtxqHFsj3xgB4iMZNOI5WQmShcSkgN5Q
P7DW4DA3AxWgQcCu+nY3fSvY9SMz/6v2xuQp5y+YtY7ZcADmCkTl7px33fJplMD9
Xp+5dH/GOiwzzVWXEI7yq7NCTdmuAqJHnW4xG4hXb2qf1SJ4/3j51o8xLBWKMkAb
bMAN/quGYT4QAKs+kcPGHewHM1iCNQT+BBSliyy1+6f/Py9NlEPgkzHty4t90fei
O04a8nwzIm0g0gKeADJYwOAzalUvfcr2Y8K6J5Lv6JD+3kYmeEltolHnrEVrrGfB
AaFmOGDnmtW5KFeF214W
=E2cQ
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
