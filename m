Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622Ab1ECAos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 20:44:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34780 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756914Ab1ECAor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 20:44:47 -0400
Date: Tue, 3 May 2011 10:44:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Marek <mmarek@suse.cz>
Cc: davej@redhat.com, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        sam@ravnborg.org
Subject: Re: [PATCH] kbuild: Fix passing -Wno-* options to gcc 4.4+
Message-Id: <20110503104440.700ea26f.sfr@canb.auug.org.au>
In-Reply-To: <1304338381-3772-1-git-send-email-mmarek@suse.cz>
References: <20110502111337.GA15769@sepie.suse.cz>
	<1304338381-3772-1-git-send-email-mmarek@suse.cz>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__3_May_2011_10_44_40_+1000_rup0Feo8wgP5DhCo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__3_May_2011_10_44_40_+1000_rup0Feo8wgP5DhCo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

HI Michal,

On Mon,  2 May 2011 14:13:01 +0200 Michal Marek <mmarek@suse.cz> wrote:
>
> Starting with 4.4, gcc will happily accept -Wno-<anything> in the
> cc-option test and complain later when compiling a file that has some
> other warning. This rather unexpected behavior is intentional as per
> http://gcc.gnu.org/PR28322, so work around it by testing for support of
> the opposite option (without the no-). Introduce a new Makefile function
> cc-disable-warning that does this and update two uses of cc-option in
> the toplevel Makefile.
>=20
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Michal Marek <mmarek@suse.cz>

This fixed things for me, thanks.

Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__3_May_2011_10_44_40_+1000_rup0Feo8wgP5DhCo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNv0/4AAoJEDMEi1NhKgbsucgH/1hKMuGZowgV6qv7nC2xhN8d
RBZPFiDQYwmtiycCPZK+E249sibmGb+SsLSBYlAp9R0A5r7RknNCIqZkxUhdBieK
jTPEE32Vg0ITMBX/1ul3+yY7NVLw4mZ9rmTlPFAXsgZ2sx/JGZQakFOzfRDU1HD0
0pWDeSHOiBL1581VKtYRF+ytASP6wMIa2AWEfwdtg2DhxUEOzlte25ojREOJASx0
JABaH5T/a3CViMzwTFUYgcmez5mdN3l3kouSyzqFT0fCJ02m5p02OKXG/2yG5Lj5
qFJfuliKvMTM+G+FMpKH88Bts7oo0Fa0Mq6MilWl4vS0NZpBJqtG9ER8iZyD7GY=
=9MYQ
-----END PGP SIGNATURE-----

--Signature=_Tue__3_May_2011_10_44_40_+1000_rup0Feo8wgP5DhCo--
