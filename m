Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab1KMMUJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 07:20:09 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:35732 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab1KMMUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 07:20:07 -0500
Date: Sun, 13 Nov 2011 23:19:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Bob Liu <lliubbo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        Mike Frysinger <vapier@gentoo.org>, sonic.zhang@analog.com
Subject: Re: Blackfin.git tree change
Message-Id: <20111113231944.4677bd7a2154975c989663ab@canb.auug.org.au>
In-Reply-To: <CAA_GA1f8+6bqXGXo33GDbJmXvaqdD-qMUh=ejx0+Ag-shmc0uw@mail.gmail.com>
References: <CAA_GA1f8+6bqXGXo33GDbJmXvaqdD-qMUh=ejx0+Ag-shmc0uw@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sun__13_Nov_2011_23_19_44_+1100_bopK4kjb3T7HGvQa"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__13_Nov_2011_23_19_44_+1100_bopK4kjb3T7HGvQa
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bob,

On Fri, 11 Nov 2011 18:49:59 +0800 Bob Liu <lliubbo@gmail.com> wrote:
>
> I'll take most of the arch Blackfin maintain work from now on.
>=20
> My tree is:
> git://git.kernel.org/pub/scm/linux/kernel/git/lliubbo/blackfin.git#for-li=
nus
>=20
> Would you please update it for linux-next.

OK, I have switched to that tree and will put you as the contact.  Should
I also keep Mike as a contact for problems with this tree?

The only thing I did notice, is that this commit was in Mike's tree but
is not in yours:

Author: Sonic Zhang <sonic.zhang@analog.com>
Date:   Mon Aug 1 17:53:21 2011 +0800

    Blackfin: add serial TX IRQ in individual platform resource
   =20
    The serial TX IRQ is not simply (RX IRQ + 1) on some Blackfin chips,
    so move the values to the platform resources.
   =20
    Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
    Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Just in case it was forgotten.

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

--Signature=_Sun__13_Nov_2011_23_19_44_+1100_bopK4kjb3T7HGvQa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOv7XgAAoJEECxmPOUX5FEk8YP/23rnx8KdwpW7c28mQP7YI8p
2vIi1WjO6xd/WMDh9SudHhEVdJ2s6L8C7cuJVcyf6XMCjV25ai1LVrQ5RQVfi39l
5CqvhbfHglPcKKUaFCpkl6shXZSx8RSJlUo/SAYPiHjWgQ51rbIeVQ+3K2p7o+PA
BlDYuWCr6GbCYdRk44IE0Y0Eth04sm6ezPwItEkfaeuKc6JHAPIcMY32Nhr9cXZt
c6P5OJnRhvaN4JDbMzlS9KsshqJjLdg/+hkfkykSOnrOepiUN0RJWcy6ADwdzSB+
ElMT6kIiIaL5NJOLQUzO5lqZ4RG08g/i8Gk2WduOOB9/gW9Zanq1KqRooVaHtb3c
5uk9idZeb5EIOnWYdu+p5BKwaP8NEmxr762ZPE2npnBETon8QP0tsI+JBibk5doM
1vPJMVKX1apudp3pA+NjFnRcC2Q97ZiyGB+sNWxToCc74F1wqioS+Nt6EFr6PAWM
QxtjK2axjFpzi7lOiKhOfbhAGWvSnC+jiXISxbKxY2KspFg6tJS50Sf7d6ev/hFs
AYSxzelVYrUqSjVLZCFivN6Rkv1bkZ2wqlwOOxM430tZXsPrwsK51VQJ3YYZbycp
5M4c+6bBPG/UtfhzD20v79DuMlOsNz7+C216PvVASlJHS3VRT9SiagX8cBMRSPxM
9KHPWyz9u5QkIoA1tnKq
=45aS
-----END PGP SIGNATURE-----

--Signature=_Sun__13_Nov_2011_23_19_44_+1100_bopK4kjb3T7HGvQa--
