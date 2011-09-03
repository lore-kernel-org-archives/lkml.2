Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab1ICBoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 21:44:18 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38059 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377Ab1ICBoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 21:44:17 -0400
Date: Sat, 3 Sep 2011 11:44:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Bob Pearson <rpearson@systemfabricworks.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        fzago@systemfabricworks.com,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        George Spelvin <linux@horizon.com>
Subject: Re: [PATCH v6 05/10] crc32-misc-cleanup.diff
Message-Id: <20110903114403.027a9563c86eeaf1c0e4e80b@canb.auug.org.au>
In-Reply-To: <20110902165047.6aaec238.akpm@linux-foundation.org>
References: <20110831213729.395283830@systemfabricworks.com>
	<4E5EB5F4.6010105@systemfabricworks.com>
	<20110902165047.6aaec238.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__3_Sep_2011_11_44_03_+1000_LbiNHs/SQrsrdpP/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__3_Sep_2011_11_44_03_+1000_LbiNHs/SQrsrdpP/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 2 Sep 2011 16:50:47 -0700 Andrew Morton <akpm@linux-foundation.org>=
 wrote:
>
> Sure, these these things may be accidentally dragged in via nested
> includes but it's bad to depend upon that - such things regularly cause
> breakage when configs are changed.

And even the same config on different architectures or platforms.  That's
why we have Rule 1 in Documentation/SubmitChecklist ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__3_Sep_2011_11_44_03_+1000_LbiNHs/SQrsrdpP/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOYYZjAAoJEDMEi1NhKgbsBh8H/ipGz4miQXC+KgzTd15++qMC
eAvIP/ta2Fg4SEl2HseJVkxCBOt6qi49s/iUsfy8ybUndnjHCmsNPG2NYGpp7+mF
y8VE8vNFzyuPSuaDX+ch21LcUqmiZuACK9JcvgGKobNMbMsDiSwfaT1SPnv+wxIW
mQOi/5+9KFKZdwlj3CXVkj+e8Tp5bkWf+iQIPUbelvkJ9UWaeqW6Z+92TI2FTaMQ
QI9PWI0i4EmkaU95gLbEQA8kjWsKGXutdNZFf+WSBcsM9E/g6bYJ8c/tpUelzv8Z
B1L0EbxED1uTc8WyIBlvKgJKKmGcx3eGTq451fKxW65NrRIgGSMAyXiZuPhE2Ls=
=oGAd
-----END PGP SIGNATURE-----

--Signature=_Sat__3_Sep_2011_11_44_03_+1000_LbiNHs/SQrsrdpP/--
