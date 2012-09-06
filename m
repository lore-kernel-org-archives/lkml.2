Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760005Ab2IFADe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 20:03:34 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40091 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab2IFADd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 20:03:33 -0400
Date: Thu, 6 Sep 2012 10:03:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: arm64 branch for linux-next
Message-Id: <20120906100323.459916bacb75ca7b418ad384@canb.auug.org.au>
In-Reply-To: <20120905171743.GD19435@arm.com>
References: <20120905171743.GD19435@arm.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Sep_2012_10_03_23_+1000_qEs+xSQTLlxpDRnJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Sep_2012_10_03_23_+1000_qEs+xSQTLlxpDRnJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Catalin,

On Wed, 5 Sep 2012 18:17:43 +0100 Catalin Marinas <catalin.marinas@arm.com>=
 wrote:
>
> Could you please pull the arm64 kernel into linux-next? The details are
> below (I removed the diffstat).
>=20
> Thanks,
>=20
> Catalin
>=20
>=20
> The following changes since commit 4cbe5a555fa58a79b6ecbb6c531b8bab065077=
8d:
>=20
>   Linux 3.6-rc4 (2012-09-01 10:39:58 -0700)
>=20
> are available in the git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64.gi=
t upstream

Added from today with you as contact.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Thu__6_Sep_2012_10_03_23_+1000_qEs+xSQTLlxpDRnJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQR+hLAAoJEECxmPOUX5FEvJQP/25q1PDXXEMYJqfJMp8fWLpr
zDPjAJgH0xUV7HFeuRwvEwx7PnUguRQiaDvGcU4eR3xsHlg+HQIHBvUYxfXYapVB
KDFUiPG0j4Bo0edAaJN8QjOPW9dGko05vjxAKr2sXoglIf+iz0hObV1wC7RnIjQ4
XRev2Ed3ww3x/x1XrEKjomo/+swKXaR//1K8JL8k7hOBQygrsf5MKE0yqF0E497v
Wp2m3weftLJ+n/gYHgkDigrqR9/s8daOs+GBxteaG5UU8506p46tGeXGivvFCsw7
u0XdoR1jzZP4yUdDSWnaQC/QiZDD6QpAWu7xAjvmTh922VopYW0mriu/n9sv5tDX
sd4/iTj9e7mWBTq4Rb0tUzzfFQ7xFtPN9KfeWaSe7be0zpi2qAMxLGghDCrjnGh7
WssCzvPFVcUWZ4YQGSDJP/ojXmdtSnvc3eNbjXicbmat/XjwYNAgA1j4Kn4W2ZbJ
e/r3JkQ5szQMK9o20vdDKoU6mwywm52huII5MAHrxPygb18nn2XvHnPIA+u7WRsA
ujekSLa+D2u5kJhG7Cokpl++Yck9HwgQmEouolQyXezTo3t3F6ePlHfnmbrxfYWD
m/DKq2X7G7uGV9PLEzJUbF+HFnehqaSjmD9b3cXRljC1blAs7MYIRGOof16dkph6
HXe+KZU9Zwt8gjMV1EkO
=yDT8
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Sep_2012_10_03_23_+1000_qEs+xSQTLlxpDRnJ--
