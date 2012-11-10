Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab2KJRIA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 12:08:00 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:56424 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab2KJRH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 12:07:59 -0500
Date: Sat, 10 Nov 2012 18:07:42 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH] spi: tegra: sequence compatible strings as per preference
Message-ID: <20121110170741.GA17689@avionic-0098.mockup.avionic-design.de>
References: <1352452052-13823-1-git-send-email-ldewangan@nvidia.com>
 <509D37B8.8020606@wwwdotorg.org>
 <20121109171008.GX23807@opensource.wolfsonmicro.com>
 <509D3D46.7060102@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
In-Reply-To: <509D3D46.7060102@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:hhRc0TQ7MTnLApcc678KU10V0zj98T92OOLpWgoeuIp
 RkQLMWbyFGEvCGIUDIrXgcJm2ZuiaS5Vq9sP5sYMnh+FtcclfG
 ANnr1zl3Dp/4ZEGGn5BngViwsHc4AeeclmmN73oELRTEcBqReD
 OacGZ8ITnjl8ppDFWltJaJg7XKyK2bo4t39soXt+FcL+WVu4dk
 QMz4KML5l7k/BLWfRewdyGA7Zms9sNXQaT1UahveIblut4N38B
 iJAOBb+lnCc7sIXbnjGebPVjCaFTRHLxPiT1cWlcWzinaqx3o8
 sD/KB1OkHYi3TZYWI+kxr+7TUdSq22n1H62kO+w6e94zF36Rhu
 8t0Dp/WidQ6j6WnIq5yGX0N3b95LRf1gg2y8qLWKSPKdmpMxmJ
 ZkNb98AV9KucaG3RVTSXplutJfTa6YUl9R29+w9Azbo0WSz8q3
 0yLrE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 09, 2012 at 10:28:38AM -0700, Stephen Warren wrote:
> On 11/09/2012 10:10 AM, Mark Brown wrote:
> > On Fri, Nov 09, 2012 at 10:04:56AM -0700, Stephen Warren wrote:
> >=20
> >> However just FYI, it should not be necessary for correctness; The
> >> DT matching order is supposed to be driven purely by the order of
> >> the compatible values in the DT now, and not affected by the
> >> order of values in the table. (This wasn't always the case, but
> >> was a bug that was fixed IIRC by Thierry Reding).
> >=20
> > I guess the driver is being used backported in older kernels which
> > don't have that fix?
>=20
> That sounds likely. Laxman, it'd be a good idea to track down the fix
> to the DT matching code and backport it, so that hard-to debug issues
> aren't caused by the lack of that patch!

Unfortunately the patch that was supposed to fixed this caused a
regression and was therefore reverted. Rob (Cc'ed) said there was a
patch to fix it properly and was supposed to go into 3.6 but it seems
that never happened. Rob, what's the status on this?

The revert is here: bc51b0c22cebf5c311a6f1895fcca9f78efd0478

Thierry

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQnondAAoJEN0jrNd/PrOhYJUP/20RMyzx47zR8nbEljYVYX46
w/oQO0iK4IUhaxUJ+ApC+2biU2gNXxsPmR+Qo/C9aJ7U5xLnYNsywaM8reHQ/lJf
+/aTRhd/XASmJUFeGquLEs6TbDgVkHaDP+6sGdBFLh8rQ1mT86pNOmQqvjcPXRrH
RNmtmpQ9oAgqtYALK77swK2wtiLuoIB+Lgxcamw7PrIfx/yT0THL1zimbKlOZtw1
fdIrLrJDBPsME+pkTMJXp7rQEdkwhmcP0SVG56K8Q9j9x2KMfhTKUZYsSokteI4k
+uGXO2+mHyF3XAtPM2NJcrqOKcj/xaQKdlqeHv8ZOhnIpZxefEvEgma3R2cR6Vkd
2SXYJoB7sDeCP0s64CFRkHwVULsyJLersiUnwp7FqQllrufTySKacajglOU7Kx4u
3v7zAkrfM6eJm09PuLXoawD6rT9Relg4Tf4rg+snZ9GxSYquKY3DVXWsxUTkFkrS
mtLMitFFrmtjGZqsYSr9xtSuwBcjh6QaHNssPf9+1OXSIVDRhzCkL+GWfqgLBNA8
f9k5KuNuH9XTQJHihNSJeUREf0N0PgomQ2BtYVS6S7N2Q8d7NKFYXFUlrYj5Izd3
u8gTi8z0Lullv9qPLEqa1GN+U/y8Rqbc4vBrWOoMGyrjj1XQh6CcvGhRvV7XUkko
wThIvYpKIuZscj5A/ZxC
=/WkF
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
