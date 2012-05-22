Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab2EVWwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 18:52:31 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56707 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181Ab2EVWwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 18:52:30 -0400
Date: Wed, 23 May 2012 08:52:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the mfd tree
Message-Id: <20120523085226.7ffe604b626a2d96084ee682@canb.auug.org.au>
In-Reply-To: <20120522224214.GG10210@sortiz-mobl>
References: <20120521134219.6d6396802bd6a097503bac92@canb.auug.org.au>
	<4FB9F818.4030801@linaro.org>
	<20120521184005.3b7661ec6468c5878a22615d@canb.auug.org.au>
	<4FBA0460.1070300@linaro.org>
	<20120521191007.9347651e88add2e7c247a24f@canb.auug.org.au>
	<4FBA08A4.6030706@linaro.org>
	<20120521095427.GA30045@sirena.org.uk>
	<4FBA18C7.4030800@linaro.org>
	<20120522224214.GG10210@sortiz-mobl>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__23_May_2012_08_52_26_+1000_3mFUAkmld=s7q7hC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_May_2012_08_52_26_+1000_3mFUAkmld=s7q7hC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

On Wed, 23 May 2012 00:42:14 +0200 Samuel Ortiz <sameo@linux.intel.com> wro=
te:
>
> I would appreciate if we could have a fix for this one sooner than later =
as
> I'm planning to send my pull request by the end of this week.

Just so you know, nothing you have added to your tree since May 11 has
been in linux-next due to 3 separate build problems.  As far as I can see
the same will be true today due to the problem you were discussing here.

You quickest way forward may be to either revert commit d28f1db8187d
("mfd: Remove confusing ab8500-i2c file and merge into ab8500-core") (if
possible) or make the building of drivers/mfd/ab8500-core.c depend on
some platform where it is clear it will build.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__23_May_2012_08_52_26_+1000_3mFUAkmld=s7q7hC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPvBiqAAoJEECxmPOUX5FEgF8P/0nnRxj4iOvrnOj7O+u7+wl8
TnPBSGxfRSBezCIn+0R9NxDQGNOWnChtHwD8C5Cx18upeVzw7XYYXfq9Cl8G7FmU
zKRHbkveqz98nF3REkkf9EFMKK1goOp2Vmh4auvY2otUprT2PrybryP15XRPANSO
hgn7DH77gAOAap2MmZvxgAHXQLSgu2G6HwyOnw/qvCPj49rGrPhtaphi2spTSajO
eL2jyTbsYsJvfeAW1LgwBEVnv8s+FH6nu+87ZtBEV30P+lYTOM3QLmNPZZloh7Ew
H653WyFRj3RSE8mO9aqoDkOOPGIJnCyFBqOJdQP9MjF+n/GggxDCg4raSZM3UJns
0OSobKbQyxxuynR44Ni41YUOabI1OV529xq5MWHlksdEpw93jYO6Ua0Xo29nvtTk
m1rteZiIKpXUHgeus9iM84fe9oCMu1B5tE0vDcZ/p/fW1IlcRCYnfSDEWHzL7DLR
WF465bau6kateylsHSNyOUCvXN9w5zyhinbnNh/B8M4hLouIsfSEyHDrNuHsrbxH
RRCXGUD9wO4EzRws0CIolzL+ybshtMlryWRO0TyoVKTdoPNdx48MRDrgPajTdCHz
mgFJIiHepdRI6i83r2mYO6H+FhcR9mEzNFJgTar0pL52fhzZKoG8R1A3RdHkeo8N
Vs7ESIXN9iCV27Lh5kki
=RXQx
-----END PGP SIGNATURE-----

--Signature=_Wed__23_May_2012_08_52_26_+1000_3mFUAkmld=s7q7hC--
