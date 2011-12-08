Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab1LHXe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 18:34:56 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:55557 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab1LHXex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 18:34:53 -0500
Date: Fri, 9 Dec 2011 10:34:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: error while fetching the hexagon quilt series
Message-Id: <20111209103444.64a1e274b03ac7f7bb6c54fe@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__9_Dec_2011_10_34_44_+1100_puWb.sQX7HfE8c6V"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Dec_2011_10_34_44_+1100_puWb.sQX7HfE8c6V
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Richard,

Fetching the hexagon quilt series produces this warning:

Read error (Success.) in headers.

And hangs for a long time ...

I am fetching from https://www.codeaurora.org/patches/quic/hlk/linux-next/

I will use what I have previously fetched.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__9_Dec_2011_10_34_44_+1100_puWb.sQX7HfE8c6V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO4UmUAAoJEECxmPOUX5FEbcsP/0Ya2Srdrm7aff5KJS90ykEh
IAgpC9aEWLAkYFdXON8MTgcjghJwLAOs6d1z4I+KqCZJpc3fpGB21hu3IiHv2fOJ
cr4ZU/l6IRsJMIsEd+HSOH26kfo6JCL8q96xiJa1VcgY4JkKVb8uyG16Pi1+vA+o
sMt+Seuefjq2wX03Ep1OFXHt6x/JhSAq5CPQLHstgtsDFAtQT+6yK2dXdM+bigm+
wsarM6bZEhDpUeOdqC9zSfzjan+sXTCD2EX+l12c5zxW5+ogkVsZTpTuTw1JwKLe
3CoOVLVZSuLhQaf+TpUE6oky+wXVmEzSFDvzPap53NiJhfZGcu02bquMhAT53kz/
skpT0n3OY7+OUXV0OQWJPqMagVqXpLGd5LJuhHt7+bKKgDn7zXoVwDdc45krGDmF
d3QSA+qxZ4Ae/HAqHKIxUOAjhxAiJ41VBFP+Swf/ldPgCCYwd47jDoKo1wOgfEBp
3+a8p4oi7Rj4QQs9LTmoB0oXnq6SgjvBHqndjrI9vHr0qxOPTEHDJwWBynxP1kW6
PADyN1L63UUHtlQc8/nbPFwnkUvSXehcOF+fhAWjOpUK34JGg3bnkbg5GoB5leys
XQuUo4hcvHvDPv2TR96foLGBBnOPCORI+vdhSNq4IU9o9scuhqJEAgzgvEj2SyhB
vb91SYytB7qJZUtmQj3p
=EuPS
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Dec_2011_10_34_44_+1100_puWb.sQX7HfE8c6V--
