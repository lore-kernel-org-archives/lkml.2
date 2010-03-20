Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab0CTB4l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 21:56:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39610 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068Ab0CTB4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 21:56:40 -0400
Date: Sat, 20 Mar 2010 12:56:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Florian Fainelli <florian@openwrt.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Samuel Ortiz <sameo@linux.intel.com>, Wim Van Sebroeck <wim@iguana.be>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/4 v2] MFD: add support for the RDC321x southbridge
Message-Id: <20100320125628.6cfcf118.sfr@canb.auug.org.au>
In-Reply-To: <20100319135209.435131cb.akpm@linux-foundation.org>
References: <201003110942.09251.florian@openwrt.org>
	<20100319135209.435131cb.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__20_Mar_2010_12_56_28_+1100_WEvstMEVAqWMfAxW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__20_Mar_2010_12_56_28_+1100_WEvstMEVAqWMfAxW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Florian,

On Fri, 19 Mar 2010 13:52:09 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> On Thu, 11 Mar 2010 09:42:09 +0100
> Florian Fainelli <florian@openwrt.org> wrote:
>=20
> > +static struct pci_device_id rdc321x_sb_table[] =3D {
> > +	{ PCI_DEVICE(PCI_VENDOR_ID_RDC, PCI_DEVICE_ID_RDC_R6030) },
> > +	{}
> > +};
>=20
> should be const, methinks.

In fact maybe even

static DEFINE_PCI_DEVICE_TABLE(rdc321x_sb_table) =3D {
	...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__20_Mar_2010_12_56_28_+1100_WEvstMEVAqWMfAxW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkukK0wACgkQjjKRsyhoI8wczQCeOx2wdHCtGKqPo+jbQefC6N+1
hE8An37CKUcRgRRbrzmW2qhtPJvIOJmT
=Ovqm
-----END PGP SIGNATURE-----

--Signature=_Sat__20_Mar_2010_12_56_28_+1100_WEvstMEVAqWMfAxW--
