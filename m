Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757679Ab2EAD4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 23:56:09 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57872 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757437Ab2EAD4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 23:56:08 -0400
Date: Tue, 1 May 2012 13:55:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alexander Graf <agraf@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: linux-next: build failure after merge of the kvm-ppc tree
Message-Id: <20120501135549.5c865717b33650002f083d4a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__1_May_2012_13_55_49_+1000_9YZ=ToKnZSbujoml"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_May_2012_13_55_49_+1000_9YZ=ToKnZSbujoml
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alex,

After merging the kvm-ppc tree, today's linux-next build
(powerpc_ppc64_defconfig) failed like this:

arch/powerpc/kvm/built-in.o: In function `.kvm_spapr_tce_release':
book3s_64_vio.c:(.text+0x374c): undefined reference to `.kvm_put_kvm'
arch/powerpc/kvm/built-in.o: In function `.kvm_vm_ioctl_create_spapr_tce':
(.text+0x3ae8): undefined reference to `.kvm_get_kvm'

Presumably caused by commit 969f70395d6d ("kvm/book3s: Make kernel
emulated H_PUT_TCE available for "PR" KVM").

I have used the kvm-ppc tree from next-20120430 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__1_May_2012_13_55_49_+1000_9YZ=ToKnZSbujoml
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPn17FAAoJEECxmPOUX5FEMyEP/j3QNxzJ3flki5J0DOOf3zE1
gtbyGnFe8YK7v/vE1blNr0Wtx/DjP11FKUtrsuhvRIc4IrXpiiSdrPCspnJef4Y8
32OEAZkkBBldTXR/CQqcqP0ktuo5/OAvX2IMGU9iPPT/gB2teJdTkaiO8CdFu39S
tdpfqFuZcPXWZNxR+lDzWEfoAY99anN1AQ7nisYKNONJAm5OxrVO2zgIWYcLJl0T
u/np+Lv1fnCSxE+z2wLeQYA2kOkTw7Yf2ua8azPwE8NRFGfM8aK+EZEsopqXwG4h
+Dy1jjetug1CSrIf+1HJh6abEo3ErNACPIDrrhtfl69DDhXX049RxpVYl9Js0zNL
bs+7yoI0QNv5AXJbqsI671eT9pB+HO/xPajmoNVtc0Xf3r7JR2iBSW0Dl1FXfPOD
yUOvCG+FlEC+a5mzQOMwHZes2iVijv1kWmg9hB5Pft121IAnyFPctCRuy/7EIXR+
fSnbKmzlZI/tfaJ7NdG2hfVTsog6m8mkYyHZbuacfWCj3EopvX76Xh3++gTVgnZ6
6tk2duR2+Hoaali+80qb2RJA8x/6Rhp9xi5FxebcUCBuiU9TBlu8dsLj+QngCWNr
Cz+iFNvVubfORf/87n6565ahb/OtY+hbuvjX8fEJsLfWfcaev+czoL6dG9BG69eY
6abRku7nLqZw2yAP6UgZ
=xeLY
-----END PGP SIGNATURE-----

--Signature=_Tue__1_May_2012_13_55_49_+1000_9YZ=ToKnZSbujoml--
