Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034Ab2IMMan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 08:30:43 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47902 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757881Ab2IMMal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 08:30:41 -0400
Date: Thu, 13 Sep 2012 22:30:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
        Amit Daniel Kachhap <amit.kachhap@linaro.org>
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-Id: <20120913223039.71ff6219a123981a817af0c2@canb.auug.org.au>
In-Reply-To: <1347525987.1682.1194.camel@rui.sh.intel.com>
References: <20120913174441.f5fbf5cc38713425331f4d86@canb.auug.org.au>
	<1347525987.1682.1194.camel@rui.sh.intel.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__13_Sep_2012_22_30_39_+1000_QX3sA9bAWHPQRKyz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Sep_2012_22_30_39_+1000_QX3sA9bAWHPQRKyz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Zhang,

On Thu, 13 Sep 2012 16:46:27 +0800 Zhang Rui <rui.zhang@intel.com> wrote:
>
> I'm new as a git owner, so a stupid question here,
> in this case, who should keep this fix? Do I need to do something when
> sending pull request?

Andrew will take care of it.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__13_Sep_2012_22_30_39_+1000_QX3sA9bAWHPQRKyz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQUdHvAAoJEECxmPOUX5FEX9sP/3YE2BnIfrFt0yKhnwbbb4YT
c4t+ARug5kksf5jYtJ7p+StFNZfm+UBcFgA/KG/vPkBuAWrnlAaRX8dmbkdDlNEK
pAUqGo1PwyoyzF6EJ6ER8Sy/xGDxkBH/JBJCt/K+q6dVvfgHEm+xKhDhCsrgn01A
/zzHLASBmESyCnTnZgSMqGxV7DBearZJrAyDwdyJre5bYV0xYjDKyRPU4ARId+UC
aOt/N/RSMq1Y3SdwHqzC9F9FSdshabl0w59Xkie8IUT7fKfatMpOPzuu8ExEmPUA
PQ2hxRFqndpe43HsSjDplpNHDsa1LVJ6yGf+a4ZEUf+KdYr04/HeOoBX5Y5XHcTX
cKHbkL2N16CO4fEELwayJ8rAeTkINY0ufg7BPJJESGH3UUeJZtXVdxuCaFM8DKyt
0Yjv0A4WXr14HJVs0SIz4iUltfo76Wol/OHCDIONCt8hjdz9tCIKEyN9dz0myqs+
Rv3aok4NVOA0jNyUPR0+MT7tUurR/dxuzpEJeBRbvkHQAp7ATR3KPkMOEDmxIkW6
bNVj+4BARins2+096KiXQjp9Tzln9VSooxT5Ts99m0BgPSaVlB+/aqK9fqWcNSVM
2OG8EL5sALUvr89Gc852x37ZLKtnbSzxVCIW6xzAHdmMDTDEzTpva2ToMMchQWqw
jf5J0v7em49EZ4hQiLn7
=h9RW
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Sep_2012_22_30_39_+1000_QX3sA9bAWHPQRKyz--
