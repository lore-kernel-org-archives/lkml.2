Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab2EAGIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 02:08:49 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56313 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab2EAGIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 02:08:47 -0400
Date: Tue, 1 May 2012 16:08:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: linux-next: build warning after merge of the pci tree
Message-Id: <20120501160838.0bc75873705d84625d1fb98b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__1_May_2012_16_08_38_+1000_8r4oZJLvVnx_VC8k"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_May_2012_16_08_38_+1000_8r4oZJLvVnx_VC8k
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bjorn,

After merging the pci tree, today's linux-next build (i386 defconfig)
produced this warning:

arch/x86/pci/amd_bus.c: In function 'early_fill_mp_bus_info':
arch/x86/pci/amd_bus.c:56:6: warning: unused variable 'j' [-Wunused-variabl=
e]

Introduced by commit d28e5ac2a07e ("x86/PCI: dynamically allocate
pci_root_info for native host bridge drivers").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__1_May_2012_16_08_38_+1000_8r4oZJLvVnx_VC8k
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPn33mAAoJEECxmPOUX5FEJn0P/1g101ZlYFqWOF4uPUERfeot
yO38Mwb4+0MX4EEUgqgnoFLHVhUxJq3NUQlAENzi6q9XHUHpOyvXSc8qebPZx0li
dIyTowdFKuGv87MSA6/XuX/Qz6TjR3f1zZwOqOoe5lrHYyRa9jMc0wnNx3jTQ4EQ
+vxuOBe0VMBZASoP9eByIUS1GNg7e1HGJ7cMbqj106FLnuz0/YIxd81jisSHkfL7
u5XdTYdyrTEE3E4fiig1JD61yB5U7sQif4H3wegVnTNIHfUhzRnBGcR+aRJC7YEn
jEizgvrjagdWnwHiqF179oKm1Igk87vXgxv0DT2MFjhC22LQ8vWiR8hRPV/JH/qB
AKhyDKgzu8edPIuFvD2zb+ydCoJWF0X4bDrDSvEFWCjWbtNeoeGp8EQ6WdLwKHLf
q6T5Tms4RL8dGofUEG0gGxzeLXkpuIfJonTFqGOYGDHt+DKwWGzls9XE4adaAzfk
9NEJrRXhKMtieXPGbi3XUqKzgWfS8XX92F+NrLwRdYiHUu9Wh7QW/CC33Dbh3S9z
38h2dpMBXqw+jlFPkeZuyV8YtZBiNDotUAc+HBUEw0TiM3WRnUYOQxg6MfOv5/Vo
DcNrVQfM0I0bzJvc5Ku6866V5Vg7tr8Rd3/uePzrjASYVpncFZH6SgXuZmmIYeFS
5Dj9gyyg+6TTbIsrV0n3
=9lcs
-----END PGP SIGNATURE-----

--Signature=_Tue__1_May_2012_16_08_38_+1000_8r4oZJLvVnx_VC8k--
