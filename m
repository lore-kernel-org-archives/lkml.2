Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab1LLWod (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 17:44:33 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:44344 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab1LLWo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 17:44:29 -0500
Date: Tue, 13 Dec 2011 09:44:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        pjones@redhat.com
Subject: Re: Re-add ibft tree to linux-next please
Message-Id: <20111213094419.4c0ea2403c6d09751612892a@canb.auug.org.au>
In-Reply-To: <20111212145330.GA16278@andromeda.dapyr.net>
References: <20111212145330.GA16278@andromeda.dapyr.net>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Dec_2011_09_44_19_+1100_9LabR7rrOdi5PTm9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Dec_2011_09_44_19_+1100_9LabR7rrOdi5PTm9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Konrad,

On Mon, 12 Dec 2011 10:53:30 -0400 Konrad Rzeszutek Wilk <konrad@kernel.org=
> wrote:
>
> I've one patch for the iBFT and since I am the co-maintainer of said tree,
> please add this tree to your awesome build system:
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/konrad/ibft.git
>=20
> The branch is "linux-next"

OK, I have added that from today.  There is currently nothing in that
branch, right?

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

--Signature=_Tue__13_Dec_2011_09_44_19_+1100_9LabR7rrOdi5PTm9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO5oPDAAoJEECxmPOUX5FEaBwP/0lzObQioyNwX+QkNWO4Quh6
UpbVQY1IWH7lvm6VVcljHfU7woqLam1pOqEh0/1tJfixuyjd+2Y85bmfvZ8yLPJ5
7ExkrjMYLdZhniDxbWID62V/dd2Y3Ti58a5XjRdGvTZPkrK0yZdPqaVmNtZFLJK9
fBWw6Db+RFA5iIlPdm2CM0h243uLRpnxJs3ApixziM8si+XRmUvFH92eYDbUysdS
WyUGihF9/a2Z5Z33R/RxuPyhEXhJZprSv2reTI/LaxdX8Co9yyZP7TknMIWZOkBm
MA6xPEQipYpPYFFzn8OhPfIXLd/QcAHbevPAYZDt8XajtaCdgjqNEuKOjsPaHQae
LQT1ywFehhINUc/0cGSM0t1wKn536Y8AULdCnn5y1VWP8Es6DrTDSR5/oXliqeUi
MlZ4buuiMHX4UNXhW13OA+cmzWemRL15IbCarjSkVf8ZSDxS8agl9fHIBRJQevxN
OoaBbDEM5ybba3SJi4PPcMlFvhRcFsf9qaWarpX/fOjxcG3cXwRcYIDF1yQkAVOJ
saIe7R65Jl+N3I3Hd59OOMSMuegk9GvJLiaMjqtc3grVGNc+Cbw1Nc8hNRBRXEiA
c1CmLhNsGZxX0Y4ijsVDilwWyK3tvjqf1MRKg33IEtaJbKcZftmz9077hq528uas
fRFyneOby1JRdYWwS2JR
=uNIw
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Dec_2011_09_44_19_+1100_9LabR7rrOdi5PTm9--
