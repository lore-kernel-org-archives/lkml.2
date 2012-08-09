Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab2HIHIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 03:08:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64823 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422Ab2HIHIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 03:08:23 -0400
Date: Thu, 9 Aug 2012 09:08:13 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>,
        David Henningsson <david.henningsson@canonical.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ALSA: hda - Defer probe when loading patch firmware
Message-ID: <20120809070813.GA6979@avionic-0098.mockup.avionic-design.de>
References: <1344494723-6827-1-git-send-email-thierry.reding@avionic-design.de>
 <s5hhascft86.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
In-Reply-To: <s5hhascft86.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:ZGyaTlQNwmhKGYshsx8JbuwmIn7gcZSP6xY1acVpQwr
 CYG70zcs0Fc4oDlg7O2mIjs9ehPsiwM/ZCzXO4Ao24CoEK2yon
 f2uncyM41OY1V/4pY8Vfc+d/xfI/RLm+VKKlz9mI3ll6Vj0WJ8
 Hc7VimLETwy789o6gL4gfHPNYgoAz6nvPJS6j33yMZmI0zIGyo
 nILocjK+CLxdgr3doj0XFfwrh3HWjLXrVei97X10BAn6kvK07i
 RrA5QxYNDRMcl+60RIqIoqf2Yq8XZ2w6N7iSbpdGDP82ZEjs/K
 ORWLYu2ich53m1uump7JEhvXeSWDnNN985UW2+mMpLhZfMv+e1
 o3usEE/EHgSCibmjA1VqcUuZYWk40knL8+gJbDdthX/bnkb8uz
 Pcv8xhMRbbk+/EVSHpBE/XxoioBh6FosIH8iSywGnsHCpR9jBs
 EpwSq
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 09, 2012 at 08:57:13AM +0200, Takashi Iwai wrote:
> At Thu,  9 Aug 2012 08:45:23 +0200,
> Thierry Reding wrote:
> >=20
> > Recent changes to the firmware loading helpers cause drivers to stall
> > when firmware is loaded during the module_init() call. The snd-hda-intel
> > module requests firmware if the patch=3D parameter is used to load a pa=
tch
> > file. This patch works around the problem by deferring the probe in such
> > cases, which will cause the module to load successfully and the driver
> > binding to the device outside the module_init() call.
>=20
> Is the "recent" change meant 3.6 kernel, or in linux-next?
>=20
> In anyway, I don't understand why such a change was allowed.  Most
> drivers do call request_firmware() at the device probing time.
> If this really has to be resolved in the driver side, it must be a bug
> in the firmware loader core code.

A good explanation of the problem and subsequent discussion can be found
here:

	http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/49=
975

Thierry

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQI2HdAAoJEN0jrNd/PrOhDKwP/1SfrABxS8nsazGGbX4y0+we
sKoFY1CUzO/0ltXsLWmHKcHvx3ibv/+/MO846z40Eijm/mTCktR/cVVejafufVyp
j2YyjBDLAozBlz0EuiBkD9kVlBFByLtfba1NOrYyQw8u2Nh0nCfbKgbOqHRPSxEI
slqEQPP38cGzdrdEQIYhA8oml2ffFmQHk0q3DIu70S0Zsrs5GZTeQ7m56QUj5suM
hnoTqnPupVadp+rRDpq1wPziogvBtF7tqATNsTZuZpKVJSFH/rB41qWhstx/tVUG
UQdVbHtSEulGGaSafqhgyzvydq+N2EF//ctEifmi9gBE8g09SFCFJlaDxMJsdB5t
m0WXFFL2s59F9iSgpJbYMVY3QD8GeD5FYFX3ZNQbfMvhMGrhEbJA85Dg+4hrQiIW
d4k68DV3HsbrAtrq9L0ijqhL4R8dL/Y3v1FEtxY6Fgm7SiHFZ56mXgJ/F82FR1G6
/Ek8gpqhFNkU+NG2CrlNh8sFTArYh2yUreUjurk0DDRf516qrnACGyJpW4Xme/hr
R5p3H2jqYog71MB+Z3nDtasdgikLNcpcDjHm/bO0pwswAwVUMr6tzo2nmpT81DdM
Uw5Lj8uhbr+POtjh8LdjHNbWflN5HTKpZgJkN+GmpeFHUeyBZrGaqOTLmobXQLQO
ssf8iXC03aPoBg1I+Ej3
=up23
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
