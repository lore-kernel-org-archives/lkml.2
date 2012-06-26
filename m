Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab2FZXuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 19:50:39 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35023 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709Ab2FZXuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 19:50:37 -0400
Date: Wed, 27 Jun 2012 09:50:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        iommu <iommu@lists.linux-foundation.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        chrisw <chrisw@sous-sol.org>, "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        linux-next@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: Request VFIO inclusion in linux-next
Message-Id: <20120627095024.e282e975c2870e696bc5693f@canb.auug.org.au>
In-Reply-To: <1340686552.1207.128.camel@bling.home>
References: <1340686552.1207.128.camel@bling.home>
X-Mailer: Sylpheed 3.2.0beta9 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__27_Jun_2012_09_50_24_+1000_Sx7/QrQtfP5RPHEQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__27_Jun_2012_09_50_24_+1000_Sx7/QrQtfP5RPHEQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alex,

On Mon, 25 Jun 2012 22:55:52 -0600 Alex Williamson <alex.williamson@redhat.=
com> wrote:
>
> VFIO has been kicking around for well over a year now and has been
> posted numerous times for review.  The pre-requirements are finally
> available in linux-next (or will be in the 20120626 build) so I'd like
> to request a new branch be included in linux-next with a goal of being
> accepted into v3.6.
>=20
> The info for linux-next:
>=20
> Tree: git://github.com/awilliam/linux-vfio.git
> Branch: next
> Contact: Alex Williamson <alex.williamson@redhat.com>
>=20
> This branch should be applied after both Bjorn's PCI next branch and
> Joerg's IOMMU next branch

I have added this from today.  Since this tree merges (parts of) the pci
and iommu trees, I am hoping that those are to remain stable - if not,
then you need to stay alert if they are rebased.

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

--Signature=_Wed__27_Jun_2012_09_50_24_+1000_Sx7/QrQtfP5RPHEQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP6krAAAoJEECxmPOUX5FEe0oQAKlT1Bzl1IOgrG2oyn6u+Xvi
vANClPIluKR6eREwqJyriVRKFXs0aOxFMVRiX4ipQR9H3CB8jcNXjCs9FZw0HLT8
Of6fsiSqmgRgccK1brqZh7ig0s6FF5ENLYOy4wCIVZEOPTTaLZL2k9Q2w+B9CSa6
1W5va/48zulQQ+v7bhMO4F0fKSr7eiFwMTGeq7biOfTPp4wRT6jmxUoJJurhS2vd
KCIA8cAC1qbuEG+MPM5joI81dUT7psZKLzVfJ5xqC+1UVTvIOTk+FOeh3T/vBJnq
nMBL2PVdR1YL3tOtchaQIyjHyGUBvqHGXbx9ouNDkhvTjsMQ8SXv+70s2ULw97Y1
TJOzKc6X2csmG/FMkoVXtyceJsSMRvqKeNMxsPTEe7SSnYKqIZfuv9Q1ZuE8Uj7S
AHP3mqAuen2z2YD4uIQI3xr3hdrcFUB9ah8tUIjd6pFEEGZMrbMSmV2gerfrBTuK
9MMkrAp+RUlJtyBr7TokIDQ5li4l9wohZwqlDNtsrqKz7Z5bDDnOBlgKx6xzjslL
jfCREhXOIf9RoPeRQN1gkNOGKfT6ybQvRt+IicRKKr9ldqtbFDk1ef+2Ri9e5LfF
mAbjGf4H81JkY7n0KL8gWKkKr6mNbvEhFDQwZE/8QFkXek1jeuoOtB+JrYzUPcln
W46VM0suopaofi2D+CXL
=mbqL
-----END PGP SIGNATURE-----

--Signature=_Wed__27_Jun_2012_09_50_24_+1000_Sx7/QrQtfP5RPHEQ--
