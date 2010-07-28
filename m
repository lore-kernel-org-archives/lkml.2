Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab0G1PfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 11:35:24 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52471 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808Ab0G1PfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 11:35:18 -0400
Date: Thu, 29 Jul 2010 01:35:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: please pull in from lost-spurious-irq branch
Message-Id: <20100729013509.22731f11.sfr@canb.auug.org.au>
In-Reply-To: <4C5035BF.9040904@kernel.org>
References: <4C5035BF.9040904@kernel.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__29_Jul_2010_01_35_09_+1000_Mz+QQOM61RVq8N/L"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Jul_2010_01_35_09_+1000_Mz+QQOM61RVq8N/L
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

On Wed, 28 Jul 2010 15:50:55 +0200 Tejun Heo <tj@kernel.org> wrote:
>
> If possible, can you please pull the following branch into linux-next?
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git lost-spurious=
-irq
>=20
> It's scheduled to go through tip/genirq, so once it shows up in tip,
> the above branch can be dropped from linux-next.  As the merge window
> is closing in, I'm hoping to get it tested enough in linux-next.  The
> branch is based on rc3 but merges without conflict into the current
> mainline.

OK, added from today.  I'll keep an eye out for it in the tip tree.

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

--Signature=_Thu__29_Jul_2010_01_35_09_+1000_Mz+QQOM61RVq8N/L
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMUE4tAAoJEDMEi1NhKgbsPPQH/0/wPk7kXvirolFvdlsiO4pY
laN5uMwj8X8vj6k50+fme6tYfcRmy1hWLaXdrbgZ4EITN1BIW90jyGjHThIEs17S
IaRUvaBFojd3SRWaqDBXF1w4yBr/2fRChyXiYqH/PkeVddMinNPq/w6okgAf9/go
6WiEFp/CFWXf9NydOCy3bj/evv0lnxfTUJqtje5DcQS6q5GYWrUgea+krnbJqjoZ
BdAT/PUEQXuGALbzyCM97PFvwslOvR5m5FTjJcMSkyn+ZX/Sy/ZgK/qOEaoEPfqW
7xABeSUNTmotFVN9w0oZZ0AIcu6WF41LAjTnyr533yzvOKjJrnapMzFncjHiez4=
=G9MZ
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Jul_2010_01_35_09_+1000_Mz+QQOM61RVq8N/L--
