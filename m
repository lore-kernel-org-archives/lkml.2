Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284Ab1FOEWG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 00:22:06 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34556 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883Ab1FOEWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 00:22:04 -0400
Date: Wed, 15 Jun 2011 14:21:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: brudley@broadcom.com, henryp@broadcom.com, rvossen@broadcom.com,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the final tree
 (staging related)
Message-Id: <20110615142155.bd538b73.sfr@canb.auug.org.au>
In-Reply-To: <20110610223423.GB15868@kroah.com>
References: <20110609172745.dfd3a298.sfr@canb.auug.org.au>
	<20110609184127.GA2760@kroah.com>
	<20110609192243.GA3980@kroah.com>
	<20110610160548.529797c7.sfr@canb.auug.org.au>
	<20110610160938.cd01c408.sfr@canb.auug.org.au>
	<20110610223423.GB15868@kroah.com>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__15_Jun_2011_14_21_55_+1000_i4py0U7hgmpj0JoX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__15_Jun_2011_14_21_55_+1000_i4py0U7hgmpj0JoX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Fri, 10 Jun 2011 15:34:23 -0700 Greg KH <greg@kroah.com> wrote:
>
> On Fri, Jun 10, 2011 at 04:09:38PM +1000, Stephen Rothwell wrote:
> >=20
> > On Fri, 10 Jun 2011 16:05:48 +1000 Stephen Rothwell <sfr@canb.auug.org.=
au> wrote:
> > >
> > > No, I still get these:
> > >=20
> > > In file included from drivers/staging/comedi/drivers/addi_apci_035.c:=
7:0:
> > > drivers/staging/comedi/drivers/addi-data/addi_common.c: In function '=
i_ADDI_Attach':
> > > drivers/staging/comedi/drivers/addi-data/addi_common.c:2765:7: error:=
 implicit declaration of function 'virt_to_bus'
> > >=20
> > > virt_to_bus is only defined for 32 bit powerpc (not 64 bit) (and maybe
> > > not at all on some architectures e.g. sparc).
> > >=20
> > > From Documentation/DMA-API-HOWTO.txt:
> > > "All drivers should be using these interfaces with no exceptions.  It
> > > is planned to completely remove virt_to_bus() and bus_to_virt() as
> > > they are entirely deprecated.  Some ports already do not provide these
> > > as it is impossible to correctly support them."
> >=20
> > Drivers that use virt_to_bus should Kconfig depend on VIRT_TO_BUS.
>=20
> Ah, I missed that, sorry.  I'll go make that change as well.

Ping?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__15_Jun_2011_14_21_55_+1000_i4py0U7hgmpj0JoX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN+DNjAAoJEDMEi1NhKgbsv8kIAKCZic3iOslCCBXMGGQLc08K
OmtvzoteyXdJmB3qtzN/K1uwRpHmNmesS5l2bVYaIgB2aPU4vQovqPHJtt7cIQML
IIx1BKE2xhSHfJ2OdL4UnLxn+fa/wE9yufPcTcLeRh4HKIjacesf66dF9nbZ4xp+
4FKgYMgIWpO5mq71YQihGhT/D90qaQOvedpWbluTw9i9RqeasUV2FD3jIoHaOqgo
9ZNK+BHP5Kcfl4Tgb+egMayqIAmR5ZVIoHHNHiHj9nLgcCNB6ov+Mj0RhQQp7oTG
TrpWute9+Qh6aIPjaCkPzId4KK6B8H9yXyWJzJ9TpIh+NfqbijrDqmyq6N57UUI=
=95mT
-----END PGP SIGNATURE-----

--Signature=_Wed__15_Jun_2011_14_21_55_+1000_i4py0U7hgmpj0JoX--
