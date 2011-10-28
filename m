Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab1J1Kyl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 06:54:41 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:34554 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755059Ab1J1Kyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 06:54:40 -0400
Message-ID: <4EAA89EB.4020503@nod.at>
Date: Fri, 28 Oct 2011 12:54:35 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        Jeff Dike <jdike@addtoit.com>,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net
Subject: Re: [PATCH 18/49] um: irq: Remove IRQF_DISABLED
References: <1319277421-9203-1-git-send-email-yong.zhang0@gmail.com> <1319277421-9203-19-git-send-email-yong.zhang0@gmail.com>
In-Reply-To: <1319277421-9203-19-git-send-email-yong.zhang0@gmail.com>
X-Enigmail-Version: 1.3.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF977B42524113E1953A58BE1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF977B42524113E1953A58BE1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 22.10.2011 11:56, schrieb Yong Zhang:
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
> Acked-by: Richard Weinberger <richard@nod.at>

BTW: I think it's better when I carry this patch through my UML tree.
Okay?

Thanks,
//richard


--------------enigF977B42524113E1953A58BE1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iQEcBAEBAgAGBQJOqonrAAoJEN9758yqZn9easAH/0A1JSqAAvhdCaoUqxMdsqc3
ImfhENr8E+JYMovspXz93m+H21McaT4ns5cg3kTn54te/21CpGxzp9Xy+Be9J5Cx
giVI0nhB2JGvAdMeo75thJFsLX99srf+HmkgYMb6zC0/QUtzQm/Qg1iowZAZmGn3
TZ80Iu9LwhjPCC8RZooiGHgYHLyn0WJgy8C9lYzDOm0yoKPNnMPOM031q3pyNrS9
W+UUpVR9f75kyCAcz5S9xxB+HOdRcM6XfJDsybZZ+QX9ZlVOlyMn6ah8WBDO2JpB
De2ykCJYDQZjZd5z5pLvEeFGsxDMbLXp37dgxice1bfGK408LlqWDPP9cOadNgk=
=sM73
-----END PGP SIGNATURE-----

--------------enigF977B42524113E1953A58BE1--
