Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab2KIEQq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 23:16:46 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:38394 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab2KIEQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 23:16:45 -0500
Date: Fri, 9 Nov 2012 15:16:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: linux-next: build failure after merge of the final tree (akpm tree
 related)
Message-Id: <20121109151642.893f699e4df8063e41dec666@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__9_Nov_2012_15_16_42_+1100_NXnVM_zrwFlIWiOz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Nov_2012_15_16_42_+1100_NXnVM_zrwFlIWiOz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc32 defconfig)
failed like this:

arch/sparc/kernel/sys_sparc_32.c: In function 'arch_get_unmapped_area':
arch/sparc/kernel/sys_sparc_32.c:41:26: error: unused variable 'vmm' [-Werr=
or=3Dunused-variable]

Caused by commit "mm: use vm_unmapped_area() on sparc32 architecture".

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__9_Nov_2012_15_16_42_+1100_NXnVM_zrwFlIWiOz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQnIOqAAoJEECxmPOUX5FEZZoP/2sLJglXpXJ5hIMWY+5OaG0k
js3zH4MzIeXAt4s6NO5Gr1xE7ninUrD69te6OrprJjIQSRs2f7MhH0TlyhvsO65R
rbgaBhnCvc60eGbtEzm4lve/Ul8ITnKN5dgiPSyBWsr53IUAKrV3RZDgTGc98o4A
2Effm6d5wrOEA63GjA9YL3UBJhNJKTXaL7Rb9tCgYqDn2/DQfrmaNYISn5sS6hwh
FODKiKwMqVAkMKyHPzYep0IHCo3R6vBUEytuixv4HWMcIrS3wxt0J9BxmjnoXyzG
dUDPZw2KPEqs+LbaAM42fg5UK1xoAbEU7LykyzKShff2FDsodbOm5+cLQko4+lyr
0TVTzEQz1MT7ISfmypN+xrIii3w2Nz4BrlljCFXCsNQp1ThdFGlnJTjEneJdwAxf
9Dst5tbA9tP4kwrd/wNZUQe4G7/8Zlf5/bylJjHKzBVwJSSoVLJUyBRtLua2En5F
KOqOKeU/MMAdeFYX4Rlw89n+bUgc5iUpidWkTy1GgdQpZzltuFhBigOm7jtIOPhc
TJugJq9u3kSMeo7qayMpa+pbyu0o5W/9qTjWudLd5R3COdrZ1auvQiRBbdojte6P
RoVz5gwrQdEHAoDl2NdG4louv4aro6ulNAeBxNj8rCis34Q5k7VetRphJqIIN/mq
KR18HVGrzQ54ijOOTcRp
=3CdG
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Nov_2012_15_16_42_+1100_NXnVM_zrwFlIWiOz--
