Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751030Ab2KBEIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 00:08:40 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52909 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab2KBEIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 00:08:37 -0400
Date: Fri, 2 Nov 2012 15:08:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>
Subject: linux-next: build warning after merge of the usb tree
Message-Id: <20121102150828.74ea49649b1601ecb5d0eaef@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__2_Nov_2012_15_08_28_+1100_g17bG9abxosQvRIw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__2_Nov_2012_15_08_28_+1100_g17bG9abxosQvRIw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the usb tree, today's linux-next build (x86_64 allmodconfig)
produced this warning:

WARNING: drivers/usb/host/ehci-hcd: 'ehci_init_driver' exported twice. Prev=
ious export was in drivers/usb/chipidea/ci_hdrc.ko
WARNING: drivers/usb/host/ehci-hcd: 'ehci_resume' exported twice. Previous =
export was in drivers/usb/chipidea/ci_hdrc.ko
WARNING: drivers/usb/host/ehci-hcd: 'ehci_suspend' exported twice. Previous=
 export was in drivers/usb/chipidea/ci_hdrc.ko
WARNING: drivers/usb/host/ehci-hcd: 'ehci_setup' exported twice. Previous e=
xport was in drivers/usb/chipidea/ci_hdrc.ko

Introduced by commit 3e0232039967 ("USB: EHCI: prepare to make ehci-hcd a
library module").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__2_Nov_2012_15_08_28_+1100_g17bG9abxosQvRIw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQk0c8AAoJEECxmPOUX5FEr3wP/RpkxpTahyWhwZXO7AFSNIZH
y5Pm01GJylmBvBh6m4kByQBeMiXYfEVKPDv0SelpkCKJiV5ba3II+9kxFZmQrEfE
EqhMbJ2G11yYzyrWwlfn93mT119r1V6lowqsga98kYvkjoQZ1faWU0rAT0esnvJ2
7vYCXmevFvqqBqutkoIZ6mZNSSVr49BrvFtAloowJlor3pP3BsTXqEh6Q/j9CN0F
89Izq72LFAT2xOJXHCjWBj7qPT3bHV/KnpD569vkkP5TiTcGVXi1WZNalrbG6UeU
VBaZijP0nM+iL5BK8/zm+jN2qOW1hVQAv0wvuIYC31viw+eAu77Ld0kSLu9fhVBi
vLUyneKj28kg8SLDuOYJWSYfURPfqYPBhDBtukmlIR0wkhaiCEv7NiHK2KkTuZne
nJv8qRchUFvwz0Izswk1KUUpQWpfYgGkSkXIs/cN7O25CajL2cmxZOrHuhfI1Oqd
E03yDrweAjT6jWyT7w6ikyZvEs5BqISXjKy5D/s3OEGMFZRVnwmyGJPqdwIm0Cyw
jtWRswSrTg8rgjCJt5HPEwZRYPfn7sTkSlmuzHxovGJkGL/v1e+hAshDCA0Y0/iN
/G6obwLF4oXwz+I716H1L3XSzdI4ERkYVfgi9t5pNMtwhr7P/emCyFzlSzOOt4+q
5gsyfvEmr4fWRupIkuHL
=eVRH
-----END PGP SIGNATURE-----

--Signature=_Fri__2_Nov_2012_15_08_28_+1100_g17bG9abxosQvRIw--
