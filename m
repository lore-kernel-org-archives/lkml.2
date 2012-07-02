Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab2GBQve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 12:51:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:46243 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985Ab2GBQvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 12:51:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="187575323"
Message-ID: <1341248135.2979.33.camel@sauron.fi.intel.com>
Subject: Re: ext4 blocks up
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Date: Mon, 02 Jul 2012 19:55:35 +0300
In-Reply-To: <20120702164548.GD18074@thunk.org>
References: <1341231316.2979.11.camel@sauron.fi.intel.com>
	 <20120702144444.GA18074@thunk.org>
	 <1341240862.2979.23.camel@sauron.fi.intel.com>
	 <20120702151442.GB18074@thunk.org> <20120702164548.GD18074@thunk.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-yEEP3voHyr13RjAIxMdf"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-yEEP3voHyr13RjAIxMdf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-07-02 at 12:45 -0400, Theodore Ts'o wrote:
> On Mon, Jul 02, 2012 at 11:14:42AM -0400, Theodore Ts'o wrote:
> > On Mon, Jul 02, 2012 at 05:54:22PM +0300, Artem Bityutskiy wrote:
> > > On Mon, 2012-07-02 at 10:44 -0400, Theodore Ts'o wrote:
> > > > Can you tell me *which* xfstest this was blocking on?
> > >=20
> > > Test 068 which runs fsstress.
> >=20
> > Hmmm, I had just started an xfstests -g auto run using standard ext4
> > defaults with 3.5-rc2, and I'm not noting any problems.  And I've
> > gotten past test 68 w/o any problems.
>=20
> I just tried again with 3.5-rc5, and I was able to reproduce your
> failure by using "check 68 68 68 68 68" (it failed after the 2nd time
> it ran the fsstress test.  What's interesting is that there have been
> no changes in fs/ext4 or fs/jbd2 since 3.5-rc2.  So this may have been
> caused by a writeback related change; I'm starting a bisect now.

OK, cool, let me know if you need help, I'll be able to help tomorrow.

--=20
Best Regards,
Artem Bityutskiy

--=-yEEP3voHyr13RjAIxMdf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP8dKHAAoJECmIfjd9wqK0oEgP/2vEjwpJhUPHwC0GWr59kxjB
LTBhbbj0oraDZxVdZXoJW4EqI7vAjh6NREkp3p9o4jmosvolytyg0zYAP240er7+
pq7ZcBTx4fTVhmx6hETvMpcNKlAK3CqRrSL4mLxYZJc19PJC1TC3mdUDvIlhlYzP
miqEJ2WXiCWy0We+h+oUG1uJ08uFx6+ZpP2RwOUlWPY4FsOikgwtVi7CZIMdX9Rh
STXCU4BL3Aqq+u6VkR0IZPveBdpwGRu9wvgSn3ZJp19DxH2zU8XSItyX3QIwNTV3
pyKiaaSC3VbYtof4eImZyGD//ZCaJNku1b7jhrEYC+YgfYjZXfU+RqtIZzf6Wltw
JJLFx557JDJmJ5uQQfdfV4ukoAsX5mXfPFJ/BXovn0g42WyoxdGCM7W30Cz48ji5
wEt/rcJ+soBB0TjMEr6lifm1PNIl8fgHkmYmuaUP6yc5Qwzfm7DTuu7ArpsGdMEr
7d8eZ/opbCHGRUokNWEdNNuRKCPoQvh9lJ3A7pVSSBaIs7OdEKBBu/J4v6U9XVr9
O8Vc5kz2u8dWLHEca55AOWv+wrIP5dsv7Z+/pXN98Pkw6wazFMdAOaPsUHsAZwiy
ZeqgmJ9sxj64Ix9seX+VhMLdtI2dxF5r8sQoBzZYh+BhRyQ0RmLwDdQKllINtq8i
VCBv6rLmk+w2JI3iSFB6
=QmS5
-----END PGP SIGNATURE-----

--=-yEEP3voHyr13RjAIxMdf--

