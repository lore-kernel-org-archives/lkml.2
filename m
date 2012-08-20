Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab2HTLer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 07:34:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:65255 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab2HTLek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 07:34:40 -0400
Date: Mon, 20 Aug 2012 13:34:23 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Bill Huang <bilhuang@nvidia.com>
Cc: sameo@linux.intel.com, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rob@landley.net, broonie@opensource.wolfsonmicro.com,
        ldewangan@nvidia.com, swarren@wwwdotorg.org, xxie@nvidia.com,
        lrg@slimlogic.co.uk, jhovold@gmail.com, kyle.manna@fuel7.com,
        rklein@nvidia.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mfd: dt: tps6586x: Add power off control
Message-ID: <20120820113423.GA5996@avionic-0098.mockup.avionic-design.de>
References: <1345424876-4365-1-git-send-email-bilhuang@nvidia.com>
 <1345424876-4365-2-git-send-email-bilhuang@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
In-Reply-To: <1345424876-4365-2-git-send-email-bilhuang@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:ZKIEuGuUypwnL2xPS1ca3JvOa2Xe12OE8ZYIktOZN8f
 OD0v+bsnx3tIDMrh6frvvqH0kTymQ39OPtLJRF2OIY99yqRXer
 LUqolnGz2fOWwvize/8dUBUvqUsfvBiShKgCbCcxWozSACVrq1
 dT716BNeE8dage20K+7dFmTqThTVDxUAUCPJ94WPZYNCo5Itbu
 3vp81urIy8OQQLLjSslu6Na39nH6EDTsvZelbdGqvsPdGbX+D1
 cIMtvhugd/VFERds+wEUJz0STeGj/hIcozyZj3i8a8nfPa5AwF
 31JZ9fUAQH7lZm7wo5K0t0t91wL+QX8fh8/A6E5kD6Z0/qNzlJ
 aFXVbu/ziELrSH8bzy3zobqDOOoEWVQ46+n3uYhn4KkG4eWbIZ
 A+k82d0purRYM2evDfvCIjMClDvlQ85ggI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 19, 2012 at 06:07:55PM -0700, Bill Huang wrote:
> Add DT property "ti,system-power-controller" telling whether or not this
> pmic is in charge of controlling the system power, so the power off
> routine can be hooked up to system call "pm_power_off".
>=20
> Based on the work by:
> Dan Willemsen <dwillemsen@nvidia.com>
>=20
> Signed-off-by: Bill Huang <bilhuang@nvidia.com>
> Tested-by: Stephen Warren <swarren@wwwdotorg.org>
> ---
>  .../devicetree/bindings/regulator/tps6586x.txt     |    6 ++++++
>  drivers/mfd/tps6586x.c                             |   19 ++++++++++++++=
+++++
>  include/linux/mfd/tps6586x.h                       |    1 +
>  3 files changed, 26 insertions(+), 0 deletions(-)

Hi,

I've seen the following while trying this patch applied on top of next-2012=
0817:

