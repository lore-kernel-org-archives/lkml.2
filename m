Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab2HOJgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 05:36:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:55920 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab2HOJgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 05:36:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,772,1336374000"; 
   d="asc'?scan'208";a="186645623"
Message-ID: <1345023683.3393.116.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 7/8] kbuild: move W=... stuff to Kbuild.arch
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Date: Wed, 15 Aug 2012 12:41:23 +0300
In-Reply-To: <20120606153521.GA30811@merkur.ravnborg.org>
References: <20120505080640.GA13773@merkur.ravnborg.org>
	 <1336205926-13946-7-git-send-email-sam@ravnborg.org>
	 <1338977927.6875.29.camel@sauron.fi.intel.com>
	 <20120606153521.GA30811@merkur.ravnborg.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-sCUg/H3SQY31auS5IMoL"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-sCUg/H3SQY31auS5IMoL
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

Hi Sam, what happened to this patch-set? At least KCFLAGS patches I am
waiting for are still not merged.

--=20
Best Regards,
Artem Bityutskiy

--=-sCUg/H3SQY31auS5IMoL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQK27DAAoJECmIfjd9wqK0Tz8QAMhAV+/ERjYYvQqn9wWsqzBX
DDZw3WIHAwgAesGeL5a62WtSXckSNpLqgUyK33seq/Bi1MzbDwhi+bkb76scE1Mu
vjOdy5PQszkgtasnvn9AzGW0iZm5MpPSoGS3H8tMvxlwdpJTHTps0iH8Nm+bvfaU
KaNSN+ZqJWrR4GGwSz5kz2P96Sm65EffRFtCF4NbrAzlEyH59rY04e+LX4qnYcEb
ONgZh3CmTQp0pnhguDF675qdwgX6RmZKhyKQg+kOB/+Ic24IE/tzWJ1OvydA2SHJ
lkQDOJJeryjrJqUpZADMiP89eI8qLajNGrVKWGwKdBNptqGvYmdkcjOeJNxard/1
uK8ZiBEDy43WzJbrM2Z5/HrNdSlogCbOzpRI5WSDliZmBUg+5yjirtrefkvkcCiq
st/HSlExxYCe9Dfqr94PKm+1JB4+/hVY4o4z17BKn1SSP3yjdwvZ66/4pWK/Ex/Q
v49LzuV1bWAE5Y2EiSWS+yxcoeFeFW03Df6w+YWlfpyotXZf8gtqadQUs4LMKelZ
t1cglzXJMqjhCEyc/gdnEWXNyv3U9rX0mkbmYprZ5ixtRxirrVoNJ8wj+SbbrpXm
M6tLF2aQvn82KOtjThTOrIGcI0r8q05m5V1ZwxV+YbvJakj3LuUQ/n3lIETvetHs
w1faaxe1xl6X5b0XuAWd
=jmIV
-----END PGP SIGNATURE-----

--=-sCUg/H3SQY31auS5IMoL--

