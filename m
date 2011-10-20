Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab1JTVOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 17:14:38 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:53402 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948Ab1JTVOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 17:14:36 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Kyle Moffett <Kyle.D.Moffett@boeing.com>
Subject: Re: [RFC PATCH 05/17] phy_driver: Make .read_status()/.config_aneg() optional
Date: Thu, 20 Oct 2011 17:14:31 -0400
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc4; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        David Daney <ddaney@caviumnetworks.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Baruch Siach <baruch@tkos.co.il>, Thorsten Schubert <tshu@msc-ge.com>,
        David Decotigny <decot@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>, linux-doc@vger.kernel.org
References: <1319144425-15547-1-git-send-email-Kyle.D.Moffett@boeing.com> <1319144425-15547-6-git-send-email-Kyle.D.Moffett@boeing.com> <201110201710.17519.vapier@gentoo.org>
In-Reply-To: <201110201710.17519.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5142648.7MtJnzBNX1";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201110201714.36533.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5142648.7MtJnzBNX1
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 20 October 2011 17:10:12 Mike Frysinger wrote:
> On Thursday 20 October 2011 17:00:12 Kyle Moffett wrote:
> > Approximately 90% of the PHY drivers follow the PHY layer docs and
> > simply use &genphy_read_status and &genphy_config_aneg.  There would
> > seem to be little point in requiring them all to manually specify those
> > functions.
>=20
> well, it does make sense if you think about the compile vs build time
> overhead.  yes, your patch does make things much nicer to read, and a
> little easier to maintain the source.  however, it adds runtime overhead
> (checking the func pointers) while the func pointer storage is unchanged
> (it's now a NULL pointer instead of pointing to the genphy funcs).=20
> personally, i think the savings in runtime and smaller compiled code is
> more important.  so i'm going to NAK this.  sorry.
>=20
> > This patch makes it much easier for subsequent patches to split and
> > refactor the functionality of the .config_aneg() method.
> >=20
> > Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
> > ---
> >=20
> >  Documentation/networking/phy.txt |   13 +++++--------
> >  drivers/net/phy/bcm63xx.c        |    4 ----
>=20
> hrm, what tree are you using ?  this driver is not in mainline.

ah, sorry, i was thinking this was u-boot since we were just having=20
conversations there.

since this is Linux, and i don't have real standing in the general netdev=20
community, i can't really NAK here.  but i think my comment still stands in=
=20
that this patch makes things much worse than the minor code style improveme=
nt.
=2Dmike

--nextPart5142648.7MtJnzBNX1
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJOoI88AAoJEEFjO5/oN/WBMmAP/2BsSUbzSvgOTESRndxdBpqF
Rw7N+gjTZQU3PDPb/iludahsqM4PGuXWFcgRreoDyTJ918NUcjum7kQ7i4zOEEJK
nBxDWe8XUjbYbMbaluiKbhRfWjbulxBqCZfylVBjKc9O0GmAoxmF7bXSz77WnRdm
v0582vceusJ4YKuwI3ZQoY0FC8HrBT8MBQ4yCk6W5HQVFMZyJ53Y1Cbp3bQjmWDW
dxrcnDQNu1x6b5ruArO4zg7O0oMVPxIONalbORnjSHf0UmxH1Sn1N47Sl/sBckP6
IHIvwkFDK3sWSwPU2B6NB9rU3QjWeNR/Pw8uTb7RwihIbaVZlKMWp4+12O9wQCIa
/2CsZkuswcN4W4plpVtivVnJ4U0zjU5Yc3W4ai28pyYlmWGPBn7xB7PQtnMRsGy8
cnR1mrlCcwpTYVPk04hGaLFm03lO68KHL7s1OZBKGrU9XQtmMXtJbzjntgdx38+w
kkw4NyOccNw2Cj8reB0bTWyDzOzpmhKSLf61laKfWMWot+qCKcD9kk5O6yhCvA/e
FuCaEQ1ONBUy3GKfnQ+luQ8Ufvg+1UoOS5yYY21u1cHDi/aZeIjObcMgoweFGGbI
4H0DSltANAvSUgPP3zgeqv3jZKjsE9GOOIwPuzuuqF+MiSFhKsbTFju4Djiq8rI+
wBYlO9OvzNfG9eENaBSg
=igM+
-----END PGP SIGNATURE-----

--nextPart5142648.7MtJnzBNX1--
