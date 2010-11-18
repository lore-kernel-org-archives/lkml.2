Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914Ab0KRAQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 19:16:33 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48558 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370Ab0KRAQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 19:16:32 -0500
Date: Thu, 18 Nov 2010 11:16:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Zimny Lech <napohybelskurwysynom2010@gmail.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: Tree for November 17
Message-Id: <20101118111623.15ec8fc3.sfr@canb.auug.org.au>
In-Reply-To: <4CE46443.2000002@oracle.com>
References: <20101117140956.a8264c75.sfr@canb.auug.org.au>
	<AANLkTinBiGOPptOY18-D+=djKLsJj75mXxL6ht6xNJXL@mail.gmail.com>
	<20101117095920.2b9e2e6a.randy.dunlap@oracle.com>
	<20101118101459.472d540b.sfr@canb.auug.org.au>
	<4CE46443.2000002@oracle.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__18_Nov_2010_11_16_23_+1100_JvCJKvjfPBDpSV3f"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__18_Nov_2010_11_16_23_+1100_JvCJKvjfPBDpSV3f
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Randy,

On Wed, 17 Nov 2010 15:24:51 -0800 Randy Dunlap <randy.dunlap@oracle.com> w=
rote:
>
> On 11/17/10 15:14, Stephen Rothwell wrote:
> >=20
> > Was this fixed before Linus took that patch?  Also, the #include of
>=20
> This build error was in linux-next of NOV. 17.  What mainline base did it=
 use?
> I don't exactly know how to answer your question...

It was a question for Linus and Arnd, as Linus took Arnd's patch this
morning (my time) i.e. after next-20101117.  That patch was in linux-next
for only one day (Nov 17) as it broke my builds the day before and was not
included then.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__18_Nov_2010_11_16_23_+1100_JvCJKvjfPBDpSV3f
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM5HBXAAoJEDMEi1NhKgbsvyEH/2JF8AZ3Tj2Pic1gzMBxGnBf
PAEimbxQmbJHmLv57U6F7NG0iLx6qpIhWAbXgP7F2sZXIlnXlBp3pN7Z5MOIZtDu
w9Cxu+6eW+AkU9Sv2CqOtHVJlctnJPUcChkm7B+vGPwSms7CVjSDL5piBAaoGWmW
WUuZiiDlB1+qaGshgal6/8tZrGw323gwODPn2DzJ06c2uKrL7HU4xCNEJNiqEbZJ
X2JaLtINMXAwMdU5fsD98DrXIxscYt8LLBt7lJsYAJYooGv86/gBRgy0GvBHCXcY
jH2gwu4uaGxJVQaKgbSoC2AqrwCXKEBevyTP9V4nTkEelcYo0NHLQxvA49sAA7o=
=EARb
-----END PGP SIGNATURE-----

--Signature=_Thu__18_Nov_2010_11_16_23_+1100_JvCJKvjfPBDpSV3f--
