Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab1HPGer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 02:34:47 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:42290 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751166Ab1HPGeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 02:34:44 -0400
Date: Tue, 16 Aug 2011 09:34:40 +0300
From: Felipe Balbi <balbi@ti.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Ben Dooks <ben-linux@fluff.org>, Stephen Warren <swarren@nvidia.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Rhyland Klein <rklein@nvidia.com>, Felipe Balbi <balbi@ti.com>,
        Jean Delvare <khali@linux-fr.org>, Rakesh Iyer <riyer@nvidia.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] i2c: tegra: Check for overflow errors with BUG_ON.
Message-ID: <20110816063439.GB2223@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1313434172-18319-1-git-send-email-dianders@chromium.org>
 <1313458336-31456-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K8nIJk4ghYZn606h"
Content-Disposition: inline
In-Reply-To: <1313458336-31456-1-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--K8nIJk4ghYZn606h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 15, 2011 at 06:32:16PM -0700, Doug Anderson wrote:
> This change doesn't fix any known problems but turns
> on the overflow detection feature of the i2c controller
> in the hopes of flushing out any current (or future)
> bugs in the i2c driver.
>=20
> Inspired by a change on nvidia's git server:
>   http://nv-tegra.nvidia.com/gitweb/?p=3Dlinux-2.6.git;a=3Dcommit;h=3D266=
d1b7397284505e55d06254b497cb32be07b69
>=20
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Reviewed-by: Felipe Balbi <balbi@ti.com>

> ---
> This takes Felipe Balbi's suggestion of making the overflow
> error non-fatal.

the WARN() was very nice idea, I was thinking of just returning an error
to the client, but the adition of WARN() will make it really bold ;-)

--=20
balbi

--K8nIJk4ghYZn606h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOSg9/AAoJEAv8Txj19kN12jkIAIdVeYQmxKoZcQTedYVoImCV
YdDBXPLi6q7Sw4/+0czLcOcWCo4GNXdO41uEayjfsgd0rZEzHKODLOos2tXjJDvp
tLHG958miHMPQYL6YKTdrwmw1yafP/QncYC/BMTVw286TJO3dyJfdsThTSfVvjan
VbiTkPkxUgj7RGXiFBbQzdjWFOPHovswzAMtOWCb6J0sMsq6bPbhuTTNdcd4fE4f
0g8CDbnHTHd1vAHivrZQvLCCoJcVOmppPY5ob9CF1UMpG7mtmc+1glW7hyQDXex7
p8IM+4huaRkh38wtDJBmkBDyzlg+S4rowgLwnMs5TqSAkflrMJ7j3kiTMNnRYuI=
=3mdt
-----END PGP SIGNATURE-----

--K8nIJk4ghYZn606h--
