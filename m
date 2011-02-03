Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751098Ab1BCFO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 00:14:57 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36889 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713Ab1BCFOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 00:14:55 -0500
Date: Thu, 3 Feb 2011 16:14:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (net
 tree related)
Message-Id: <20110203161448.ce197f0b.sfr@canb.auug.org.au>
In-Reply-To: <20110202.204606.226770967.davem@davemloft.net>
References: <20110203151309.d4a6c344.sfr@canb.auug.org.au>
	<20110202.204606.226770967.davem@davemloft.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__3_Feb_2011_16_14_48_+1100_4MD5415/1E8fWo/+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_Feb_2011_16_14_48_+1100_4MD5415/1E8fWo/+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Wed, 02 Feb 2011 20:46:06 -0800 (PST) David Miller <davem@davemloft.net>=
 wrote:
>
> This problem has existed forever, you just have only been testing
> the build with fib_hash enabled instead of fib_trie.

All I have been doing (in this case) is a sparc32 defconfig ...

> I'll fix it up, thanks for the report.

no worries
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__3_Feb_2011_16_14_48_+1100_4MD5415/1E8fWo/+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNSjnIAAoJEDMEi1NhKgbshwUH/A8QXOusQP7JPZOhbNI7VeZj
tsf9UK9aXdr2/aw+nihp3ve2PYp4Rzi13gCufCZVS0pwigRerjVCWmFaSb96gLwK
mJhBrj7MQX8Y676b0iWX0nfiiTiQv2d7Lb1KnqoR8E0fxMXCYAhUDSl6YNeWZmI/
vHDbTzlrVgMXwXeKY4U3c1EcA+7UUzxjarM5eZeS9JzOcMDj6LfLwSGcxA9WKDpr
lWpVVVXZlIbE8kmx+bURcdY0SxB0Gk0N+LU8ODAKRhdcs3XH86xl673wwrv2yb0j
7C6+KGQ6mJSsfuS2QkLVOMU8UZOXAXERarhmqRs2MI2fXKLblxkbJfqxzZpzbwI=
=Ujbm
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Feb_2011_16_14_48_+1100_4MD5415/1E8fWo/+--
