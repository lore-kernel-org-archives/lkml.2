Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab0JTXpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 19:45:54 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48857 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009Ab0JTXpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 19:45:51 -0400
Date: Thu, 21 Oct 2010 10:45:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Chris Wright <chrisw@sous-sol.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: xen PV on HVM and initial domain merge in linux-next
Message-Id: <20101021104541.8e10159a.sfr@canb.auug.org.au>
In-Reply-To: <alpine.DEB.2.00.1010201644380.10348@kaball-desktop>
References: <alpine.DEB.2.00.1010191254460.2423@kaball-desktop>
	<alpine.DEB.2.00.1010191847290.10348@kaball-desktop>
	<20101020113256.3647b1d9.sfr@canb.auug.org.au>
	<alpine.DEB.2.00.1010201455160.10348@kaball-desktop>
	<20101020152808.GA22328@dumpdata.com>
	<alpine.DEB.2.00.1010201644380.10348@kaball-desktop>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__21_Oct_2010_10_45_41_+1100_aOZ1O+a0EbuxnsNc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Oct_2010_10_45_41_+1100_aOZ1O+a0EbuxnsNc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stefano,

On Wed, 20 Oct 2010 16:47:51 +0100 Stefano Stabellini <stefano.stabellini@e=
u.citrix.com> wrote:
>
> Good idea, I have created a link called linux-next to
> 2.6.36-rc8-initial-domain-v5 so the following should also work:
>=20
> git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git linux-next

I have added that branch from today with just you listed as the contact
(if you ant anyone else (even a mailing list) listed as a contact, just
let me know.

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

--Signature=_Thu__21_Oct_2010_10_45_41_+1100_aOZ1O+a0EbuxnsNc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMv38lAAoJEDMEi1NhKgbssYcH/Rgoe/X3hHmTyxgC9NHtLPPH
NJB4HMSj7XUq1IA9ZBodDDhHVnjht20Dgo0ZBX8VU/HLunyHcrWjJ5PqQ4IPaTXm
KfakafvDOByNQSZ9iFDYRIAFin1EcvjXExJaSNbWqqlzeqZ/Pu1MPTavq+VQwlUM
+LaSc++JhMzs435lswNiS1UxvbofAkSTH/qu+JPh2kJnK/URF47petNPHLeEg9EK
RA6xfNiyw24n4ACEJgV2XNGF40nMUWhRNxx2T/1TwWwwEG2KtIW7RmjcuP5BrtnO
EFX/MRnEc7hE3UPVDDbKr+SH6yFDfNc2aPdyQGTZ0Cm3Ht6sSarn2IfRnGP66lc=
=3G9U
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Oct_2010_10_45_41_+1100_aOZ1O+a0EbuxnsNc--
