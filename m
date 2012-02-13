Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab2BMFrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 00:47:43 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:55305 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab2BMFrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 00:47:24 -0500
Date: Mon, 13 Feb 2012 16:47:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michael Neuling <mikey@neuling.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org,
        linux-next@vger.kernel.org, ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Milton Miller <miltonm@bga.com>
Subject: Re: Boot failure with next-20120208
Message-Id: <20120213164714.dfb835bf2343ef2e6f24cde1@canb.auug.org.au>
In-Reply-To: <16788.1329102254@neuling.org>
References: <20120212113805.c7e5d902c95a9d0f4037e12c@canb.auug.org.au>
	<16788.1329102254@neuling.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__13_Feb_2012_16_47_14_+1100_mJyW/hvsWYR.b_k8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__13_Feb_2012_16_47_14_+1100_mJyW/hvsWYR.b_k8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 13 Feb 2012 14:04:14 +1100 Michael Neuling <mikey@neuling.org> wrot=
e:
>
> Reverting "smp: start up non-boot CPUs asynchronously" (8de7a96405 from
> next-20120208) fixes this problem for me.

I have reverted that commit (and the following -fix commit) from -next
today.

Thanks for tracking it down, Mikey.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__13_Feb_2012_16_47_14_+1100_mJyW/hvsWYR.b_k8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPOKPiAAoJEECxmPOUX5FEQyYP/j4i492ndRYNAYqG/nqOZq2G
X32x3AU5WRnceoNZ0/QgWSnAI4EfjZtX6s83XfuUneLRuUfeju1bI3P5qwkjG3bK
7QT+NpY6Z0gIEIT/TKrQLggGQx3Gaata0Xl/6flXRGyHDHXFBlzJFtqovx/uIS8K
WG0/HQBxAjkWJ6kkySxVVYdfZxLRCabTX00aAgXiidd/FsiV9o3ooPTKKfUhf4KO
BgIhgA5T21/L9BG1SSl2Jxp2P16/v8cRNo4enogYQvzQIexunhcRfVxPnbXwew5L
cvUEdiLxiqBSHK2Jny6tqupgpFKl2AGdKsu41QYwiQXkPfUxDjYYpnh2yVFIWCZ4
5FMVynjclwKybFuQJFuGZFwfSDE1gEm1FoNW8f4IV0KMN6kZoLMt9PabmG2HC8RB
G/T0F3MT/NUe4rjmMgyyymLz9XKpsuswBw+sNtaILx6uzTkRwS/dWmR+5uJds5E2
fOAF88ly5dBNMbwNc6c2JPWs39Iivt9jhLMSq7CUa84Qp/VMY+ydQI2uB+CcIj8A
BGBvbwd0IcOQEp4aLkSi9aTcN023xLtYQvrAwxKgeJCQTD3QXQflkBuKYKNbfDop
5Y9vLpu59I0+we7PudxPfNPoB0zL5BAIRFBVgl1SMgfDgF0BSUNoluc1rjV7Xj0X
AMN5IUM4bUkMaQ/I/hfz
=tjIa
-----END PGP SIGNATURE-----

--Signature=_Mon__13_Feb_2012_16_47_14_+1100_mJyW/hvsWYR.b_k8--
