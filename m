Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab1CBXgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 18:36:33 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60431 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755036Ab1CBXgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 18:36:31 -0500
Date: Thu, 3 Mar 2011 10:36:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, gregkh@suse.de,
        driverdevel <devel@driverdev.osuosl.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] staging/brcm80211: fix printk format warnings
Message-Id: <20110303103620.6b3c463f.sfr@canb.auug.org.au>
In-Reply-To: <20110302210511.GA20798@kroah.com>
References: <20110301181119.f1c7a9c3.sfr@canb.auug.org.au>
	<20110301162948.34c28d6e.randy.dunlap@oracle.com>
	<20110302210511.GA20798@kroah.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__3_Mar_2011_10_36_20_+1100_rp904KFcoJYszMJm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_Mar_2011_10_36_20_+1100_rp904KFcoJYszMJm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Wed, 2 Mar 2011 16:05:11 -0500 Greg KH <greg@kroah.com> wrote:
>
> On Tue, Mar 01, 2011 at 04:29:48PM -0800, Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> >=20
> > drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c:1379: warning: format =
'%d' expects type 'int', but argument 3 has type 'size_t'
> > drivers/staging/brcm80211/sys/wl_mac80211.c:1827: warning: format '%d' =
expects type 'int', but argument 3 has type 'size_t'
> > drivers/staging/brcm80211/sys/wl_mac80211.c:1832: warning: format '%d' =
expects type 'int', but argument 3 has type 'size_t'
> >=20
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > Acked-by: Roland Vossen <rvossen@broadcom.com>
> > ---
> >  drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |    2 +-
> >  drivers/staging/brcm80211/sys/wl_mac80211.c      |    4 ++--
>=20
> This file doesn't apply to my tree at all.

Maybe due to conflict resolutions in my tree (assuming that Randy based
his patch in linux-next).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__3_Mar_2011_10_36_20_+1100_rp904KFcoJYszMJm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNbtR0AAoJEDMEi1NhKgbsayYH/Rtm68FxFeFTVcS7KLmn1NC4
BgH6yp+a+rVc7n2GshhILwBASCBrgGzDkATW2QqZ6zcfrP2JUQQuxxUXPsRaAqEe
RSNb2AIx3XOJr5KhcYxuC8Vg/bUNs/xrLqSpXAMmaXOTX0A0YrjksUJc4xMSIjal
E1sCtWwpuiBaQTxWHzhFJhShcwEuHP1vPPYUgK7xUbm7l8f8MP2m2+rI7IHJJH0X
l84SECQVrwfM+8Au2WvequGRnVBwhK4Wg6dOvVmZFGMvHUKj1aFmGqG4jqlv8S4W
SHU1folv0T6ejmmY0JXqD2jyFY+hTVWpZeaJx03Ep1RlK0TsGs/6TA7wwc0d8ng=
=ob/J
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Mar_2011_10_36_20_+1100_rp904KFcoJYszMJm--
