Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab2KMGsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 01:48:08 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:56902 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab2KMGsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 01:48:05 -0500
Date: Tue, 13 Nov 2012 07:47:48 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Dave Airlie <airlied@redhat.com>, linux-tegra@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>, devicetree-discuss@lists.ozlabs.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] NVIDIA Tegra DRM driver
Message-ID: <20121113064748.GB31443@avionic-0098.mockup.avionic-design.de>
References: <1352757358-14001-1-git-send-email-thierry.reding@avionic-design.de>
 <50A1918E.1000809@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WYTEVAkct0FjGQmd"
Content-Disposition: inline
In-Reply-To: <50A1918E.1000809@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:xigN1mOqMhriLVGRfsXG6+0dNQjdD1ACv9mFoGbzcNk
 j+ds8oBi+QV/BCV0dUFcIdwAyoL9fUqNH6Zq1+C5osI4jiFppS
 F3krXF21iCzgy68VV9fjDvy3ysCiavSCIN8Z/rFuSHnHYqkg4W
 APpHvrE0akI0/20VeVXmFjIrd0ODCfWURyOua3IOgHJ7aeM2/f
 DdpvJhUmtsjGXiFGemqixMDoQ12AbIOKQoipL+eESsD5XYqIdP
 RlaUES+qc9wxfGcfRni5j9WipA182obA5b+9rXreEU8VCUAwDV
 XtUUKWGWVGaykL0jURiOw7CRYUJjJae5st7WmZLjK4DY2N97g0
 +tow4gXiya2RPgWdKFBScjDsJg2Xrs/LQ8e9SyGRzW5/yaJLgm
 oRK8Qw7uJdAQhaH4vArwds62SQ/CaBZLq24RfZgMsanDnRFA+O
 1P2w6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WYTEVAkct0FjGQmd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 12, 2012 at 05:17:18PM -0700, Stephen Warren wrote:
> On 11/12/2012 02:55 PM, Thierry Reding wrote:
> > This second version of this patch series addresses all the comments
> > received so far. Most notably it takes advantage of the debugfs helpers
> > provided by the DRM core. Oddly enough this actually increases the line
> > count, but that's because the helpers don't fit with the subdevices
> > approach as implemented by this driver. However some quick discussions
> > with Rob Clark showed that Tegra DRM is not special in this respect but
> > other drivers may need the same functionality. Eventually the debugfs
> > code could be reworked on top of helpers that are better suited at the
> > design of embedded, multi-device DRM drivers.
> >=20
> > Other than that there is some removal of code that was actually supposed
> > to go into a later patch because it has dependencies that haven't been
> > merged yet and some moving around of #defines and the device tree
> > bindings documentation. Finally the driver now uses the DRM core's
> > drm_compat_ioctl() instead of a custom and unimplemented (!) version.
>=20
> The series,
>=20
> Tested-by: Stephen Warren <swarren@nvidia.com>
>=20
> (on the Harmony board's HDMI output; I'll test other boards/outputs later=
).

You also gave an Acked-by for the DT binding documentation in the first
version of this patchset, does it apply to the rest of the patch as
well? That is, can I add it to patch 1?

Thierry

--WYTEVAkct0FjGQmd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQoe0UAAoJEN0jrNd/PrOhkO4P/j1fH+7cGSILND7bxqP+bpAe
G8P1m9GsvVYHMiDGE2vzvBzRrQpy4AlPEBU9NxEpEenJSM5wxMIXJdyo6DM3wAJE
pTqsX7QMlgDu5etvGkLGDtPo6JELd+9MeH1gKVFHD5ju/Pmsx7nhNxIku1XA3NTU
UKPtNRCwfaHl50ATaxiv9WJhPv7wTeHj39EE5/OqhDCEtG4t2hCUKsyYPdpoRGsJ
9JLKG+KHbgIqqpRrq7bYEa3OBHOxy/cZ4MFCmL9bVd30a6rIcAStnGRJGNB5J7BH
kakTBv1cauNJCJfMw4BK/8MhlyPyaEZdpeb6Kb1S92NRCbXGODlpfJOUpDudD0b7
k9KVsIK6fPvm72xrofa+trR1yJ7vJzorJvAdUWZ3lvDjCevQIALG87FWb5uPxif4
3l3LXO9+6N/nNAki8QZNJ+eDDKTVKDJ3sYlZHiJnrL/9Se3U5km56b7CNwZcy207
kXuvtAxYI3vJPO4cP3sgDltBrm8/6157azjp4VuJNoWKL5NXXpB6Kjoxnb1GaUka
AvTJr+WrGsMqoyxey3SrOx8XpsCCRYR6GjNeWDUv9oMgCyrQs3YQrH7fQ2nbMnWL
Rlotxsi7p/yVr5qXFTezHEWxfkQ1hfpswvxfv2bRn4Od3jRE40z0Twcgc6juxOlr
OljfR8dx17fuGwUiPRV1
=FOwG
-----END PGP SIGNATURE-----

--WYTEVAkct0FjGQmd--
