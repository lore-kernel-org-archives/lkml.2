Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab1G2VTB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 17:19:01 -0400
Received: from home.keithp.com ([63.227.221.253]:43425 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812Ab1G2VTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 17:19:00 -0400
From: Keith Packard <keithp@keithp.com>
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Ben Brewer <ben.brewer@codethink.co.uk>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: i915 SSC Patch
In-Reply-To: <e0d58a$uf843@orsmga002.jf.intel.com>
References: <4E32ADC7.3080002@codethink.co.uk> <yunwrf1gc3b.fsf@aiko.keithp.com> <e0d58a$uf843@orsmga002.jf.intel.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 29 Jul 2011 14:18:56 -0700
Message-ID: <yunr558hjjz.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 29 Jul 2011 20:02:27 +0100, Chris Wilson <chris@chris-wilson.co.uk>=
 wrote:

> It's not meant to be and it causes havoc, from wavy/blurry output to no
> sync. The other part of the patch on that bug was to walk the crtcs and
> turn off SSC on the shared refclk if any output could not handle SSC. At
> that point, an objection was raised that we shouldn't even be touching
> the refclk if any output was currently being driven from it.

So the correct fix is to turn off everything, disable SSC and turn
everything back on? That seems tedious, but not impossible (just DPMS
off the world, then DPMS everything back on...).

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOMyPAQp8BWwlsTdMRAv6XAKC6zqs41ZyAofN+fYt7vXrKY/uPzQCgudJq
/r4a+4KGtWSo+vXYZ58YXzE=
=arqL
-----END PGP SIGNATURE-----
--=-=-=--
