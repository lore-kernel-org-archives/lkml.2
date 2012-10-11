Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253Ab2JKJqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 05:46:23 -0400
Received: from mail.southpole.se ([193.12.106.18]:44588 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159Ab2JKJqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 05:46:20 -0400
Message-ID: <1349948752.23394.55.camel@satguru>
Subject: [GIT PULL] OpenRISC updates for 3.7
From: Jonas Bonn <jonas@southpole.se>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Date: Thu, 11 Oct 2012 11:45:52 +0200
Organization: South Pole Consulting AB
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-a3JHFrhlwnwIcFqp0jIB"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Mime-Version: 1.0
X-Assp-Version: 2.2.1(12265) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-Server-TLS: yes
X-Assp-ID: assp.southpole.se 48775-01991
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-a3JHFrhlwnwIcFqp0jIB
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Here are some OpenRISC updates for 3.7.  These have been in linux-next
(for-upstream branch) for a while; the signed tag is on the
for-upstream-fixed branch where the only difference is the fact that I
missed a sign-off on one of the commits and corrected that here.

Thanks,
Jonas

-----

The following changes since commit
fea7a08acb13524b47711625eebea40a0ede69a0:

  Linux 3.6-rc3 (2012-08-22 13:29:06 -0700)

are available in the git repository at:

  git://openrisc.net/jonas/linux.git tags/for-3.7

for you to fetch changes up to d23b5799b608112bb799c9b0e1e11ee1da692d76:

  openrisc: mask interrupts in irq_mask_ack function (2012-10-11
11:27:26 +0200)

----------------------------------------------------------------
OpenRISC updates for 3.7

Fixups for some corner cases, build issues, and some obvious bugs in
IRQ handling.  No major changes.

----------------------------------------------------------------
Gong Tao (1):
      openrisc: mask interrupts in irq_mask_ack function

Jonas Bonn (2):
      openrisc: PIC should act on domain-local irqs
      openrisc: fix typos in comments and warnings

Kees Cook (1):
      audit: define AUDIT_ARCH_OPENRISC

Vladimir Murzin (1):
      openrisc: Make cpu_relax() invoke barrier()

Will Deacon (2):
      openrisc: delay: fix loops calculation for __const_udelay
      openrisc: delay: fix handling of counter overflow

 arch/openrisc/include/asm/processor.h |    2 +-
 arch/openrisc/kernel/irq.c            |   20 +++++++++++---------
 arch/openrisc/kernel/ptrace.c         |    2 +-
 arch/openrisc/lib/delay.c             |    6 +++---
 include/linux/audit.h                 |    1 +
 5 files changed, 17 insertions(+), 14 deletions(-)


--=-a3JHFrhlwnwIcFqp0jIB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlB2lVAACgkQ70gcjN2673Om4ACgsc75w+wYcdbgFDTL9MxixZAk
/qwAoImcGNPvyTM4TUnur7SWFfkMj1Ar
=xjCk
-----END PGP SIGNATURE-----

--=-a3JHFrhlwnwIcFqp0jIB--

