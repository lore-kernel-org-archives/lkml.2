Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab1IFO6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 10:58:17 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:44797 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257Ab1IFO6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 10:58:10 -0400
X-Greylist: delayed 445 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Sep 2011 10:58:10 EDT
Date: Wed, 7 Sep 2011 00:50:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Cc: Andrew Morton <akpm@linux-foundation.org>, fzago@systemfabricworks.com,
        George Spelvin <linux@horizon.com>, linux-kernel@vger.kernel.org,
        Bob Pearson <rpearson@systemfabricworks.com>
Subject: Re: [PATCH v6 05/10] crc32-misc-cleanup.diff
Message-Id: <20110907005013.e96fb5acd9f4b7c06ee70972@canb.auug.org.au>
In-Reply-To: <OF0B1D5F8A.D8D66C8A-ONC1257903.004A257F-C1257903.004B1700@transmode.se>
References: <20110831213729.395283830@systemfabricworks.com>
	<4E5EB5F4.6010105@systemfabricworks.com>
	<20110902165047.6aaec238.akpm@linux-foundation.org>
	<20110903114403.027a9563c86eeaf1c0e4e80b@canb.auug.org.au>
	<OF0B1D5F8A.D8D66C8A-ONC1257903.004A257F-C1257903.004B1700@transmode.se>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__7_Sep_2011_00_50_13_+1000_wJV651r4FflnZp7u"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__7_Sep_2011_00_50_13_+1000_wJV651r4FflnZp7u
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, 6 Sep 2011 15:40:10 +0200 Joakim Tjernlund <joakim.tjernlund@transm=
ode.se> wrote:
>
> It seems like an early version of the slice-by-8 crc32 algo. is in linux-=
next,
> committed by you.
> That version is crap, whats the plan?

I assume that it is one of the patches in Andrew's tree. When things get
back closer to normality with kernel.org, I assume that Andrew will
replace it with a newer version (if he has been sent one).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__7_Sep_2011_00_50_13_+1000_wJV651r4FflnZp7u
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOZjMlAAoJEDMEi1NhKgbsvpMH+wULvcKCyai5df1iSSUZaqf2
X3u0GJKvQ6/oSpIVgEAgzxZZqbKLRVsImARVVUGlBeAv33V15kgwHMWAhX5okm3U
oZQttLnblW751iThJtuycue2xoHTTz0qvJxHBUovAmroxm3/da9Q8n02sJd0xrNv
P89EM2W5fkYzVJktrpJtFl/4QKvNOBx76ux9gkEtr2TmFjKFQrFPPtaem0BaRSFp
UbbnTwQ0uI6Btm+NldT8IDbCDgK5pdrKFxVNRIwDzG8DwIdf5KqpxKE7Hh4xrUMi
8J/Bj6w3ZohBQ0PYbUXrnYxO/2J0SI/Po8xL5ww7GAKm44v8H13z39WCIUDiE2E=
=zQEh
-----END PGP SIGNATURE-----

--Signature=_Wed__7_Sep_2011_00_50_13_+1000_wJV651r4FflnZp7u--
