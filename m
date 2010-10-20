Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab0JTAdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 20:33:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60026 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab0JTAdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 20:33:08 -0400
Date: Wed, 20 Oct 2010 11:32:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-next@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy@xensource.com>,
        Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
        xen-devel@lists.xensource.com
Subject: Re: xen PV on HVM and initial domain merge in linux-next
Message-Id: <20101020113256.3647b1d9.sfr@canb.auug.org.au>
In-Reply-To: <alpine.DEB.2.00.1010191847290.10348@kaball-desktop>
References: <alpine.DEB.2.00.1010191254460.2423@kaball-desktop>
	<alpine.DEB.2.00.1010191847290.10348@kaball-desktop>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__20_Oct_2010_11_32_56_+1100_pL+.Lu3v92dlWSZF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Oct_2010_11_32_56_+1100_pL+.Lu3v92dlWSZF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stefano,

[just casting the net a bit wider ...]

On Tue, 19 Oct 2010 18:51:47 +0100 Stefano Stabellini <stefano.stabellini@e=
u.citrix.com> wrote:
>
> I forgot to CC the LKML and linux-next...
>=20
> On Tue, 19 Oct 2010, Stefano Stabellini wrote:
> > Stephen,
> > I have two patch series to merge in linux-next:
> >=20
> > PV on HVM: receive interrupts as xen events
> > xen: initial domain support
> >=20
> > they have all the acked-by needed and are both stable since several
> > weeks, however they depend on Konrad's xen-pcifront series and for this
> > reason I waited until now to ask for a merge in linux-next.
> >=20
> > Could you please pull:
> >=20
> > git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git linux-next-ini=
tial-domain-v4
> >=20
> > it contains both series rebased on Konrad's pcifront series merged on
> > linux-next (warning: it still contains the merge commit of
> > xen-pcifront-0.8.2 in linux-next).
> > Let me know if you have any conflicts or if you need me to change the
> > branch somehow.

Not following the Xen develpment at all, I would like to have a positive
reply from the listed Xen contacts, please,

I do have concerns that this is turning up so late, but I realise that
that is mainly due to a misunderstanding on the part of some of the Xen
community.

Also, the above tree is based on next-20101019 which means that I cannot
use it as is.  All the trees merged into linux-next must be base on some
other stable tree (almost always Linus' tree).  linux-next is rebuilt
from scratch every day, so I cannot ever include a previous day's version.

Merging in other stable trees is OK (as long as the other maintainer is
aware of that and makes sure that their tree does not reabse).

Basically what you send to me should be what you intend to send to Linus
during the next merge window.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__20_Oct_2010_11_32_56_+1100_pL+.Lu3v92dlWSZF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMvji4AAoJEDMEi1NhKgbsZwAH/ifmhJjU7zlDB+SeLpWhZQ9w
YfR4dJueInee82Bkm/Z0iEY+9LHp4Ws2X34poz5wY6MrKNnYtb3MBuMpYtfsMRUL
VUlcZBh68GaFRPl3AJdnZbKOBWlh0hKkYau4zPLl9LI++S1UXttVR95lxZBH0Gq+
yqXp2wZU113vLOmcVhdjK9NjQN998PkhjaVwuj1IhMkMktswE7G5j3PzsSuzcgmT
cdGmG2Wm3c/d4EOr//aIj2Moc8D63RZMXtE7Nbark37UDnG3VHV7SRmljK1EGsmO
fDwVbvuIRL18etJjMzTDgnOb5263lVBfCwC8B6xmeeveev2cTZDR8q2yttim/XQ=
=V12H
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Oct_2010_11_32_56_+1100_pL+.Lu3v92dlWSZF--
