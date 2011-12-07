Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097Ab1LGROG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 12:14:06 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:50608 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756943Ab1LGROB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 12:14:01 -0500
Date: Wed, 7 Dec 2011 09:13:54 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: build failure after merge of the final tree (pci
 tree related)
Message-ID: <20111207091354.412a9102@jbarnes-desktop>
In-Reply-To: <CAErSpo5fO87Aj8_PcdTT5V1JC6D8_o5WEpEMmHCeC=2PA9rkoQ@mail.gmail.com>
References: <20111207170533.3dea865573c916e79d274eca@canb.auug.org.au>
	<CAErSpo59CuEBbu4QWMkK23TyXafhMLOh1G7Z8YxojqiQmCM0Fw@mail.gmail.com>
	<CAErSpo5fO87Aj8_PcdTT5V1JC6D8_o5WEpEMmHCeC=2PA9rkoQ@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//YYdEWMj2BFX4DjXepp_Va4"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_//YYdEWMj2BFX4DjXepp_Va4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, 7 Dec 2011 08:25:39 -0700
Bjorn Helgaas <bhelgaas@google.com> wrote:

> On Wed, Dec 7, 2011 at 8:08 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > On Tue, Dec 6, 2011 at 11:05 PM, Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> >> Hi all,
> >>
> >> After merging the final tree, today's linux-next build (sparc64 defcon=
fig)
> >> failed like this:
> >>
> >> arch/sparc/kernel/pci.c: In function 'pci_scan_one_pbm':
> >> arch/sparc/kernel/pci.c:697:7: error: incompatible type for argument 5=
 of 'pci_create_root_bus'
> >> include/linux/pci.h:665:17: note: expected 'struct list_head *' but ar=
gument is of type 'struct list_head'
> >>
> >> Caused by commit fa3cec8aff53 ("sparc/PCI: convert to pci_create_root_=
bus
> >> ()"). Same typo as for the powerpc tree. :-( =A0Please double check the
> >> rest of those changes, please.
> >>
> >> I applied the following patch for today.
> >
> > Thanks for doing that, sorry for the trouble. =A0I don't have a set of
> > cross-compilers, unfortunately, but I will inspect the rest manually.
> > Do we have to discover problems one-by-one, or can you tell us about
> > any other arch build problems at the same time?
>=20
> I checked the rest manually and didn't find any similar problems.
>=20
> The corrected patch attached (same as with Stephen's fixup) is
> attached.  Also available
> at git://github.com/bjorn-helgaas/linux.git on the "pci-scan-v5"
> branch as c0cab2621d0cf75e86fbbad44d0b2b84c3a42f97)

Squashed the fix into the original patch.  Thanks guys.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_//YYdEWMj2BFX4DjXepp_Va4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJO357SAAoJEIEoDkX4Qk9hvzkP/iF5FQek+w7tF//oQmKYCjBU
xmGAvfyI/VZK7a5eqNimPVY7Zz6xCTmWmnGrehmHWo9I9IysmUZ0K0rQ3fdbTrci
9mOU5FK8yykyKCktqbz9eAftB21crKupyy8Ewy8c1xtdk4S5IffjyXlwfpU+odxR
qVB/iGC3wRpBCIxaoj7x5lcrvnesxZpi5ZOoHTWI9rbHzCu4y7f1w5QrbuNK+9DG
G5y6y991PC4AvzGARbYikdYXM7/oTf8GqMzy1BzJlXGF3BH/Bh2vBHtbKVQf0Ndk
D4bU8oJdKlWKIRZLYAn5xkGonwQDVoYSDMXbmXbIjHvmNXWuWkeKyE0v2+eucFC7
s7ETwg7VkrUeVnuTJmOc0taR5+7R56GF1RrxbCgd5EhUImY4CZwyQuLvV9jW4SCT
4IXZnsg78zLHDiKWVJTfCNFEh0lZ+02kaD6fUqdWa/H3AzCTwljrwGKLec3j/FQ5
Uw4Dy0OqciwaiCMEmgWwpWUTFZ+GM/STXEYtNg3mveHObs1o63KWoj5o/mP2zKSc
UaQdCNbBIxslPbA5bOR1HpdYRuNIsXd6c7o+deMWhLzzNkiVRdVUmRo3GoulIm9H
/FVVVpLGS9s2RuJdA1MQqpMTOjNu4JgjOx45Rh6UoPJV+iAmrGP1yRn934frHEvs
QJUjnebtW9twprzJmV7X
=O/rF
-----END PGP SIGNATURE-----

--Sig_//YYdEWMj2BFX4DjXepp_Va4--
