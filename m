Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab0INCCv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 22:02:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59078 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107Ab0INCCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 22:02:50 -0400
Date: Tue, 14 Sep 2010 12:02:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 02/25] arch/powerpc: Use static const char arrays
Message-Id: <20100914120232.c50056ba.sfr@canb.auug.org.au>
In-Reply-To: <a2d6296e9aabed2de77ae0b44f16b13008129e48.1284406638.git.joe@perches.com>
References: <cover.1284406638.git.joe@perches.com>
	<a2d6296e9aabed2de77ae0b44f16b13008129e48.1284406638.git.joe@perches.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__14_Sep_2010_12_02_32_+1000_pML/CNC5HhCDluv5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__14_Sep_2010_12_02_32_+1000_pML/CNC5HhCDluv5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Joe,

On Mon, 13 Sep 2010 12:47:40 -0700 Joe Perches <joe@perches.com> wrote:
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/powerpc/boot/addnote.c    |    4 ++--
>  arch/powerpc/boot/cuboot-c2k.c |    4 ++--
>  arch/powerpc/kernel/irq.c      |    2 +-
>  3 files changed, 5 insertions(+), 5 deletions(-)

I am also unsure that the transformation to cuboot-c2k.c adds anything.
Other than that

Reviewed-by: Stephen Rothwell <sfr@canb.auug.org.au>

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__14_Sep_2010_12_02_32_+1000_pML/CNC5HhCDluv5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMjte4AAoJEDMEi1NhKgbs6KcH/AnRgTZc22rupS1hcHUNspvF
Mhu+QCqxDvj04PNjThqlR+KmsKInTX34IxaDUjzbOf4oZHzBgn9sgz3jnafRMD2k
b1deBhg/z7dcFSNwqGnn74tpUuLFIFUPV4Jsw70SVBW/iMlO0NL/uwvCyCN5esHt
hoDMk5bJKOkLQAN2ffL3zyahNCSm8+qROkPEtzyyCSNhnn11uYI5LznGpaxSV4VP
W1vQ0O8UEjHT+Tx7ejxR7/0kBZu+2AOpZo2DmlFSpjq7hFLBQfFQwofzM8iwehD9
TMK7N7hCcXDxOBPgLyBrNBKc4QajoAXFn9q5Ew7f9z1k2osSYq+htq8TbsK2r6U=
=pzGa
-----END PGP SIGNATURE-----

--Signature=_Tue__14_Sep_2010_12_02_32_+1000_pML/CNC5HhCDluv5--
