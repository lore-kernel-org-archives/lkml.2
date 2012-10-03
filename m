Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab2JCInL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 04:43:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:40500 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713Ab2JCInH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 04:43:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,527,1344236400"; 
   d="asc'?scan'208";a="229923196"
Message-ID: <1349253794.2017.124.camel@sauron.fi.intel.com>
Subject: Re: UBI: Fastmap request for inclusion (v19)
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Richard Weinberger <richard@nod.at>
Cc: Heinz.Egger@linutronix.de, tglx@linutronix.de,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tim.bird@am.sony.com
Date: Wed, 03 Oct 2012 11:43:14 +0300
In-Reply-To: <20121003103625.0bbff63c@spider.haslach.nod.at>
References: <1348674710-102885-1-git-send-email-richard@nod.at>
	 <1349252745.2017.120.camel@sauron.fi.intel.com>
	 <20121003103625.0bbff63c@spider.haslach.nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-eibFJEnw0vC3l6rsWVA9"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eibFJEnw0vC3l6rsWVA9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-10-03 at 10:36 +0200, Richard Weinberger wrote:
> Am Wed, 03 Oct 2012 11:25:45 +0300
> schrieb Artem Bityutskiy <artem.bityutskiy@linux.intel.com>:
>=20
> > On Wed, 2012-09-26 at 17:51 +0200, Richard Weinberger wrote:
> > > UBI Fastmap is an optional feature which stores the physical to
> > > logical eraseblock relations in a checkpoint (called fastmap) to
> > > reduce the initialization time of UBI. The current init time of UBI
> > > is proportional to the number of physical erase blocks on the FLASH
> > > device. With fastmap enabled the scan time is limited to a fixed
> > > number of blocks.
> >=20
> > Aiaiai complains and linux-next build fails :-( Last time I forgot to
> > enable the fastmap kbuild option so aiaiai checked with that option
> > disabled. Now I enabled it with a simple hack (default n -> default y)
> > and here are aiaiai's complaints - there is a build failure for
> > ARCH=3Di386.
>=20
> Build fix for linux-next is on the way into your inbox.
> I'm currently looking at the aiaiai output.

I've taken a quick look - you call 'kfree(fm)' 16 times in that
function. Even if we get everything correctly, we should probably change
that anyway with goto's.

--=20
Best Regards,
Artem Bityutskiy

--=-eibFJEnw0vC3l6rsWVA9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQa/qjAAoJECmIfjd9wqK0o/MP/2QrW/9xgsXE2VOVIIDBjC0y
DT3gFoX3Q14DkhmGfKS169tzS78Nll66tQdu3/XX/R8LjUaHcI12VRCGfLmko+Cw
bpMLQDj023ME8WhOFBEI4Ul4rJzvvHGUlOlRNn9hRIREpbYkY2rbO5xtYdvKalE0
+Znywv73iLtCYo7cHeFBqaUKkIskZehOmijd3SN62Cx1pr0wZoqekcb+KuunbsIG
WMrYNnJQKi+9P/sAdblSO/ADVOEkkTzdkI348GBoTtuHShnNN7FBUS4KxTbEes86
5eBCOQYXc2ytDteNbiHgAo7Z9oLnRqMQr2F/ZL3mFVGHSxMDMfBNcfbL7faoBuN1
DvxgYuPehXgqqGNKqa8exzrfBM8flyWunGexkuk7Mc/Z75yjlMt+Ci3QXgxVw1bP
5m60HC+1YrJJliXb9WYPM9gdCL4HAKs1rerMkwiFY0I8JaZ09PMRt90/Ws9oToce
4G7ZlaFcCrmYeusa/QaX5WXEgMJVE9kkH61YAdbLuZlphnYKYbTwCEWB+9II71No
trRckklZaeOBGY2aFJlp4BDtcxgbEPe7WlXV1lb4unaQBBeFUv8EuFNpoMjaS0nw
GgqKMrupqt02KGxuynBngoNRofogZGPzpoSZL1GbWqLZ3P8griMVfWO2JMY7TI88
Poq5WNassBm9Uj2Ya6ix
=XjBf
-----END PGP SIGNATURE-----

--=-eibFJEnw0vC3l6rsWVA9--

