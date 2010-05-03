Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab0ECE50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 00:57:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35914 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027Ab0ECE5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 00:57:24 -0400
Date: Mon, 3 May 2010 14:57:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Heikki Krogerus <ext-heikki.krogerus@nokia.com>
Cc: Greg KH <greg@kroah.com>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree (usb
 tree related)
Message-Id: <20100503145715.def1a8f1.sfr@canb.auug.org.au>
In-Reply-To: <20100430062224.GB27724@esdhcp042221.research.nokia.com>
References: <20100430160555.d58bd9aa.sfr@canb.auug.org.au>
	<20100430062224.GB27724@esdhcp042221.research.nokia.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__3_May_2010_14_57_15_+1000_7yfV2CPUKwfgVFvy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__3_May_2010_14_57_15_+1000_7yfV2CPUKwfgVFvy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Guys,

On Fri, 30 Apr 2010 09:22:24 +0300 Heikki Krogerus <ext-heikki.krogerus@nok=
ia.com> wrote:
>
> On Fri, Apr 30, 2010 at 08:05:55AM +0200, ext Stephen Rothwell wrote:
> >=20
> > After merging the final tree, today's linux-next build (powerpc
> > allyesconfig) failed like this:
> >=20
> > drivers/usb/otg/twl4030-usb.c: In function 'twl4030_usb_set_bits':
> > drivers/usb/otg/twl4030-usb.c:238: error: implicit declaration of funct=
ion 'ULPI_SET'
> > drivers/usb/otg/twl4030-usb.c: In function 'twl4030_usb_clear_bits':
> > drivers/usb/otg/twl4030-usb.c:244: error: implicit declaration of funct=
ion 'ULPI_CLR'
> > drivers/usb/otg/twl4030-usb.c: In function 'twl4030_usb_set_mode':
> > drivers/usb/otg/twl4030-usb.c:303: error: 'ULPI_IFC_CTRL' undeclared (f=
irst use in this function)
> > drivers/usb/otg/twl4030-usb.c:304: error: 'ULPI_IFC_CTRL_CARKITMODE' un=
declared (first use in this function)
> > drivers/usb/otg/twl4030-usb.c:306: error: 'ULPI_FUNC_CTRL' undeclared (=
first use in this function)
> > drivers/usb/otg/twl4030-usb.c:307: error: 'ULPI_FUNC_CTRL_XCVRSEL_MASK'=
 undeclared (first use in this function)
> > drivers/usb/otg/twl4030-usb.c:308: error: 'ULPI_FUNC_CTRL_OPMODE_MASK' =
undeclared (first use in this function)
> >=20
> > Caused by commit 57983872ff14cba23d6404a40c89e52063c94854 ("usb: otg:
> > twl4030: use the global ULPI register definitions").  I have reverted
> > that commit for today.
>=20
> Already informed Greg that he needs the patch for the global ulpi
> registers before this one.

Still got this one today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__3_May_2010_14_57_15_+1000_7yfV2CPUKwfgVFvy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkveV6sACgkQjjKRsyhoI8zbpgCgngGS0geHuCIUfGRHWn9MuB6K
bVwAnRXc5SslbwiTklICrNWyfPFBJWG+
=FKUa
-----END PGP SIGNATURE-----

--Signature=_Mon__3_May_2010_14_57_15_+1000_7yfV2CPUKwfgVFvy--
