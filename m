Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab3AGWgD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 17:36:03 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:50760 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab3AGWgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 17:36:00 -0500
Date: Tue, 8 Jan 2013 09:35:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: linux-next: comment in commit in the slave-dma tree (dmaengine:
 dw_dmac: Enhance device tree support)
Message-Id: <20130108093557.8a29d4a04b95702fc59790ff@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__8_Jan_2013_09_35_57_+1100_3xlkmChovD0GUxxQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__8_Jan_2013_09_35_57_+1100_3xlkmChovD0GUxxQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Vinod,

In commit 548860697046 ("dmaengine: dw_dmac: Enhance device tree
support") (which was changed since yesterday :-(), an instance of
__devinit has been added.  We are in the process of making CONFIG_HOTPLUG
always true, and since commit 78d86c213f28 ("init.h: Remove __dev*
sections from the kernel") (included in v3.7), __devinit does nothing.
Please do not add any more.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__8_Jan_2013_09_35_57_+1100_3xlkmChovD0GUxxQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ603NAAoJEECxmPOUX5FElGcQAJsbzOIduiL/A1JX7AmfyEGH
V5//cWJwMtbRL19YbpemFBAa7KMGOGrYngNxUqwu1RnOHsTVmP7G1MQT+pKYt/+o
LTfb8AEVGymAZ7j/Q6EQO63h0H9Siz0NDfxA7WYBGzA4bsCAMtvqu0Dv42ZkMqmE
j0C2OwWVGoxkee9PnfS1LYAR8FqSzoOygqM9W9G3qamVyqxVV5ys1/xdrC+uwGL5
1HEHp/wpraMx4YSYxl15AECko1fNCGYHfDb5Dqb/5MQ1Q9f4hY72r37LtfjRt3JQ
hOV7EPRbWmnhVAxdoeUZWdChTBSjgvDUep7l5CwfNOf9EMUZWcEx0KmjQ+5WDKO/
Ovn0SF9RaxM0vA268vXc274QXcP1G6hwKaR3lkBQZMMJumJzM8ezE1cQi66HmmM6
PyWXxUJxbJxCXC9vdFigD550lEE7HYAHC50EDus0NaHzozdOS9WmnZdZ0Nxhn5lQ
saTln8Yq7X80Cmd+y9eq2YKHRUjXX8zPlE6SDXgM5T7/QpPvgGIVdpBdzSKoGQPD
J2MFADAdS9f2JtHR159fgefLxHSOYJivOC2MbWQWjGvbbHAmSOrFY4QY8DgPWzGU
gWRUkRMVxpa3TsRAzBfxFtH2d4nl75PEDfnKlFPB3/p0t1350J7uh57CYA5vP9un
M4xEK18aW3L+52A/S8g7
=xp1d
-----END PGP SIGNATURE-----

--Signature=_Tue__8_Jan_2013_09_35_57_+1100_3xlkmChovD0GUxxQ--
