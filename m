Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667Ab3AJCer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 21:34:47 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:51864 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153Ab3AJCeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 21:34:46 -0500
Date: Thu, 10 Jan 2013 13:34:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>
Subject: linux-next: build warning after merge of the kvm tree
Message-Id: <20130110133436.0feaf348b74cb89fdfb0bc78@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__10_Jan_2013_13_34_36_+1100_V5oRYpoSIxJlI5Se"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__10_Jan_2013_13_34_36_+1100_V5oRYpoSIxJlI5Se
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Marcelo,

After merging the kvm tree, today's linux-next build (x86_64 allmodconfig)
produced this warning:

In file included from arch/x86/kvm/mmu.c:3482:0:
arch/x86/kvm/paging_tmpl.h: In function 'paging64_walk_addr_generic':
arch/x86/kvm/paging_tmpl.h:154:57: warning: unused variable 'shift' [-Wunus=
ed-variable]
In file included from arch/x86/kvm/mmu.c:3486:0:
arch/x86/kvm/paging_tmpl.h: In function 'paging32_walk_addr_generic':
arch/x86/kvm/paging_tmpl.h:154:57: warning: unused variable 'shift' [-Wunus=
ed-variable]

Introduced by commit 908e7d7999bc ("KVM: MMU: simplify folding of dirty
bit into accessed_dirty").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__10_Jan_2013_13_34_36_+1100_V5oRYpoSIxJlI5Se
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ7ii8AAoJEECxmPOUX5FEBRMP/A2al7NWaOl6pAoD5HuYetpH
tWDPBmeUQy0Iwtystc+wTi+e3wwwY6I37SRevJlOXY3XdH2ytKy8RFpnmg/61xCL
obJF48c8joetTyvPXlZ6WjiAWyoPZd0g8ikjV70TdthWXQ5sMXSMkM6QWvlB7nA8
pkqgGMHhcNhEjOBkl8N7ItNVgTiVCcGgetUIGRuPip9hwfe+ZZPgOm2POIhusviM
SXg8xdWDwaJIRKncp4O7vTxXh/xPxPJXGndYg8IT0Jy9U59jI2ArPdSnlqXncXsr
//UYv/IhMUUqQmLsdeh172fnnVDfawoGu2wowVUyzoeNzS0IeyGMhm5Ym3kdyVFH
N19fbY21jb9w86t2QjvKcbdSUyoGlHUvSH1nReUdG7RWLvj7ELWd3nk5FTNGKu3H
gdQw2SMXJtSI7QayBLVP+SULA6xVXCuKWVEUujCmKu1xMbA97GqQkhXpngANBbZD
747vA6PsRDKBhzyppZj5JQutsD4GiFZNGz7zFKF+ldOd2Dfsswb58waexxDKSAkp
zueEOq6YNUm8fNHKcczI1W4HLtzccpNKJozvV6tTIo3GdLP86nJmaE+5Pooze5E9
pOpcXajjLukHdPlso+hDQOAxSaeb7HZbg6hm2ahGVmRnz1y7/RGQ4SLAAW/tAl83
/9UlfoFSNHDmoT5oH9+O
=Micv
-----END PGP SIGNATURE-----

--Signature=_Thu__10_Jan_2013_13_34_36_+1100_V5oRYpoSIxJlI5Se--
