Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab2HTSOj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 14:14:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40327 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751641Ab2HTSOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 14:14:35 -0400
Date: Mon, 20 Aug 2012 19:14:32 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>, "olof@lixom.net" <olof@lixom.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] ARM: dt: tegra: harmony: add regulators
Message-ID: <20120820181432.GJ26991@opensource.wolfsonmicro.com>
References: <1345186799-18229-1-git-send-email-ldewangan@nvidia.com>
 <502E9B09.3080800@wwwdotorg.org>
 <502EA1AC.4090205@wwwdotorg.org>
 <50327242.80103@nvidia.com>
 <50327897.5030601@wwwdotorg.org>
 <20120820175410.GI26991@opensource.wolfsonmicro.com>
 <50327D2D.6000509@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lZZ4ablUVnt2XgAh"
Content-Disposition: inline
In-Reply-To: <50327D2D.6000509@wwwdotorg.org>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lZZ4ablUVnt2XgAh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 20, 2012 at 12:08:45PM -0600, Stephen Warren wrote:

> The patch in this thread adds all the required regulators to the DT
> file. However, it should also remove the special case so the
> regulators don't get registered twice, once from the board file and
> once from DT. However, doing that would prevent regulators getting
> registered at all, since v3.6-rc* don't have all the required
> (TPS6586x) regulator (driver) patches to get the regulators
> instantiated from DT. Everything will only work in linux-next or
> sometime during the 3.7 merge window.  Hence, git bisect would be broken.

> One solution to this is to bring the regulator tree into the Tegra
> tree as a dependency, and then apply a patch which adds the regulators
> to DT, and removes the special case from the board file. I'm asking
> for your OK to do that.

Why not just pull the patch in via the regulator tree?  The idea of
merging the entire regulator drivers branch into the Tegra tree doesn't
seem awesome...

--lZZ4ablUVnt2XgAh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQMn5zAAoJEFJkBDiqVpZ4PJ8QAJCSD9QML6peiFybks33ZvuY
HIWqKd8uGcjmQ2bFCSp+NRyVCcO2Htsf8GHQzOFiy7DLYkjxbetGvIlYir0BJxAt
q2F6nPVBmpllmnFoKl2iTHhlqqO4YxZrsK9fsmveUOFyBLJGbPZBzvFwx8Q+nNLx
/xY/wkb9e8lVvsPY+PkPCgNL3nGRoblHt80860SBYmcprUg+fGzKcYqMVMK0FJ7M
915Yh3nT2yxynvMoLQJIBcdTXZRIgL7Pv3wR2ilmoQiLdywjsTUlJk03YhLExqBV
O6xPC0uvV9nKlN7fGy8LjeStdgMHNeJrMxgku4Tcs+RTVgEZgU4+BvF/pbvpEgbP
VhQa5qPPPYungxgi8Zfrme+SLRAfLd7n7mO1lRlYsLty4FVc6eTi3JevEklMpPE/
Iy3+VxVzPR6gJtUItoL1YG/NkGa5IzwPtux7KGmhgpjHSgFtD2Ly32pchzE5Nptu
x6sblgz7vYbfRwa4+Sx0d2macV4UbE4QfStZPLgY/d5T8GVSDjHWtXqzhPbNmfi+
/b3OqNA3Jpohto6F76v9FqG81zerui0t3VInU+QfunjcLzwUq69Do8iQJHwEx19E
547qg5WMPEOhyoJ9Y9yYoAVhNJYw/ICKUVKdIvu1Nf2B3tDNOmcmJ/nyyHsrRVvE
h0FNEHV2mk4ey3/Z0+wO
=cWEk
-----END PGP SIGNATURE-----

--lZZ4ablUVnt2XgAh--
