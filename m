Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761631Ab2DLAor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 20:44:47 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53872 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551Ab2DLAoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 20:44:46 -0400
Date: Thu, 12 Apr 2012 10:44:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>
Subject: Re: linux-next: build failure after merge of the final tree
 (devicetree tree related)
Message-Id: <20120412104436.0aae78ca24cd9604d667f495@canb.auug.org.au>
In-Reply-To: <CACxGe6tDa+AzK0O=E+EPZ90Ek_C-rM-G4fHSnsdL0S+fNcmzmw@mail.gmail.com>
References: <20120411151155.b1a614f174442a592d1c1561@canb.auug.org.au>
	<20120412103157.70669ff82b81d5d926c36d4d@canb.auug.org.au>
	<CACxGe6tDa+AzK0O=E+EPZ90Ek_C-rM-G4fHSnsdL0S+fNcmzmw@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__12_Apr_2012_10_44_36_+1000_UThdy.2t3U.1WYR5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__12_Apr_2012_10_44_36_+1000_UThdy.2t3U.1WYR5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

On Wed, 11 Apr 2012 18:35:34 -0600 Grant Likely <grant.likely@secretlab.ca>=
 wrote:
>
> Yes, drop that tree or revert that commit.  There's nothing else in
> there and I didn't have time to pull it back today before you started
> linux-next for the day.  The change is bogus and I'll spin a proper
> fixup for tomorrow.

Done (I used the tree from next-20120410 - which was empty).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__12_Apr_2012_10_44_36_+1000_UThdy.2t3U.1WYR5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPhiV0AAoJEECxmPOUX5FEr9gP/j1pV4KZRmBvZHoCrmWEsN7a
tdNSnzH0+ae/t9lK+3WQPTFfeXSRL0tcp4Uj0dbPvxuRPp4gI3OZNvwV2hphyWsz
b9NHinHGOh/2iQYj4Bpq2ryD2MhMUkrbUEx4pvlSWQHJYwSXaMpQqbVMrWVciTHS
v/jME6aW2/AImD3GKx8cZsxuYGNqb9KG9nfIy04m18YRahIyudIXBT3TjhxLJMCX
cylKUxz1wfo6gRrEF++1ZGyqoKJHoqYvVVa1+OHr3NSJAMPMAT6sLliwi9r+mjjH
WcrvOvYJfqvYU0hNihzzew8+YpQcb4cg5v6+PK1Y/TlfcPcYTy4rRHQav4AfIeA1
p6rQ11ztRZOUNcv+7++XnzgZveUsb9bKXm/NCL8BISCR8aeqVIfsptfN3gel8ETo
O3d6mdtmPUFFXPKSm5lbejU1at4r4sbqPFJ4W43Loif/i7Wlyyut9nTl41l76OD8
+uBM543EpNreIvoxb8CXcpBlh5rtnrcCuqFieSktQ87s8tVvP8p6kioLv+tBZAd5
lgwGcC+2fHWQAThb9xzcX8JY5aZLJ8VjFW77NmKR66wDh0uW6k96LkMyO85Xwmgm
TxAoAGFvVNb9CdOSykWpyX57xtyPz4uvihmjR6bqVFgxCxA9ZV0/PRh+WE6lRW7U
sMo0sx1PX4fsly11Rcf9
=k8Q4
-----END PGP SIGNATURE-----

--Signature=_Thu__12_Apr_2012_10_44_36_+1000_UThdy.2t3U.1WYR5--
