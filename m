Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab2FFKPD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 06:15:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:23871 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173Ab2FFKPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 06:15:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="asc'?scan'208";a="153623565"
Message-ID: <1338977927.6875.29.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 7/8] kbuild: move W=... stuff to Kbuild.arch
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Date: Wed, 06 Jun 2012 13:18:47 +0300
In-Reply-To: <1336205926-13946-7-git-send-email-sam@ravnborg.org>
References: <20120505080640.GA13773@merkur.ravnborg.org>
	 <1336205926-13946-7-git-send-email-sam@ravnborg.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-DvzCN11APWpVJiWZoEP9"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-DvzCN11APWpVJiWZoEP9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-05-05 at 10:18 +0200, Sam Ravnborg wrote:
> Prevent that we eveluate cc-option multiple times for the same
> option by moving the definitions to Kbuild.arch.
> The file is included once only, thus gcc is not invoked once per director=
y.
>=20
> Another side-effect of this patch is that KCFLAGS are appended last
> to the list of options. This allows us to better control the options.
> Artem Bityutskiy <dedekind1@gmail.com> noticed this.
>=20
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Artem Bityutskiy <dedekind1@gmail.com>

Hi,

what happened to this patch? I was fixing the real issue I am
encountering and I thought it'd be taken instead of my original patch.

--=20
Best Regards,
Artem Bityutskiy

--=-DvzCN11APWpVJiWZoEP9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPzy6IAAoJECmIfjd9wqK0PM4QAK2LJrVY2P8B62C+e4mgSCC6
1ztY31Afx91SuVvrSvq0zOKAzO8Ao4rfcUceOFDksBeSeczRvTeHtqV36S8B2yyQ
EwOneveIsJ8jP6o6wwwLT15EoGk3rbNERfhYSgkEn7pGqmZsU2vAihpPgw+E83/j
MQ6nY5DZByapzWA+JN8JJXzXeX9PB+XMcTfikA0AQevk+kYgLedTIvsc/YpZMWLZ
klgba7MCLMYBjEDISAvoxcoWSEG9qglUeU2AuFborBG+7TUGgNlxCWBjF1duFpne
Vr2JSVich2922IXN6fJUDLBCo8ByAHyqdBA0ys9NvmyOa46h2KnztmFyBCiBaswE
xXoecl0QhQ3xaVxMv9mUQmafj86eBY7QR9Cd75ZcvZWipzlWQDXQdwvpoHwaz/Jd
pcvb57d0FKkR2zlxYxC33oXf9ExD1DVTmpYa+9LRu0UOBnI3tbrESYwB3JmtBU9x
xm4QeIUgNWZXwdZfjxEEamTRhDJrkLwx6DPMrjyhyUkII5RGcXTIGwCxsX+N+S7P
/7WHJPc3PBZ20xpc58UDBYrGut4OWsAn7Le7DEUyVMI70mHpLXIrkH9HnWGbfGWT
YDNE0qBPZhsyFJ3WxrldG4HE/6RAfPLCLMzH9cHgMF6wd4CUcJY7s8wov0Qw9UST
8YnzPZcijeJxDyrWXnST
=/Kqe
-----END PGP SIGNATURE-----

--=-DvzCN11APWpVJiWZoEP9--

