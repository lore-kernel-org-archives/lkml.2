Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132Ab2EHP6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:58:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50607 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756803Ab2EHP6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:58:52 -0400
Date: Tue, 8 May 2012 16:58:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Rhyland Klein <rklein@nvidia.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 6/6 v3] ARM: Tegra: Add support for TPS65910 PMIC
Message-ID: <20120508155847.GC15893@opensource.wolfsonmicro.com>
References: <1336502563-31789-1-git-send-email-rklein@nvidia.com>
 <1336502563-31789-7-git-send-email-rklein@nvidia.com>
 <4FA94212.4000207@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vM12nk/63StVgfqY"
Content-Disposition: inline
In-Reply-To: <4FA94212.4000207@wwwdotorg.org>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vM12nk/63StVgfqY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 08, 2012 at 09:56:02AM -0600, Stephen Warren wrote:
> On 05/08/2012 12:42 PM, Rhyland Klein wrote:
> > Add support for the tps65910 pmic on cardhu.

> Lets ignore this one patch for now; it's not clear whether Cardhu should
> instantiate the TPS65910 or TPS62360 PMU; apparently different Cardhu
> variants have one, the other, or even both. I'm trying to find out which
> variant(s) is/are useful to support.

IIRC it's the same as Whistler was and even more fun that that - you
might have random PMIC boards appearing from random places and can't
rely on what's on the system at all!  See the thread I started about
plugin modules the other day :)

--vM12nk/63StVgfqY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPqUKvAAoJEBus8iNuMP3ducMP/iYfwe3UZ0uFF+L/6hSwTsXA
/E5qs0QShaaSPpYJwORl4EzAk2jl9kbdz1jJ0W2qDt6h6Dd0qsb7UUQwyp+wU2Ca
BCNla0gMVLzQQTfvoXQVeTp7IWgyjqeWQAoKQE5u/27e7OwlVQZn4tb9u+RfjmuS
Kl5qci1XDDj/UmJURBXdQxljC+ZJypq5QMzyec/DkS5oTaadtlt+ApkrhJNHZ0v2
sA0HJqBehW9DSKScbMvvES3Gz8ThJyV8qn7LF2d+iaCeMpRDEJu67NQUZfStntAk
DvJ+0+WRBRoU/JWp4zGbVqtHeXvFfnvhmD74ObGXL086Ij29xzso+p57O0DjhXW+
ZJJg/gojzvfuqUEGdGBV1Qcgtq1yEKhH+OhMA88EjlJu4T784gNBSZb6tFrMIEBz
xbPoY6174rbLuOk0LitIZHTrWxAxqzy882bdWKiTjIZXJN15yqfXo/7y5SUY//97
ys5Ou+zBBJAtuctMSphP6fhFRrtvBDxt8FPgiAHeRpPr69y2QcFppd9KEZ895Bx5
UJJ6XdZjjfVSYmXzkG+zPOmZEYpwbcaQNSdWNL5xMzWDOro5LoyE7T7L7iQVfTaY
MR+FmLFBN+E5bDx6TynjglGHyBr8xL5J22blcU9sPQ5BXQur2VWC0IDfpYCDA8KH
CEpKfwMVsSbk4cHWSuXD
=vFKq
-----END PGP SIGNATURE-----

--vM12nk/63StVgfqY--
