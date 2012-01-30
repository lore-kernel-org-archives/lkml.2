Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab2A3NbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 08:31:25 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48315 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751678Ab2A3NbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 08:31:24 -0500
Date: Mon, 30 Jan 2012 13:31:22 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, jedu@slimlogic.co.uk, sameo@linux.intel.com,
        gg@slimlogic.co.uk, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH V4] regulator: tps65910: Sleep control through external
 inputs
Message-ID: <20120130133122.GE4882@opensource.wolfsonmicro.com>
References: <1327743477-31512-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gMR3gsNFwZpnI/Ts"
Content-Disposition: inline
In-Reply-To: <1327743477-31512-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gMR3gsNFwZpnI/Ts
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 28, 2012 at 03:07:57PM +0530, Laxman Dewangan wrote:
> Add support for sleep controls of different regulator through
> external inputs EN1, EN2 or EN3.
> Each regulator's output will be active when its external
> input is high and turns to OFF/Low power mode when its
> external input is low.
> The configuration parameters for sleep control is provided through
> board specific platform data.

Applied, thanks.

--gMR3gsNFwZpnI/Ts
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPJpujAAoJEBus8iNuMP3dvgMP/ibQLpN7RwjUamWKuB7+ViC+
g7sWj8MRmJ5wnqDMtraHaqTkNfGt7+UeNW8rN9G7Y1AvXEc4MhMA65Bb6wqzQMQk
HqrI46y4N1U0TAsFmJAOlBOqqNX6uRwZRtDdA3E9pvKKe09aTo9lEtAQ0ahzpQNV
qQon32HswvDaMCU6lhioflT4/EX79wrNRCM9PJlFFgPcspmhBtqzHaitCq3h0liy
54Esx/up0qe0Gw5hPYGROhM4e4biP0nc3CDMh+XDcJ7M7WPucczIRz/pV5Ms67Ij
Dnp4OiATOBqdlb5BhLZMl305lmpy0FmbRF9PNnLe5uQ8Mb1kc8BNJmph3EYhkxrl
4Zw6OXSy0tqS2LBWpFEFWOmr0xK1ImJ6kGqiOPrdQLVcoj44lACIqp/s+TzLGgUh
9IkzMvweETYpHLuO5umemJU4CccU8C8EODOOs6mNI1dfQRKuZx3FOLkPjGhhQjxV
mp2oMnuPZdod3tlVyNT/HaXYyW9CTviz3YpTQ2S0MsE/rfBo+5R1X0qPQbKdK8sq
ZnYztoL7KSPDUXkyL096yqTlNIi0XravoPjuDkwAOGc3y85V0dhdy9fYcOD2ZNhd
UrBB4fD+LLgYQN722Kl3ZEnCAewTDzeY4q/wyzRwjMIyo4TR22h885XUlmYAPohz
szgnyEScuIjtzXHfDEf6
=oBo7
-----END PGP SIGNATURE-----

--gMR3gsNFwZpnI/Ts--
