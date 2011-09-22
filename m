Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab1IVKqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 06:46:45 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:43681 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461Ab1IVKqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 06:46:43 -0400
Message-ID: <4E7B1209.3000405@nod.at>
Date: Thu, 22 Sep 2011 12:46:33 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110907 Thunderbird/6.0.2
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        tglx@linutronix.de, Jeff Dike <jdike@addtoit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Will Newton <will.newton@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Boaz Harrosh <bharrosh@panasas.com>, Jiri Pirko <jpirko@redhat.com>,
        Jens Axboe <jaxboe@fusionio.com>, Tejun Heo <tj@kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net
Subject: Re: [PATCH 19/55] um: irq: Remove IRQF_DISABLED
References: <1316681962-8217-1-git-send-email-yong.zhang0@gmail.com> <1316681962-8217-20-git-send-email-yong.zhang0@gmail.com>
In-Reply-To: <1316681962-8217-20-git-send-email-yong.zhang0@gmail.com>
X-Enigmail-Version: 1.3.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCD7C5D6E0CD757D1FCB585B8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCD7C5D6E0CD757D1FCB585B8
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 22.09.2011 10:58, schrieb Yong Zhang:
> Since commit [e58aa3d2: genirq: Run irq handlers with interrupts disabl=
ed],
> We run all interrupt handlers with interrupts disabled
> and we even check and yell when an interrupt handler
> returns with interrupts enabled (see commit [b738a50a:
> genirq: Warn when handler enables interrupts]).
>=20
> So now this flag is a NOOP and can be removed.
>=20
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>

Acked-by: Richard Weinberger <richard@nod.at>


--------------enigCD7C5D6E0CD757D1FCB585B8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iQEcBAEBAgAGBQJOexIJAAoJEN9758yqZn9eHV0IAMflEqTvHKFm2orgjCmVNvBz
CFoVsLZbck1UMVmBhE+gcbT473A1aMUPsyXFVggCOjEvdHeaXwKp6jEAS8GeuMEN
KWJiKnJ/D6i01FrnDCxWTMDFcqEfJbHO12eCo7UrXnLC/PmglcBR596BBRnp7Vnt
W83v3ssMd4iL6hqz0V/4dI1TmAK6otRUTn8KjZ22lxY69QgtoAVSSh0jJQmazctO
QtwOFe/V12/NtmUUw0s2Azc2yPKKEfW0nGK7MU0sommsWDDNwAzBuI8lfNNW3LAK
6q5JSnoHYGPdJIhZPlid5mzNe4WiP4PLSsC4MG+p1a2UMZK9lGOuq0aYtkQLXgg=
=cPjO
-----END PGP SIGNATURE-----

--------------enigCD7C5D6E0CD757D1FCB585B8--
