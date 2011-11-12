Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972Ab1KLAGH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 19:06:07 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:49263 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab1KLAGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 19:06:06 -0500
Date: Sat, 12 Nov 2011 11:05:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "David Laight" <David.Laight@ACULAB.COM>
Cc: "linuxppc-dev" <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: Disabling TCP slow start after idle
Message-Id: <20111112110555.8ca6f5d81646718e90c4af80@canb.auug.org.au>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6D8AEBA@saturn3.aculab.com>
References: <AE90C24D6B3A694183C094C60CF0A2F6D8AEBA@saturn3.aculab.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__12_Nov_2011_11_05_55_+1100_VUv62bLcGypndbG/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__12_Nov_2011_11_05_55_+1100_VUv62bLcGypndbG/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

On Fri, 11 Nov 2011 15:30:23 -0000 "David Laight" <David.Laight@ACULAB.COM>=
 wrote:
>
> We have some connections that suffer very badly from the TCP
> 'slow start' algorithm. These are connections that will
> always be local - they may be MAC-Switch-MAC using RGMII
> crossover, they might also be connected via an external
> switch. In either case the RTT is most likely to be almost
> zero, certainly below 1ms.

You would be better off asking networking questions on netdev at
vger.kernel.org ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__12_Nov_2011_11_05_55_+1100_VUv62bLcGypndbG/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOvbhjAAoJEECxmPOUX5FEphkP/iO0kXlbL7uM3j3L3ec1GOmv
jjNl5yFRDFI9VYQxyL7wr9GPGkdpGLpp9ZWMIcm1frBEdED2Cdl5KJlGoQ4jpcvl
JZSWK9efnNxsBaXfqL5Bx7guSmq+91lKE2EXkrNZ0yax1Joe36n0TQGIqzSG0I/G
YAnUXOMOX5CObVSbKxXhi/etYlAc/5q3nByqyUj1OUSWfNBzst5u28wT/I+JOGOz
R9PY2g4fhJJqYHy9Yqi796j/aD+mgshFYvEoTl0/dqVchG0kCGVLxMCg6Mo1Vpww
eyQTnFA3XyQ5H/uz9lu60SDThGk94cZjGnuwSuFyhxNSpuv3Kh/bqPHxJO7Wd5Nr
V/87fEZ6TZNFtVnPJRvk0wrwHrC9x1CACFqUdUxmCqKW44LZ3UXzvuVGn4/c4Jz0
6thxF1pw2Ln9f9FVzJ5QJlgsDvjldGahFUdFkvCA1bimq3osY9Sa1xKRMM7/GCh0
XgKxTBbFMbYpIbJ+TRFDX2XT7ek7Lefae5CE33HNnYjJcDgPgi8NM7vuuRzU281n
SvX8JnwZ2HCy6XMz0xWWqYZ5r6CHZaRvI5LZR7eHvn4VuXVcfxYzHqN1T+JjmazW
7jTi/0VNkqR0Wv35VfEYZBtNmBjAl5M2WNxHTqYBsF/kMvc992arQe7KfI8ylhEU
t5CAjjkMzEQvz/Pz8f9s
=gm3S
-----END PGP SIGNATURE-----

--Signature=_Sat__12_Nov_2011_11_05_55_+1100_VUv62bLcGypndbG/--
