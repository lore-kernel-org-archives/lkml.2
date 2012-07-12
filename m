Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758301Ab2GLGXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 02:23:40 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40697 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756640Ab2GLGXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 02:23:39 -0400
Date: Thu, 12 Jul 2012 16:23:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alexander Graf <agraf@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bharat Bhushan <r65777@freescale.com>,
        Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: Re: linux-next: manual merge of the kvm-ppc tree with the powerpc
 tree
Message-Id: <20120712162325.624ecd07071801c5ce144f35@canb.auug.org.au>
In-Reply-To: <B6C6F6EC-BDD9-41DC-9677-4B7A4A52BDF0@suse.de>
References: <20120712135735.7678a50ffb107e3094af27b8@canb.auug.org.au>
	<B6C6F6EC-BDD9-41DC-9677-4B7A4A52BDF0@suse.de>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__12_Jul_2012_16_23_25_+1000_ZPoP98noNK2Kty=5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__12_Jul_2012_16_23_25_+1000_ZPoP98noNK2Kty=5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alex,

On Thu, 12 Jul 2012 07:56:46 +0200 Alexander Graf <agraf@suse.de> wrote:
>
> On 12.07.2012, at 05:57, Stephen Rothwell wrote:
>=20
> > Today's linux-next merge of the kvm-ppc tree got a conflict in
> > arch/powerpc/kvm/booke_interrupts.S between commit c75df6f96c59
> > ("powerpc: Fix usage of register macros getting ready for %r0 change")
> > from the powerpc tree and commit fc372c0843b8 ("booke: Added crit/mc
> > exception handler for e500v2") from the kvm-ppc tree.
> >=20
> > I fixed it up (see below - could do with checking) and can carry the fix
> > as necessary.
>=20
> Hrm. Ben already warned me that this will happen, so I did a test merge a=
 few days ago. Back then I also had to change 2 other bits that were not co=
nflicting, to get to code to actually compile.
>=20
> Could you please do an s/VCPU_GPR(r/VCPU_GPR/R/g in arch/powerpc/kvm/book=
e_interrupts.S? I'd check if you actually need it myself, but the tree does=
n't seem to be pushed out yet :).

Thanks for the response.   I checked and I think I got them all.  The
tree should be available as soon as the kernel.org mirroring gets done.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__12_Jul_2012_16_23_25_+1000_ZPoP98noNK2Kty=5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP/m1dAAoJEECxmPOUX5FEag8P/RO0/vo7z7hgTH+iQerBYXNx
M7q94rQVtphlhDVh/qhOp1K9Mcwn6rXKUXbEnrPJmEJPfCxQt2Fm2Q1+q3nFNTm0
ZG4RciCOBBBht5ayeGf0cEPobw2M31/9aSp9IhkN3nYVBUD7UQfdioxw95mGJgtn
HC/FnY+Pgc1kadGvr7IoezEIZvKA6k3S0+gtF3CDkF5lJK/DnmD7JhFt2oYeoM8n
cTUyo41M3Rz8sJnPiGvre1KEr7KLsoUri+L5SdnrgtHodJQRmn9Ixj3zoOY7NKLj
t0Ku8TbTKQjL008d2A1Dd/S9gVuEfQaIp8KRmtKDQt1Il0jXkw4Xy6beBpskFdbh
zSKfSeupHj42Mvt/qQvd9mxD3ZykXtT7xs27GC2BJrg4hMXY/HdHuegzIIoeg63g
RccycyJlr5crvEanSy6iK+3qhp4J21AEuYjcPfZUrarhS9jTuE6ErpJRrFSFQKK6
z4Qu+oxDcimGA7YFe0G3a9zEvg5/+aKs/fzuoodErW9cT/1dh98X7/I1bN893Kf7
T1RBRAGJ8zynYaWNn8eWI2S9X4k9IIrpOc0qanxBHN8wcSB8L1G6gZUaZEDxKvMe
IkIzPy3hxVtz5QTeVL1mA0bIHDtvii2ySxm9U08rW16h/WhjkBB6xkNAp+Fir9wK
VTJWWe+u11P6EKQEdXhv
=XRvH
-----END PGP SIGNATURE-----

--Signature=_Thu__12_Jul_2012_16_23_25_+1000_ZPoP98noNK2Kty=5--
