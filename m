Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab0I2Asi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 20:48:38 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42514 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943Ab0I2Asg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 20:48:36 -0400
Date: Wed, 29 Sep 2010 10:48:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: cleancache into linux-next, target for 2.6.37 merge window?
Message-Id: <20100929104827.49e29a95.sfr@canb.auug.org.au>
In-Reply-To: <40229210-a2a6-41ab-9a88-bde956ebc66c@default>
References: <40229210-a2a6-41ab-9a88-bde956ebc66c@default>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__29_Sep_2010_10_48_27_+1000_4mp=MYKs=M3hH0++"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__29_Sep_2010_10_48_27_+1000_4mp=MYKs=M3hH0++
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dan,

On Tue, 28 Sep 2010 12:31:18 -0700 (PDT) Dan Magenheimer <dan.magenheimer@o=
racle.com> wrote:
>
> The "cleancache" patchset crosses multiple subsystem boundaries and
> at the recent filesystem/storage/mm summit, people suggested that
> after the patchset has stabilized, I should just submit it to
> linux-next and then directly to Linus.  The latest version has received
> no further suggestions or comments.  Previous versions received
> a great deal of review and comment from a wide variety of maintainers
> across all the impacted subsystems, as documented in the commit logs.
>=20
> Would it be possible to include the following tree in the linux-next
> build process?
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/djm/tmem.git#linux-next

Included from today.  I have you as the contact (in case I have problems)
if there is any other address I should notify, just let me know.

> The patchset applies cleanly against both 2.6.36-rc3 and -rc5.
> Against next-20100928, I see two very minor merge conflicts in
> mm/Kconfig and include/linux/fs.h due to minor changes from other
> trees.

Thanks.  I will send notifications for those (just so you know) and will
fix them up.  Minor conflicts are not a problem and can be fixed by Linus
when he merges this tree (or the others that conflict).

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

--Signature=_Wed__29_Sep_2010_10_48_27_+1000_4mp=MYKs=M3hH0++
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMoozcAAoJEDMEi1NhKgbs338IAI12C1e7BJWtkRdEXngD2azt
U6GVR24leqR1mKtTB7wDcJ2Xflx3MMrIXCA0n1hgmh3bgB7Af5TehYCqC2pcemOb
zesoj5JxCKPHJcTCz7Pj/oTAzW5GsrY5hmiojhyFXIcbSj1bYPOpMbKy1icv5X4g
VMwsLuD3Z4lFCjQoTQhArTIChIsTgiZlJgJHOoMNVR3I7ujzv6AiaMJ0JrH2knEV
lMOuUWZbcIpUcsEgNsZQggmXBQQM+ufgQDZA668B+kyAuw7tdXxaAAy3bBUgehz8
OCUH1nnKmsrDMcd9OtlYEpApLdEfRy/d1ZcPBZswMLiMm6W6/v9Jie5CzsAExes=
=We9U
-----END PGP SIGNATURE-----

--Signature=_Wed__29_Sep_2010_10_48_27_+1000_4mp=MYKs=M3hH0++--
