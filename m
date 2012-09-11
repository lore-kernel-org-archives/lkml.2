Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874Ab2IKHAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 03:00:42 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:35961 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757721Ab2IKHAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 03:00:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ag4FAHHgTlBbdWObgWdsb2JhbABFhgetJyKIACIBARYmJ4IgAQEEASNWBQsLEQMBAgEqAgJGCQgGCgmICgqoc5MiiwyFJIESA6higWE
X-IronPort-AV: E=Sophos;i="4.80,403,1344204000"; 
   d="asc'?scan'208";a="949652613"
Message-ID: <1347346908.4539.70.camel@fourier.local.igalia.com>
Subject: Re: [PATCH 01/20] Staging: ipack/bridges/tpci200: Put the TPCI200
 control registers into a struct.
From: Samuel Iglesias =?ISO-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, Jens Taprogge <jens.taprogge@taprogge.org>,
        linux-kernel@vger.kernel.org, industrypack-devel@lists.sourceforge.net
Date: Tue, 11 Sep 2012 09:01:48 +0200
In-Reply-To: <20120910182941.GA25400@kroah.com>
References: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
	 <20120910182941.GA25400@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-R2R0u1CdwpNzIi65eWSn"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-R2R0u1CdwpNzIi65eWSn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-09-10 at 11:29 -0700, Greg Kroah-Hartman wrote:
> On Mon, Sep 10, 2012 at 10:51:39AM +0200, Samuel Iglesias Gons=C3=A1lvez =
wrote:
> > From: Jens Taprogge <jens.taprogge@taprogge.org>
> >=20
> > This saves us from a little pointer arithmetic and cleans up the code a=
 bit.
> >=20
> > Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
> > Signed-off-by: Samuel Iglesias Gons=C3=A1lvez <siglesias@igalia.com>
> > ---
> >  drivers/staging/ipack/bridges/tpci200.c |   28 +++++++----------------=
-----
> >  drivers/staging/ipack/bridges/tpci200.h |   21 +++++++++++++--------
> >  2 files changed, 20 insertions(+), 29 deletions(-)
>=20
> This patch doesn't apply to my tree for some reason.
>=20

OK, I will rebase my repo and send them again.

> Also, all of your patches are in base64 mode, which makes it impossible
> for me to fix them up by hand for issues like this.
>=20
> Care to redo your series, and fix your email client, and resend them?

It's quite strange... Looking at the headers of my local copy of the
patches I see the following:

--------------------------------
[...]
Subject: [PATCH 01/20] Staging: ipack/bridges/tpci200: Put the TPCI200
control registers into a struct.
Date: Mon, 10 Sep 2012 10:51:39 +0200
Message-id: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
X-mailer: git-send-email 1.7.10.4
Mime-version: 1.0
Content-type: text/plain; charset=3DUTF-8
Content-transfer-encoding: 8bit
--------------------------------

I don't see the base64. However, I will try to figure out how can I fix
this issue in git-send-email.

Thanks,

Sam

--=-R2R0u1CdwpNzIi65eWSn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlBO4dwACgkQWrfbyfmd9eIheQCgm4X3KKh7izPr7T+D9NhWhr8J
pSQAn2EYi9IRAYJnE2mJcQLp30TU+68w
=zYw9
-----END PGP SIGNATURE-----

--=-R2R0u1CdwpNzIi65eWSn--

