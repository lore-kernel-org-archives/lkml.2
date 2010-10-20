Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715Ab0JTWQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 18:16:46 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:53457 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752065Ab0JTWQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 18:16:45 -0400
X-Authenticated: #15668376
X-Provags-ID: V01U2FsdGVkX18IF1cO5mII40HSyTxLL9ju3tctVQjvJ0jcdMjSVh
	diPHO6mO6NIFNW
Date: Thu, 21 Oct 2010 00:16:37 +0200
From: Sven Eckelmann <sven.eckelmann@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: The list for a Better Approach To Mobile Ad-hoc
	 Networking <b.a.t.m.a.n@lists.open-mesh.org>,
        devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Marek Lindner <lindner_marek@yahoo.de>
Subject: Re: [B.A.T.M.A.N.] [resend][PATCHv2] staging: batman-adv: remove
 useless addr_to_string()
Message-ID: <20101020221636.GA21132@sven-atom.lazhur.ath.cx>
References: <1287589664-25447-1-git-send-email-andy.shevchenko@gmail.com>
 <20101020205115.GA18087@sven-atom.lazhur.ath.cx>
 <20101020205749.GA9686@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <20101020205749.GA9686@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 20, 2010 at 01:57:49PM -0700, Greg KH wrote:
> On Wed, Oct 20, 2010 at 10:51:15PM +0200, Sven Eckelmann wrote:
> > On Wed, Oct 20, 2010 at 06:47:44PM +0300, Andy Shevchenko wrote:
> > > Since all *printf() methods in the kernel understand '%pM' modifier t=
he
> > > conversion to the string is useless beforehand.
> > >=20
> > > Additionally this patch decreases batman_if structure by 20 bytes.
> >=20
> > Thanks for your patch. I have problems with compiling due to other patc=
hes in
> > the queue. I will fix that and recommend it as patch for 2.6.38.
>=20
> What do you mean by this?  It applies just fine to my tree, so why can't
> I take it now?

If you want then do so, but the stuff in batman-adv's master must be fixed =
so
they have to apply the v3 version of the patch and not the v2 version Andy
sent.

Best regards,
	Sven

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBCgAGBQJMv2pEAAoJEF2HCgfBJntGFVQP/38xtkOYU2iRb10XKlSAN1si
n/DAwu7cFPciW0+3kP3HspE57nYnKKpe0/QdCH+WTZ2wqeAFdg6bWvzf/n92uz/m
UvMWHlSoTXfEb5bX272w3dHz0PX3XHC+ces+hHmZNCsE9Q9FYY6wrXpGEh8ZF2dG
XTqS9bXGuA3S2F3v8eEoT74Bxs/oYbqD0USVKEIN0U1Te8ST2kug9S5Oz3Fs5TCC
OmEtC8iR+xyk2pp7v3zD2wKCU2ZTLcgl7R70Nvqn3YR3kLu7eTuCARvW3bKdRLj9
qVGJ8KQTLckMzerEpUm/ODK737ZU1k7TExWNc5PY4/UBCnLDGhqUHvz+/LOJ2Dae
XXA8q+ymSwzhlxBw/4lAQ9lYEfy32Q2s2vOwqbnYGK0iQkb3Dh+vOZlFmqOi6zie
VaXTQDXdOhLsmXCdC8fAZvmVyz1NZdtup0f3Ku66kf3opdgK6Pro86AUbltgpOQO
ZOIXG4Ho7ey6sotMdPbKsceBGKpQoRyMWc9Ns+ppJy+j8UoErzkRD5rgWpSM25o+
vf+/tQoh6gCQTZxJzMjoyg2yZhXhY7a0ZnbQ64C7BchPoqg78U/Jhm37vFZcKcvR
J2sITaIm+m5HT2EbzKlrD8FncuOzB/3UZDbO00KpcBtzJiO1K9DAVZWI4/X7uDij
lkdZVbm3GMVxG7eDTqMR
=DLVp
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
