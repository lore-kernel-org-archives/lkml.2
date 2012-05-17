Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965542Ab2EQDrq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 23:47:46 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60340 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760958Ab2EQDrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 23:47:45 -0400
Date: Thu, 17 May 2012 13:47:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: linux-next: build failure after merge of the drm tree
Message-Id: <20120517134736.dd91f7c321dca6c7cf459484@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__17_May_2012_13_47_36_+1000_HqM+OguHZB73IAtC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__17_May_2012_13_47_36_+1000_HqM+OguHZB73IAtC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

After merging the drm tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

arch/x86/pci/fixup.c: In function 'pci_fixup_video':
arch/x86/pci/fixup.c:352:3: error: implicit declaration of function 'vga_de=
fault_device' [-Werror=3Dimplicit-function-declaration]
arch/x86/pci/fixup.c:353:4: error: implicit declaration of function 'vga_se=
t_default_device' [-Werror=3Dimplicit-function-declaration]

Caused by commit 6cf20beec4b9 ("x86/vga: set the default device from the
fixup").

I have used the drm tree from next-20120516 for today.

If it is relevant, I merged the drm tree before the sound tree today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__17_May_2012_13_47_36_+1000_HqM+OguHZB73IAtC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPtHTYAAoJEECxmPOUX5FEKBkP/i9ZM+TOKA936XXkABDpHx3H
EdDzDG9uo4LVJVZ6v/PsJdW1WNL/SHJ+RHf2T00yZNVV8OnSkPPgzkgBVn6sqICU
9lovxjuH8167U46qa9SE/WOS3HkY9e4OwIZg0ltYugRmE+c6wbBx/j1Ut6fSdaXP
1blSgqgxzEUNYsseJVyoXTTJcC0GCiBU08c61mK1mfnXbde9qwRJ8NbwLfvxI60E
1gUSBG4Jk7rtS7uU712oW4jD8RRK8CkF18mrCu1ovQDe47FK51YjdARMzuHnLFc3
wUEt7KNZKcE57ZS7vu0zM0/+5ZwjXfqCXcG0FZoqvXy0DeFQnuF+n9g3c9Smnjef
rgUgTUFvasqFBaEiMAsx2JBzR8XXGuTE7m+3Lo2oeN38hq+hyBvXqgyx4/5KmGhI
mx5iyobluamndTP99Pqmm7/WP5lxHUws7HNKcca2Nutp6o9/amMsB2OkOltkNk2/
A+CXYntFvDbXmMXDXWyP7GbwRp/W0gVsm5qXYf/9OZGsBAlGxeFqCoi49qwBtRyM
PZuTjG3WcehooUWyoYQinAv+hzL74yVMCb309OC5uqEK9zh7Y4TXX0dLOLSLEQXK
WZpCSO+OnC7GpLhGNETBJA/RZnq//zIwTytaGJe5ryGhG0igoUA1tHRe580RY8Df
l9ZqtL7LupX+KusLGV+2
=069l
-----END PGP SIGNATURE-----

--Signature=_Thu__17_May_2012_13_47_36_+1000_HqM+OguHZB73IAtC--
