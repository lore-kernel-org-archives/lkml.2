Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab0CSUwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 16:52:42 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:35833 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab0CSUwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 16:52:40 -0400
From: Eric Anholt <eric@anholt.net>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Surbhi Palande <surbhi.palande@canonical.com>
Cc: dri-devel@lists.sourceforge.net, Chris Wilson <chris@chris-wilson.co.uk>,
       linux-kernel@vger.kernel.org, airlied@linux.ie, yakui.zhao@intel.com,
       zhenyuw@linux.intel.com, Len Brown <lenb@kernel.org>
Subject: Re: ACPI _LID failures
In-Reply-To: <20100319125320.22d8b25d@jbarnes-piketon>
References: <89k83ahv05c@azsmga001.ch.intel.com>
	<cover.1268680514.git.surbhi.palande@canonical.com>
	<20100319125320.22d8b25d@jbarnes-piketon>
Date: Fri, 19 Mar 2010 13:53:10 -0700
Message-ID: <87iq8sqbih.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 19 Mar 2010 12:53:20 -0700, Jesse Barnes <jbarnes@virtuousgeek.org>=
 wrote:
> On Mon, 15 Mar 2010 21:32:41 +0200
> Surbhi Palande <surbhi.palande@canonical.com> wrote:
>=20
> > The following two patches are quirks that blacklist bios which report
> > incorrect lid status. These are bioses for machines with a 900 GM.
> > The first one is tested by Ubuntu users and the second one isn't.
> > Further testing will be appreciated.
> >=20
> >=20
> > Surbhi Palande (2):
> >   drm/i915: blacklist lid status: Sony VGN-BX196VP
> >   drm/i915: blacklist lid status: Elite Co. G335
> >=20
> >  drivers/gpu/drm/i915/intel_lvds.c |   14 ++++++++++++++
> >  1 files changed, 14 insertions(+), 0 deletions(-)
>=20
> Patches look ok to me.  Len was curious about whether some recent ACPI
> EC fixes will fix some of our lid detection bugs though.
>=20
> Len, is there any particular patch or version people should try?

Unless ACPI is going to magically become more reliable at the lid
method, I think we should abandon using it on generations where it
fails.  See other patch I submitted -- anyone care to ack it?

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuj5DYACgkQHUdvYGzw6vfxnACfQRc/Pq1XfgYnU6DwqIoVp/P+
/cYAn2R49QbjYlFbzkzqVZLatIvITVEd
=R1x0
-----END PGP SIGNATURE-----
--=-=-=--
