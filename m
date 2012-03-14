Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab2CNEOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 00:14:54 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50688 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab2CNEOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 00:14:53 -0400
Date: Wed, 14 Mar 2012 15:14:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the uprobes tree with the tip tree
Message-Id: <20120314151444.a34eef495739e13506ac5b1a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__14_Mar_2012_15_14_44_+1100_ZivQB+cPZ3KTEjIn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__14_Mar_2012_15_14_44_+1100_ZivQB+cPZ3KTEjIn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Srikar,

The linux-next merge of the uprobes tree gets several conflicts against
the tip tree because the same patches appear in both threes and there are
further changes to some files in the uprobes tree.

Merging uprobes/for-next (1fe509b uprobes/core: Handle breakpoint and singl=
estep exception.)
CONFLICT (add/add): Merge conflict in kernel/events/uprobes.c
CONFLICT (content): Merge conflict in kernel/events/Makefile
CONFLICT (add/add): Merge conflict in include/linux/uprobes.h
CONFLICT (add/add): Merge conflict in arch/x86/kernel/uprobes.c
CONFLICT (add/add): Merge conflict in arch/x86/include/asm/uprobes.h

The easiest way to remove these conflicts would be for you to rebase the
uprobes tree onto the perl/uprobes branch of the tip tree (I assume that
all the uprobes code will eventually be merged to Linus via the tip tree)
or a subset of that branch that is the common set of patches.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__14_Mar_2012_15_14_44_+1100_ZivQB+cPZ3KTEjIn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPYBs0AAoJEECxmPOUX5FEbvUP/2K2TCk6qeWTfjtvmne+DVUp
Teab0R8Ja0riHD5k2BIN8gUlootSIywV5Fy6ekvmZaF+3EtZaLGlMg1o51Tm3oiX
RaBqfdmeATE9/H/Mxj4ZdMudwzHmc8Iruz/plIPh2BRtIb3auUtDtBtRvjGCyiZe
ZoBephATvL6n+TRy8h24Qex/7macgkN/QFoImLe29gZ32xBXEISc7mw14Rx+YWy/
IF6ddXLGjIuXWvAAgn2drGsDqm7Ugo4IDsSXfPmh7nwbav2Urhp/j25Ps3E0cgn7
fffUceT1QTzeJoQVTua5xUi1brhiW7aNdXV7vGDEOAiM615654CiL87SUBZvZWmJ
Pdv//sOl+g3o4KJObOWoBqauyPi3YF+/pBidgX+TIxWzuFST7zDLYre74aFvGk4r
vSt9eGYq+lUAwZDHWLu5Ma4y1GpMgNISGQ7t7ah8vh5Bt33V9HwwwSAjh0c0tagD
jw90YFz0kV1MQhLxW13OhUnJnpOaRUsuDWesr+/iK3JBzigAn+Adq5SrGDAnwgZJ
dfl3xUx27QuH9e6w+UmdIEsNv6vhvSWHEm65wbzAzwYkAVTbWroOr0rhxu7RZlfk
fl5ao7eOu6uCSCX+PZ0u1Nybg7F0KC8wCD4xIIXwK+UeWFnI668f2Tfta/Ys4G9L
ywcb5lsVk8jvPA5020vW
=SuYb
-----END PGP SIGNATURE-----

--Signature=_Wed__14_Mar_2012_15_14_44_+1100_ZivQB+cPZ3KTEjIn--
