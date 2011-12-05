Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab1LETNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 14:13:35 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:58632 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932113Ab1LETNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 14:13:33 -0500
Date: Mon, 5 Dec 2011 11:16:05 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Sasha Levin <levinsasha928@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCHv2 RFC] virtio-pci: flexible configuration layout
Message-ID: <20111205111605.73b60faa@jbarnes-desktop>
In-Reply-To: <20111114181854.GA24953@redhat.com>
References: <20111114181854.GA24953@redhat.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/pIs=5uj_sahI834pRq7Htux"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/pIs=5uj_sahI834pRq7Htux
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 14 Nov 2011 20:18:55 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> Add a flexible mechanism to specify virtio configuration layout, using
> pci vendor-specific capability.  A separate capability is used for each
> of common, device specific and data-path accesses.
>=20
> Warning: compiled only.
> This patch also needs to be split up, pci_iomap changes
> also need arch updates for non-x86.
> There might also be more spec changes.
>=20
> Posting here for early feedback, and to allow Sasha to
> proceed with his "kvm tool" work.
>=20
> Changes from v1:
> Updated to match v3 of the spec, see:
> 	Subject: [PATCHv3 RFC] virtio-spec: flexible configuration layout
> 	Message-ID: <20111110122436.GA13144@redhat.com>
> 	In-Reply-To: <20111109195901.GA28155@redhat.com>

Looks like this conflicts with your other iomap changes... I didn't
check your latest tree; do you just add another patch on top for the
virtio changes now?

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/pIs=5uj_sahI834pRq7Htux
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJO3Rh1AAoJEIEoDkX4Qk9hjh4P/1yvlEFpEmkbdoPs091WOtnd
SqaeTG1GO9tQW9TJPDWuotu4MPIkA9WNdWKYvAvGzYGZ2t0SATwXZkJyDkfqg+u8
zQ/6sx/0sz6fZg8MK56BfkZ8ExRnttEVFei5KDS32nGih3rKzQkJVtnlH/eW6bRM
W7p/90N44+NBAcqly1ABxENfvS8jKk6218OmyaLxbQb8C3evpZqewSLApLB3nhPD
TMhlFsw9n03TM4G4jEa+IgoofPYyDmpyM4RQaRwC/LQKof4h8BQIjS3zfKMTzeL1
WwahmLaReBm7T2VPVcmUvWSvbZ6w77uz9PMzWCw+EeDGb1UEXT0IIVO6X7xilZ8b
vSFeysaqDlbvB5HbspEXbg/ZWWVKG8QW6sTInsXt25/pqKGj0yYNR+ul73LNI996
Dzoa4olgpXQTM4+EON4eaYsYJGcLq38dZz02E3S5FAs1Yu91B54VzIaAbeH24BzB
aJ6y1an6Cc2PyAG5xX6jzy941mQH+pSoQC4IIfApZxUAV63e8pEDGigLa5jurIfB
CrJEby8ix/s+ylvrLoWkgBhIaEPH2iTv6AIzRlZfF/cutMfDd/152Cdk8nOaQZhr
y0UQop9TMhwkEa4QnB+b38fjZlq4KpURFhQ30mX2+hCpmo6NjtlcBktI6Rkbfogk
MGYuWOpSectwfIKPDAZy
=4XTH
-----END PGP SIGNATURE-----

--Sig_/pIs=5uj_sahI834pRq7Htux--
