Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202Ab2IJX0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 19:26:25 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43228 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757256Ab2IJX0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 19:26:23 -0400
Date: Tue, 11 Sep 2012 09:26:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        lkml <linux-kernel@vger.kernel.org>,
        ARM kernel mailing list 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Another tree for "next"
Message-Id: <20120911092614.d42403c55b516ea898fb5e21@canb.auug.org.au>
In-Reply-To: <504E28CE.6020103@wwwdotorg.org>
References: <m3obli3j7a.fsf@intrepid.localdomain>
	<20120910100144.dcbe2715cde0fea51345a354@canb.auug.org.au>
	<m31ui9g4ff.fsf@intrepid.localdomain>
	<504E28CE.6020103@wwwdotorg.org>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__11_Sep_2012_09_26_14_+1000_lK2CLpO5o7jM3GHt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__11_Sep_2012_09_26_14_+1000_lK2CLpO5o7jM3GHt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Krzysztof,

On Mon, 10 Sep 2012 11:52:14 -0600 Stephen Warren <swarren@wwwdotorg.org> w=
rote:
>
> On 09/10/2012 11:42 AM, Krzysztof Halasa wrote:
> > Stephen Rothwell <sfr@canb.auug.org.au> writes:
> >=20
> >>> could you please add the following to your "next" tree?
> >>>
> >>> git://git.kernel.org/pub/scm/linux/kernel/git/chris/linux.git  branch=
: next
> >=20
> >> Could you be a bit more clear about what will be in that tree, please?
> >> Also when you repost this request, please post it a bit more widely am=
ong
> >> other people/lists who may be interested in this work.  Remember that
> >> linux-next is really only for stuff that is ready for Linus to pull in=
to
> >> the next merge window (or bug fixes).  Also, would this tree be pulled
> >> directly by Linus, or via some other tree?
> >=20
> > My plan is to merge all the stuff I'm (eventually) working on in the
> > above tree. For now - mostly IXP4xx (ARM CPU etc.) stuff which goes to
> > Linus
>=20
> ARM-SoC-related pull requests should be sent to the arm-soc tree, who
> will then aggregate all the ARM-SoC-related changes and issue pull
> requests to Linus.
>=20
> That is, arm@kernel.org, plus the Linux ARM kernel list CC'd.
>=20
> The patches would also need to be sent to the Linux ARM kernel list (and
> any other relevant lists) before being applied to your tree.
>=20
> ARM core changes would likely go through Russell King's tree, perhaps
> depending on what dependencies they have.

OK, I have added your tree from today.

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

--Signature=_Tue__11_Sep_2012_09_26_14_+1000_lK2CLpO5o7jM3GHt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQTncWAAoJEECxmPOUX5FELRcP/2tZvPT6fUCH1QL/sjGJbFVr
w23G8840XkPhM76XeqfHGpXXAmOWg18wp0AxRcCrx9CbkiIaK4kbunIabppfZWuv
pUVKN0x9LUjQ9WRavKqGewH8/p3U2o+6w29Dm2Q9lQ8q/f946uN0Hsa8Qk85Lg1T
UbieyD5wCR9g0ngk9yaMZTG7dD56WFpfeT+jzp3hQOTME9TJs3yaaT56C+8C3td5
U23PJBso6/8IxS18sxlhTw8qPt8Z7jaYi4KOHbXwuH22wDkrQkn3epXoIynUTMVp
qUb4hcEXHh4njak6uQpuBLv/6V9QZFhQxkczaqGETVRB0RkF/xjWncuigdI42464
sN+ARhMQ63gSbgTQ/Wi7Nn8mYSZRm2d6r2WKwsI3eWSP4mWIuJKt4Ec6uQJ+EuGb
rfNqY9g2G97x6ho2e+pa+hRzH4muTcV0HnCvl8a61xz19m2xBCcxWEHMg/ccyPEI
F1xEssMdegKWmhd2u9+z8bmA5fNJlmTrUAPcCCcdzNoGHKwXLxqzAFr4CyDV53Th
6MW2Yv9Kqm55TFzjWIpko8ZvANq9IU9oDoQzlPl3Ls3dGmj0Yuh2McUZG8WdVhFc
C1CaXFYkUfIKautvtDjWyePdI2RckpOCvlccWqlespWqDHbuLqiPtflXD8HoL+b3
NO+PLa13+ulrsLI2C7x3
=v75K
-----END PGP SIGNATURE-----

--Signature=_Tue__11_Sep_2012_09_26_14_+1000_lK2CLpO5o7jM3GHt--
