Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab1BMXRJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 18:17:09 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36542 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755156Ab1BMXQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 18:16:59 -0500
Date: Mon, 14 Feb 2011 10:16:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for February 10
Message-Id: <20110214101653.1b159114.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LFD.2.02.1102110000090.3384@x980>
References: <20110210180525.54ec83e9.sfr@canb.auug.org.au>
	<alpine.LFD.2.02.1102110000090.3384@x980>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__14_Feb_2011_10_16_53_+1100_vHQ8/0g3ln6BFn/N"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_Feb_2011_10_16_53_+1100_vHQ8/0g3ln6BFn/N
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

On Fri, 11 Feb 2011 00:05:25 -0500 (EST) Len Brown <lenb@kernel.org> wrote:
>
> Please add this branch
>=20
> master.kernel.org:/pub/scm/linux/kernel/git/lenb/linux-idle-2.6.git tools
>=20
> It is a branch for the stuff in tools/power/

Added from today.

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

--Signature=_Mon__14_Feb_2011_10_16_53_+1100_vHQ8/0g3ln6BFn/N
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNWGZlAAoJEDMEi1NhKgbst3wH/0dy/NykPD7yTnOhLYzSaCsj
dT4/IY1I7SxWDlFg6jGzp8NHnnnGNNtSIQRCiOWf++hnXMaEd3pc/aIEeCxCOlrx
vMlwS5/k7HRmIT1TfrO7vvEMFIAf0v+NQJPrrYOj+jzRQcH71mv2brobcDi5IeK6
ZyAt429Ll+e9KV6SPHlflYztE9SAtwZgi21+h43+YNom/VkiXnDMuq2a2KqHH0Qe
5i2F7copvsQFcU9YJw7RHU4yFzA1qyM5dTaWquIQjl27FvFbz9N99rYw+oZCTLWC
yJX03kaykHXp0yPt8hWEJPOrln3OWKH44G8qR0iUTTEgrOAymDGyGHZN4R0zxK4=
=RZBH
-----END PGP SIGNATURE-----

--Signature=_Mon__14_Feb_2011_10_16_53_+1100_vHQ8/0g3ln6BFn/N--
