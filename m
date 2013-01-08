Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab3AHD7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 22:59:33 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:41074 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab3AHD7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 22:59:31 -0500
Date: Tue, 8 Jan 2013 14:59:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: James Morris <jmorris@namei.org>,
        LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>, SE Linux <selinux@tycho.nsa.gov>,
        John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v12 0/9] LSM: Multiple concurrent LSMs
Message-Id: <20130108145922.58ab8ad4796076c9d14b6197@canb.auug.org.au>
In-Reply-To: <20130108140159.83c07fa6a680e355f024970f@canb.auug.org.au>
References: <50EB7C50.3070605@schaufler-ca.com>
	<20130108140159.83c07fa6a680e355f024970f@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__8_Jan_2013_14_59_22_+1100_v.GGJ_Tg419Xcrb6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__8_Jan_2013_14_59_22_+1100_v.GGJ_Tg419Xcrb6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Casey,

On Tue, 8 Jan 2013 14:01:59 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Let me ask Andrew's question:  Why do you want to do this (what is the
> use case)?  What does this gain us?
>=20
> Also, you should use unique subjects for each of the patches in the
> series.

You probably also want to think a bit harder about the order of the
patches - you should introduce new APIs before you use them and remove
calls to functions before you remove the functions.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__8_Jan_2013_14_59_22_+1100_v.GGJ_Tg419Xcrb6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ65maAAoJEECxmPOUX5FEgBcQAIqpOgHMJB2E6pbFsoVKtAIN
IjVZ6TQT60pYjYu15PAfzuOXuBD3tJ8hOJTQR8tHG0MxhGc1vLamijD0bKoR2lp6
XoQsz2c1mAFkqiNEqMckP4J7ajHisR1Voq5nDn7FkuOLMRN8vwxCSqfWmCIywu94
o/SIIFDoWOWf22502cWS9QzCluJSBVs5pTSJVWK9W1WdeyWvkuV73rN67/dtQ/tA
HeE0Y4+I/LW1UgRhF/+ezGE/63YPje3Hrh4K5Bl8kNgGlAprzYYuvxbm+fQpf6ai
2YU3NtgvpL0g2jsPYMcHTvEdoh8rcKc9Nh/FHE/Ro2GZgXAjAboCFvDih6d4t2ev
QwJdXMCspBQ1czzAb1J5+951ESxSuS4dWxiHqb+PIJ84GgNMzpwOnckbjMplxtTi
Say+aFR6u/zsO756b0yQmPe7RuLgxHbmwG5QDyuYSPq/t38p6svUWc3v9rbK86CT
8cZicz8oZ5yhXrYOcOwigwmOJCgbAm3FjT6r7ckBCyLaugGfn+k/bs9PuphSKEvh
hkjwQ5BiwiLgStRxXXmbHQAnW8YUeTDU5aOqzy01ZEqgc/EsBB0JiD4MWWdJp10l
NwP2T/5MfKI1sJn50VELhF7lcwZ5lWrRRCxQXqLFHHfPmh0AYjWFM9VIBIO07Z6x
XytPexn6+Dw1v+7pXocA
=O7ri
-----END PGP SIGNATURE-----

--Signature=_Tue__8_Jan_2013_14_59_22_+1100_v.GGJ_Tg419Xcrb6--
