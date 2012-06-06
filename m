Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab2FFPnM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:43:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:11488 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073Ab2FFPnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:43:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="asc'?scan'208";a="153754941"
Message-ID: <1338997617.6875.73.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 7/8] kbuild: move W=... stuff to Kbuild.arch
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Date: Wed, 06 Jun 2012 18:46:57 +0300
In-Reply-To: <20120606153521.GA30811@merkur.ravnborg.org>
References: <20120505080640.GA13773@merkur.ravnborg.org>
	 <1336205926-13946-7-git-send-email-sam@ravnborg.org>
	 <1338977927.6875.29.camel@sauron.fi.intel.com>
	 <20120606153521.GA30811@merkur.ravnborg.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Pp5z9Bohj9mYUA8qyLWF"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Pp5z9Bohj9mYUA8qyLWF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-06-06 at 17:35 +0200, Sam Ravnborg wrote:
> On Wed, Jun 06, 2012 at 01:18:47PM +0300, Artem Bityutskiy wrote:
> > On Sat, 2012-05-05 at 10:18 +0200, Sam Ravnborg wrote:
> > > Prevent that we eveluate cc-option multiple times for the same
> > > option by moving the definitions to Kbuild.arch.
> > > The file is included once only, thus gcc is not invoked once per dire=
ctory.
> > >=20
> > > Another side-effect of this patch is that KCFLAGS are appended last
> > > to the list of options. This allows us to better control the options.
> > > Artem Bityutskiy <dedekind1@gmail.com> noticed this.
> > >=20
> > > Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> > > Cc: Artem Bityutskiy <dedekind1@gmail.com>
> >=20
> > Hi,
> >=20
> > what happened to this patch? I was fixing the real issue I am
> > encountering and I thought it'd be taken instead of my original patch.
> We decided to move this to next merge release because is was not added
> to kbuild thus not enough exposure in -next.
>=20
> I am planning to resend the serie at around -rc2 time.

OK, thanks for the update!

--=20
Best Regards,
Artem Bityutskiy

--=-Pp5z9Bohj9mYUA8qyLWF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPz3txAAoJECmIfjd9wqK0sHcP/itabXIMVyq99cFNMX8dYOlD
TNfbSGIr6dsQXyGOTeWqOcxzdHg/3BjvNN2vkPjevDhx/CzrixI8EkUXIdbmUKTV
J3PrEzflTwk+42ESsWWiH5fN8pha71sj1dolEO8VfeK5mhXmlfKNcynjfi8ercGc
GBVxbsB4uEOYSfYycj7Kw2aF4lK2SiW4q7KVYMKevdZrfpnfnKgReZo3wGGO/6gV
WnkmZwpbX/Zd5PVADCiVqcPhyZ0+V7OoWsYGf0o3SVVT/p9BqJxxFJp/+XClAMMI
RlvS0c+n3PFvJf8BilnK9+QA6GvlGld9d14BHAtIrysspISLPjCJtshkutQmVQV2
rmFxEHqhhoErKMo9RMK+2gS3EfS/lf4Cyq9wg3BjEvvpdmnTE72687cmSzeHbQPy
wCXczUKI8eE8ydA9iF/WYjp1lbH0sdBtQZDaH4L7oqQRByoBITNgLSx+c4PxVgQR
YgUz+2cb/WE/djqzeuV09Qyylk9HZBg161rBqPsyA3ri5oVMUNo4+5rQNqb/vk1T
oWPkfWFQ/WxWQAZ0Iap5myWZXmH4xxpl7MrObNsMWc6GzwrKCsTdFPZfQDf2g94l
T6JhvHZp4o6hOBux6FhHZzOn6TDOGj2ATftodN67LvHwC2i5Zuiyx10CTiwqYaIT
GiWLqt6+M9mgJCQTKXrH
=tqHy
-----END PGP SIGNATURE-----

--=-Pp5z9Bohj9mYUA8qyLWF--