[   40.581151] Power down.
[   41.583160] ------------[ cut here ]------------
[   41.587784] WARNING: at /home/thierry.reding/src/kernel/linux-ipmp.git/d=
rivers/i2c/busses/i2c-tegra.c:525 tegra_i2c_xfer+0x21c/0x29c()
[   41.599850] Modules linked in:
[   41.602927] [<c0014074>] (unwind_backtrace+0x0/0xf8) from [<c00265a8>] (=
warn_slowpath_common+0x4c/0x64)
[   41.612304] [<c00265a8>] (warn_slowpath_common+0x4c/0x64) from [<c00265d=
c>] (warn_slowpath_null+0x1c/0x24)
[   41.621947] [<c00265dc>] (warn_slowpath_null+0x1c/0x24) from [<c02a2944>=
] (tegra_i2c_xfer+0x21c/0x29c)
[   41.631244] [<c02a2944>] (tegra_i2c_xfer+0x21c/0x29c) from [<c029f5e8>] =
(__i2c_transfer+0x44/0x80)
[   41.640192] [<c029f5e8>] (__i2c_transfer+0x44/0x80) from [<c02a0698>] (i=
2c_transfer+0x7c/0xb8)
[   41.648796] [<c02a0698>] (i2c_transfer+0x7c/0xb8) from [<c0232a60>] (reg=
map_i2c_read+0x48/0x64)
[   41.657485] [<c0232a60>] (regmap_i2c_read+0x48/0x64) from [<c0230304>] (=
_regmap_raw_read+0x90/0x98)
[   41.666518] [<c0230304>] (_regmap_raw_read+0x90/0x98) from [<c023035c>] =
(_regmap_read+0x50/0xa8)
[   41.675290] [<c023035c>] (_regmap_read+0x50/0xa8) from [<c02300c4>] (_re=
gmap_update_bits+0x24/0x64)
[   41.684322] [<c02300c4>] (_regmap_update_bits+0x24/0x64) from [<c0230b88=
>] (regmap_update_bits+0x3c/0x58)
[   41.693885] [<c0230b88>] (regmap_update_bits+0x3c/0x58) from [<c0237c30>=
] (tps6586x_power_off+0x18/0x38)
[   41.703362] [<c0237c30>] (tps6586x_power_off+0x18/0x38) from [<c000edf4>=
] (machine_power_off+0x1c/0x24)
[   41.712749] [<c000edf4>] (machine_power_off+0x1c/0x24) from [<c0037ca4>]=
 (sys_reboot+0x138/0x1b0)
[   41.721612] [<c0037ca4>] (sys_reboot+0x138/0x1b0) from [<c000e000>] (ret=
_fast_syscall+0x0/0x30)
[   41.730293] ---[ end trace 9af366974fefa459 ]---
[   41.734906] tegra-i2c tegra-i2c.3: i2c transfer timed out
[   41.740689] Kernel panic - not syncing: Attempted to kill init! exitcode=
=3D0x00000000
[   41.740689]=20
[   41.749823] [<c0014074>] (unwind_backtrace+0x0/0xf8) from [<c03e7090>] (=
panic+0x8c/0x1d8)
[   41.757993] [<c03e7090>] (panic+0x8c/0x1d8) from [<c002b7b8>] (do_exit+0=
x694/0x750)
[   41.765636] [<c002b7b8>] (do_exit+0x694/0x750) from [<c002bad0>] (do_gro=
up_exit+0x3c/0xb0)
[   41.773884] [<c002bad0>] (do_group_exit+0x3c/0xb0) from [<c002bb54>] (__=
wake_up_parent+0x0/0x18)

Thierry

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQMiC/AAoJEN0jrNd/PrOhiYEQALfHXXAnQSwm5zlTloPZGPQo
MnRBhNJskwHBl1Wpkn+iZvFsjvMCW6yWFsRSED9M3sH7jH8lHknKW91Uf01ZO8AR
u25B+DAygmye0KVWOvV7Dp574OwMSs7op1oN/GkixVspfEoZNMaU9zOQNmsXLN4T
7KkvwMJIaFJj3RzS27YxA0h6lAcUsOLkzmY5WGZdnjbUCfr4mQ/9gYaX6NrECEFZ
bSAcukhxAMuKSGdwlzOlfaXger78joount8rdIy2zL8xFtUA4FS4zrxc0ofExBH5
2nCp0+JsZjG9ty5vcuMFeiJ2tOjX37EJiZ3lEG5tjwSLSFanbMcMJBvd6lgIdydO
s/p8QbeZtoMZu1jm9P/zT0Hq/RrrITEohjFl35WzFs0zDJnPJ9EmhHCBBt5H29zg
kGX2m8mBATJTBjMKkSFwavJJptzfVOrslFaRLJKYOyQ6PkB62chI6PlFgMYMGbOx
U7ckvOQuuir4IISoyOvrx5JZ4lsDumTpqPgY9VEy5MR0QvcqvJMX47ztC6TZWBzb
WumVBOTux/gPKpeF4jM6dul1Hrb6BVgBQyP+G3AVYwdfTDCSnr2/hB3uwUR9GqDp
H11Y8RjTeepZI4DnacRHX0HcGCI+z1xXX35BgLZoKSs1evXfHXazzXhM2frwv6OV
FYAqfloD+nq+kDDL6Znl
=XZuQ
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
