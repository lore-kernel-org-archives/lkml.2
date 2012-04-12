Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759089Ab2DLAWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 20:22:49 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35346 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab2DLAWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 20:22:47 -0400
Date: Thu, 12 Apr 2012 10:22:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: paul.gortmaker@windriver.com, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tony@bakeyournoodle.com, mmarek@suse.cz,
        lacombar@gmail.com
Subject: Re: [PATCH 3/5] drivers/net: remove IS_ENABLED usage from wiznet
 drivers
Message-Id: <20120412102236.14d10178523e8dc5096d2980@canb.auug.org.au>
In-Reply-To: <20120412100619.9cbd13da03b2a7ecac143392@canb.auug.org.au>
References: <1334188257-3449-1-git-send-email-paul.gortmaker@windriver.com>
	<1334188257-3449-4-git-send-email-paul.gortmaker@windriver.com>
	<20120411.195444.540814653660043985.davem@davemloft.net>
	<20120412100619.9cbd13da03b2a7ecac143392@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__12_Apr_2012_10_22_36_+1000_vJX8_YKt3jlTmEmo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__12_Apr_2012_10_22_36_+1000_vJX8_YKt3jlTmEmo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Thu, 12 Apr 2012 10:06:19 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Sure - *after* it has been reviewed, and tested :-)

Sorry, overreaction with limited context and less limited irritation  :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__12_Apr_2012_10_22_36_+1000_vJX8_YKt3jlTmEmo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPhiBMAAoJEECxmPOUX5FEZWgP/ApM3xd11G0lK9tCLV1iDqcW
wg4sqTxRBGQzMJFFKo5aTjDff1aZoxpv5OhxLmzeckqkmU+ScuyqIaFBKqOrgBqu
vu0KTz+NZdXydm/QccaHf7wv5Efeknp7PCWBcgi+EFbM/S/D3qQ1XZW+rK97grSn
EhhPZPRW262wEyw0gsAmiaCQBDauaCX2g+CRuhitpWviYJSxHgP9o101ojh5MvIb
b7XNarvADtEXPTsw8yuAz8xY6iAppByBxeanVJnfjcTOCPVht1QYP5mMNT4CDczB
nKyO96amWOvKHuk8Mqp2SVFlRQVVpriPpjLbsRVwreGE3bj3gv3Un32/mlc/nI9o
YAnFKwIPPzKGQqXEYyVBZQp1VRYUsRybGmeTbBmbLOzKd1+Fa7/wG5Gy9PCXeBX6
bo9AAvFsBXZtALty7HZ3zBWX2irneIHJwErxyhrMOuyI6eQG/oGxqE8TiWSBMTpq
tzi3AJFbnAspkYxpOcXtn7ToU4Nuh4Vfb/M1ZbWdF0eMPx3iNOj+2iR3E/ms3lYm
LXfOFWwSPx2UiueHU5B/lyZeIAxJctj6P0lab7Yo3hD708O2OVUEkv4T6sUIXvxl
zebp03sjODJsMmTNoNFXufAISk285zhYRoj6KQN08HBjmE8dHIeVW5MkyQiu1gX2
+q6kSX+Zb42hAggtJJa2
=fxzB
-----END PGP SIGNATURE-----

--Signature=_Thu__12_Apr_2012_10_22_36_+1000_vJX8_YKt3jlTmEmo--
