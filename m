Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab2LIXlK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 18:41:10 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47751 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753900Ab2LIXlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 18:41:07 -0500
Message-ID: <1355096462.20838.95.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 17/27] Revert "sched, autogroup: Stop going ahead if
 autogroup is disabled"
From: Ben Hutchings <ben@decadent.org.uk>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Mike Galbraith <efault@gmx.de>,
        Ingo Molnar <mingo@kernel.org>, Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 09 Dec 2012 23:41:02 +0000
In-Reply-To: <50C227A8.4090606@canonical.com>
References: <20121207005825.232489605@linuxfoundation.org>
	 <20121207005830.838566702@linuxfoundation.org>
	 <50C225D0.9030902@canonical.com> <50C227A8.4090606@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-vrktHq9pKKNj8RmpL46g"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vrktHq9pKKNj8RmpL46g
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-12-07 at 12:30 -0500, Joseph Salisbury wrote:
> On 12/07/2012 12:22 PM, Joseph Salisbury wrote:
> > On 12/06/2012 07:59 PM, Greg Kroah-Hartman wrote:
> >> 3.6-stable review patch.  If anyone has any objections, please let me=
=20
> >> know.
> >>
> >> ------------------
> >>
> >> From: Mike Galbraith <efault@gmx.de>
> >>
> >> commit fd8ef11730f1d03d5d6555aa53126e9e34f52f12 upstream.
> >>
> >> This reverts commit 800d4d30c8f20bd728e5741a3b77c4859a613f7c.
> >>
> >> Between commits 8323f26ce342 ("sched: Fix race in task_group()") and
> >> 800d4d30c8f2 ("sched, autogroup: Stop going ahead if autogroup is
> >> disabled"), autogroup is a wreck.
[...]
> > Hi Ben,
> >
> > Will you also be including this patch in v3.5 stable?  It has been=20
> > tested and confirmed
> > to resolve http://bugs.launchpad.net/bugs/1034099
> >
> > Sincerely,
> >
> > Joe Salisbury
>=20
> Make that v3.2 stable.  Sorry.

Yes, if there's no objection to it.

Ben.

--=20
Ben Hutchings
It is impossible to make anything foolproof because fools are so ingenious.

--=-vrktHq9pKKNj8RmpL46g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUMUhjue/yOyVhhEJAQpH1xAAuiS1Th1xn2FlpFzIedXCyJw9uaHkDk0z
N/vHHCTo7OEdRzQVu5Ybf2zj2Loie+LplwbhLKRnvWWG5qyf6IDEOwYiY+eHmwq+
KItmI136RIBlY+G2AcGXdZ+7pLDvRnnZWi8AvIYbTa2tavwAdWHoyYShfL1VSXpi
M/vbcr1IsqWv6qSwllS9Wx150UBPX7SVQ7YWlt8ylFjeaz/C6buJ9pnkNuuBpy/t
L24EmXWdofHmhw5NWw2aApGCLJBD/ETf+cSxaXuYgT84TNEsLkDauOulzRJcGGsU
A3y4tzXF314zJi3XLbW0S7ISsTzym0tyjPbSjUWMg5Fivs1LH7ACjjjuv9GX1VjG
idw6EXwhOI+xROjf54Gyw6alOMG+kaVf8kFriJvuxqrOllCFj0bgoijhKZ4XYr2X
jPVUJRqV0Jsik0hw1bSI6jA3VTnFX4QLn0vqbuuVeVdPYJHZ8yXqI7ydFBqb66Ww
hHgvvfZ0SNFNYDMwkvDqz+wkPRnB06JeYBvqOXyd2RVhrw6bbop2fs0yy5DEjQX4
sO6qz7UWKOxHpSdWsJjIPrT3A4Cr8n6eK6f3Fm0Hht0tUJ9J8vb6lIdflZcgyMyP
/GF9+B8ZDpao3ec7UJjAEflyiySTS3lcXKukEGQDIfNnniDFJiPDVaJmvd11nzpM
JsueIVYqoQk=
=U+h7
-----END PGP SIGNATURE-----

--=-vrktHq9pKKNj8RmpL46g--
