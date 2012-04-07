Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab2DGBKO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 21:10:14 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40048 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab2DGBKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 21:10:12 -0400
Date: Sat, 7 Apr 2012 11:10:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: change PCI trees
Message-Id: <20120407111001.7ee50d80316d3684a91c19c3@canb.auug.org.au>
In-Reply-To: <CAErSpo5a3t9-HQN-8zvK+wYjW6eAM5nVuQcfKPsaU6Ur1BZCwQ@mail.gmail.com>
References: <CAErSpo5a3t9-HQN-8zvK+wYjW6eAM5nVuQcfKPsaU6Ur1BZCwQ@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__7_Apr_2012_11_10_01_+1000_HjQlV0+PMb=.E+2Y"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__7_Apr_2012_11_10_01_+1000_HjQlV0+PMb=.E+2Y
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bjorn,

On Fri, 6 Apr 2012 12:16:22 -0600 Bjorn Helgaas <bhelgaas@google.com> wrote:
>=20
> Would you please replace these PCI trees in linux-next:
>=20
>     pci-current     git
> git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci#for-linus
>     pci             git
> git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci#linux-next
>=20
> with these new ones:
>=20
>     pci-current git
> git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git#for-linus
>     pci git git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git=
#next
>=20
> since I'm taking over PCI maintenance.

OK, I have changed to use these and put you as the contact (instead of
Jesse).  Both branches appear empty currently (just as a check).

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

--Signature=_Sat__7_Apr_2012_11_10_01_+1000_HjQlV0+PMb=.E+2Y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPf5PpAAoJEECxmPOUX5FES6kP/icCRHjAAsioh5Jgf+Iw3iRt
z9F1OQ8iHCAcaEvAAVs8TCEsef6WRaFEaXu2RSlzz8lDzAXmTDw+Dcm+0ZCQlgjm
5ebhCLrdnx8euJweuKzpfkTyA0sI2cUwkQOyzfnDGnqrlO6qBhVXIRSKr8HzJmeH
0ytvxevx0nPNkoiikQcIURDhotT4TmouO6mp5fQpfC5IcTz30bBZBzWyqzckL3zn
7viXlgvBx9qcufI53J10Ab1xWDnWyDONc9SZ3+V1gC7zMiWcKyUzo4A/wEL5eri+
yR0tXl03/Tej8a/CrT4BqiWBtQtZVUI57q7ZNb3bySYTwZEJdDIKuSLjvZoE7VeS
eaISVaYnOlWb/8Bp/u5Xco9f0MJ0cMitMTEwxGXmQ8Qyy5L7s/iLuRKZOwkm7EgW
Xk+BcvMfh8fAVAIDSUuJVsmzcJzHZa/cFdSxvoehlUIBasmVz2OKeyBxs3M1qHBX
LF0tFm5sULB+K6pDZLtun253URcY5KSKhTzDpjG/Ytj4mRAAJxM5Gy6O7fe5wV2M
GPnTzAab2UDkx9qJxCLHUglchQxabVfwdNSmd5rV+ZGH0r2OVTjjv1aed59UNwdy
wKUZc9bhx0JshcQ2F71PeatG0vRZ2+ixVWWQct928ADl0aPWfAch/+wzd6ATKAc+
Z5BX5Y70WhGsPqaFx+22
=QeVJ
-----END PGP SIGNATURE-----

--Signature=_Sat__7_Apr_2012_11_10_01_+1000_HjQlV0+PMb=.E+2Y--
