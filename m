Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab2BWSsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 13:48:30 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:36072 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756012Ab2BWSs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 13:48:28 -0500
Date: Thu, 23 Feb 2012 10:48:23 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Hao, Xudong" <xudong.hao@intel.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Kay, Allen M" <allen.m.kay@intel.com>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>
Subject: Re: [PATCH] Quirk for IVB graphics FLR errata
Message-ID: <20120223104823.7bac1916@jbarnes-desktop>
In-Reply-To: <403610A45A2B5242BD291EDAE8B37D300FCD089A@SHSMSX102.ccr.corp.intel.com>
References: <403610A45A2B5242BD291EDAE8B37D300FCD089A@SHSMSX102.ccr.corp.intel.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/P4Zy5anbcafpsmzP/Y_eDUO"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/P4Zy5anbcafpsmzP/Y_eDUO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 20 Feb 2012 02:27:25 +0000
"Hao, Xudong" <xudong.hao@intel.com> wrote:

> For IvyBridge Mobile platform, a system hang may occur if a FLR(Function =
Level Reset) is asserted to internal graphics.
>=20
> This quirk patch is workaround for the IVB FLR errata issue.
>=20

Can you name the magic constants and offsets and document what the FLR
quirk is actually trying to do?  IIRC it had something to do with
waiting for the PCH acknowledge for the display portion of the reset...

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/P4Zy5anbcafpsmzP/Y_eDUO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPRon3AAoJEIEoDkX4Qk9hzTAQANAijXxvHI5LTAkZbRjA2kYv
TL22RD4yujLxWchmUmuB8E+w8s11/jiPFDp2F5m4WvMU++jtyxXHD8XghXtqVfp6
UuUuAllVfzUlB/+IXOmLE7b7hWvLYLta6iFvUdfzC06kSZfLNnXpo6WJfWDKocgv
v5Ia0uXsIuxDjkBbDCydKm6o6qSeOxj+vEKpsiFFPFeCXn6zXq3h++em4YGl5dUG
fMP9DarYyXL7HSp1sL5bYJYnYEj+BUPVBf5uFAs2LA6E2XyV5apGQzJiZ1gBG34W
xt/uwmtpUVpBB5PQmZJ7byi5/YuDuPOXyeTXK7qKaF2OvyDE/bpRBSzN+mzFKM6X
U7iyA/R0h9UyIIefltClXwK6pamSoR3xSm206rXWbGUGdG97fBeHs1W9fsqcyuoC
DtEpFvSY1Su+RQKZD1MVW+nxj+jtuT4SoT1MNPsCdwnCKRV+7qMkQhYwB5IdVq1g
tAd/eRPjRmA3/oAJ63igGZHULoqqBP7YHhmzc3c2rezBUNakS1CtdBgXrviM/2zL
jQFajNbc+kTDZX8oJsjYN43hu/lJ5/A+/gUZ8MyAPZGfGt9OEAAhd8Ig7ZQBVq45
cMgJMfJFIb5n8tD3D3XYaXisKsA7HnTk5ScSTZ3w3/XuR2A3fsg+6djLqQkKC6jS
+xVErWz+PJjuE0uEbelV
=O8mZ
-----END PGP SIGNATURE-----

--Sig_/P4Zy5anbcafpsmzP/Y_eDUO--
