Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932901Ab2AEVrL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 16:47:11 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:58541 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932376Ab2AEVrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 16:47:10 -0500
Date: Fri, 6 Jan 2012 08:47:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] use generic pci_iomap on all architectures
Message-Id: <20120106084701.8f704542754db826deda318a@canb.auug.org.au>
In-Reply-To: <20120106083916.9588034bde22a6803e327aa9@canb.auug.org.au>
References: <20120105145836.GA2751@redhat.com>
	<20120106083141.9c14a8d2d09539c6a6c0db75@canb.auug.org.au>
	<20120106083916.9588034bde22a6803e327aa9@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__6_Jan_2012_08_47_01_+1100_KBYSo2Pvqw7/GW48"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Jan_2012_08_47_01_+1100_KBYSo2Pvqw7/GW48
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 6 Jan 2012 08:39:16 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> So why does you pull request refer to "commit
> 805a6af8dba5dfdd35ec35dc52ec0122400b2610", I wonder?  Is that just what
> "git request-pull" produced?

I see, "git request-pull" just puts in whatever you specify on the
command line rather than the merge-base ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__6_Jan_2012_08_47_01_+1100_KBYSo2Pvqw7/GW48
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPBhpVAAoJEECxmPOUX5FESo4P/3ImliZXBEQhbm1KbwcAn4bd
BZLqpV3UUAxmDHt3OSZOlRDbAUuqAFWudezMk3cl0HcApBfeA8IjuWg7cCR+FPsY
srMXYyNX+TnByLsGUplQ+JQr+G32+hjG1/1z+jBLt5nKJneIxVhDLUFDcyb0peFe
Y2Ac5zc8rs9cLT51Dpw9oCVR2aeiY3qomUmuaTuAtdEvcGk0zfE8Ngj9z484SXXA
DJ6sQX4CWeFETZcPF/MMeQl5fMsH5B1h+qeAM/ttcyH6ZIW7mt4UNANbiOf8v8dB
2y6wePCOe/BRHDR9bcE2kJwR8nnGc7vpgJvbr3PMTQnmJwsmffRNwytwUXXrvb/X
vtItLETgWOdhaFylUw3QCItmVJM6tAJTWAHdAj6+IBAT+OSOe+4mey/C3r+y9UBT
O/7nKoQw3BN7s1KQifUB4qAtvp0ZmKsHo7+Z6Obb6aOL6Yp+I6g/33tT9pqfULyk
lghhWYiz7yq15ehcKbzZhU7HaJthmcPV9bw7pN1BcinLnwvXdQ8iEQ3p5n05yTG6
JnHiYM8AUdYvAGqb9o+aLHPdgcgBWdYQo4iFTaQiWv9CP9H3qCeRdeXFORwaA0Nu
ZUThqg78QGU6MIrB3p74ebrvgD0Sl9rEduyV0Z2rI/Nqgpqusf7RXTQl4RqUsL32
HxnRfQLBjmBOx3miTWMU
=3oyj
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Jan_2012_08_47_01_+1100_KBYSo2Pvqw7/GW48--
