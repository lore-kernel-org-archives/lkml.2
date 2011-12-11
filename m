Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab1LKXdP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 18:33:15 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:36362 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab1LKXdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 18:33:14 -0500
Date: Mon, 12 Dec 2011 10:33:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-arm <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-next@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Brian Swetland <swetland@google.com>, akpm@linux-foundation.org,
        Greg KH <greg@kroah.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Saravana Kannan <skannan@codeaurora.org>
Subject: Re: Adding remoteproc/rpmsg to linux-next
Message-Id: <20111212103301.5ff6a582dca82394ace40e8d@canb.auug.org.au>
In-Reply-To: <CAK=WgbaU6vpiBGSgogYPjQNmrF-U0wk1rSXMX83DdgQa9hw5Mw@mail.gmail.com>
References: <CAK=WgbaU6vpiBGSgogYPjQNmrF-U0wk1rSXMX83DdgQa9hw5Mw@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__12_Dec_2011_10_33_01_+1100_m7Z3psDrM8tjJZuy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__12_Dec_2011_10_33_01_+1100_m7Z3psDrM8tjJZuy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ohad,

On Fri, 9 Dec 2011 16:55:27 +0200 Ohad Ben-Cohen <ohad@wizery.com> wrote:
>
> Can you please add the following remoteproc tree to linux-next ?
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/ohad/remoteproc.git for-next

I have added that from today.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Mon__12_Dec_2011_10_33_01_+1100_m7Z3psDrM8tjJZuy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO5T2tAAoJEECxmPOUX5FE9GIP/3/lJz6b9JMVdItDYQhSF3K+
7PkqKOzVKwj8MASWvlSqv4+7rJNUA9X5B8b6YJZYicF77hwXzz5gB3QYYVkpaZ+G
C/JQ6ddZauZ5yV9/3GKzXkX633U9J211GONHWzkXK75m8B0EPm9iMp5esbBk/eDr
jGH32RZR0OfPLm/9Efw7hu2zhSeVblQ4m/7Jahg+yt1tfJtM/nxDO7XR44pzHk1n
O92U3c6MJdBhEctPov78hotCBmPHGY0X+A4zfB9S7Vbz1K1mKu5pV0MHZGiHyqeI
xIXvc9YDNTeauqpBVKul/kUrjy9Qi5d+CGprXumZfdMuhlrs7e0oUpRwxM/FjNkU
7CeewnQQ5rq+wvY4HiEZ+fEFqD5qfjR1Gc5NjifH2aoMaGx3/D1bXjH5mY/3D4XB
hvQAm0kFCaRr9I00D+JdYWrgowO+9A3GFcAyf50uckOONA1bq4eGSfn15mF9BOD6
DUW5aH5BwjXr2f7BIbymhLFmhSyHQTCfJBV6g6m6Nh535vfxpWRqstrIqC0s5vmm
nP1RtPFqpSG2U+dNBjMLX96e7FvhhE86WfnVPyrkrx7CaBBuVEs8zRNTa7QRcncD
1fmT1u1hv/nwlYs4f8VHLXaEBx27OKmYKVeOdE7FGNqPN2r9o7dsaIeD+Tscioht
NEjcPgKdtsdCVaRnmGdj
=tTm7
-----END PGP SIGNATURE-----

--Signature=_Mon__12_Dec_2011_10_33_01_+1100_m7Z3psDrM8tjJZuy--
