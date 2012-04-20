Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101Ab2DTDgL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 23:36:11 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50166 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab2DTDgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 23:36:08 -0400
Date: Fri, 20 Apr 2012 13:35:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric B Munson <emunson@mgebm.net>,
        Alexander Graf <agraf@suse.de>
Subject: Re: linux-next: build failure after merge of the final tree
 (kvm-ppc tree related)
Message-Id: <20120420133555.4343c7fc785ed6132a37a9df@canb.auug.org.au>
In-Reply-To: <20120420011413.GA12235@amt.cnet>
References: <20120419163535.52c99a34e2664063d654ac4d@canb.auug.org.au>
	<20120420101012.591b5e64a8939135bf5cd167@canb.auug.org.au>
	<20120420011413.GA12235@amt.cnet>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__20_Apr_2012_13_35_55_+1000_.N/o/ZyfcFIRSK1f"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__20_Apr_2012_13_35_55_+1000_.N/o/ZyfcFIRSK1f
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Marcelo,

On Thu, 19 Apr 2012 22:14:13 -0300 Marcelo Tosatti <mtosatti@redhat.com> wr=
ote:
>
> Can you try the patch below please?
>=20
> KVM: add kvm_arch_para_features stub to asm-generic/kvm_para.h
>=20
> Needed by kvm_para_has_feature().
>=20
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>

That fixes the compilation for me

Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__20_Apr_2012_13_35_55_+1000_.N/o/ZyfcFIRSK1f
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPkNmbAAoJEECxmPOUX5FEeGMP+wf34rBQAPcEq57b0GResF59
7QZ7cLN/IO8Ukia1RTPlBvFf9zG52bsY5d0e9tWeOhsr6OTuFnquDhxAlJQOm3Pv
poonPzlh4hqs6PdyHupUGdxgQzr4DupXLHyqqffL38otlh6dgK089FVbif85S58a
KSZkf/DF9GF3xpvOfOsmeAtbhM6cVnDw2rmXK7xVoo73Wp+PCRPioI6Z0qCgJes0
IZnfiv1qxNF6FRAmHrG820+13KKQtiFuaWNVT2dx1VDbDmIv/5kb/3mPOb6+IjM2
qC5xszEKDRdNq9YTnYJuPX0cWPjWjxnZ5YxbgXnhvXXgSo4x5ecE6zUE30p76WPn
zxx31qwWCwXaaiLVjFqeApYgzaAHWytY9F/k8tcch1PQQWjRVqf5SS4mgroH6eGe
0VzIZydeEicA75rcSG+QAcG6M8n1vUY6s0LkoTzmr/AwtFsLzG2XWe4Ez6lxUrpv
9OJHC+0nqg/LZZhPhzpQS/LPunnb0kxuNUttsQOk1Ie74XutIMAQFj3Q2388EOIs
wA/IbyzR3gEzsH9GpP/OvG4JT2sPMi8jK321PWpCsuQWneSzxh275nEp/OzrkR9p
EJaW6noz6eOqHEb+n3+IUnzC/82XRHf8vH2iVMqpiGhpjZfjgYeE8riSlst+V6B/
RogTT9vEcLTxzZ2IFwMS
=9Pq/
-----END PGP SIGNATURE-----

--Signature=_Fri__20_Apr_2012_13_35_55_+1000_.N/o/ZyfcFIRSK1f--
