Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933126Ab2KBJgc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 05:36:32 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:32993 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932666Ab2KBJga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 05:36:30 -0400
To: torvalds@linux-foundation.org
Subject: [GIT PULL REQUEST] UniCore32 update for v3.7-rc3
Cc: linux-kernel@vger.kernel.org
Message-Id: <20121102093200.8961C1460DAB@linuxdev-32>
Date: Fri,  2 Nov 2012 17:32:00 +0800 (CST)
From: guanxuetao@mprc.pku.edu.cn (guanxuetao)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

The following changes since commit 8c23f406c6d86808726ace580657186bc3b44587:
  Linus Torvalds (1):
        Merge git://git.kernel.org/pub/scm/virt/kvm/kvm

are available in the git repository at:

  git://github.com/gxt/linux.git unicore32

Al Viro (2):
      unicore32: switch to generic kernel_thread()/kernel_execve()
      unicore32: switch to generic sys_execve()

David Howells (1):
      UAPI: (Scripted) Disintegrate arch/unicore32/include/asm

Guan Xuetao (4):
      UniCore32 bugfix: add missed CONFIG_ZONE_DMA
      UniCore32-bugfix: fix mismatch return value of __xchg_bad_pointer
      UniCore32-bugfix: Remove definitions in asm/bug.h to solve difference between native and cross compiler
      unicore32: Use Kbuild infrastructure for kvm_para.h

Kautuk Consul (1):
      unicore32/mm/fault.c: Port OOM changes to do_pf

Kees Cook (1):
      arch/unicore32: remove CONFIG_EXPERIMENTAL

 arch/unicore32/Kconfig                             |    7 ++-
 arch/unicore32/include/asm/Kbuild                  |    1 -
 arch/unicore32/include/asm/bug.h                   |    5 -
 arch/unicore32/include/asm/cmpxchg.h               |    2 +-
 arch/unicore32/include/asm/kvm_para.h              |    1 -
 arch/unicore32/include/asm/processor.h             |    5 -
 arch/unicore32/include/asm/ptrace.h                |   76 +----------------
 arch/unicore32/include/uapi/asm/Kbuild             |    7 ++
 arch/unicore32/include/{ => uapi}/asm/byteorder.h  |    0
 arch/unicore32/include/uapi/asm/ptrace.h           |   90 ++++++++++++++++++++
 arch/unicore32/include/{ => uapi}/asm/sigcontext.h |    0
 arch/unicore32/include/{ => uapi}/asm/unistd.h     |    1 +
 arch/unicore32/kernel/entry.S                      |   20 ++---
 arch/unicore32/kernel/process.c                    |   58 +++----------
 arch/unicore32/kernel/setup.h                      |    6 ++
 arch/unicore32/kernel/sys.c                        |   63 --------------
 arch/unicore32/mm/fault.c                          |   37 ++++++--
 17 files changed, 160 insertions(+), 219 deletions(-)
 delete mode 100644 arch/unicore32/include/asm/kvm_para.h
 rename arch/unicore32/include/{ => uapi}/asm/byteorder.h (100%)
 create mode 100644 arch/unicore32/include/uapi/asm/ptrace.h
 rename arch/unicore32/include/{ => uapi}/asm/sigcontext.h (100%)
 rename arch/unicore32/include/{ => uapi}/asm/unistd.h (92%)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJQk5LlAAoJENFylnOm3dTbo1EP/1n+OguOJgzt9Xo3B8Y9ZO0I
abbA44rYzCutWrrXbnwh6/Yb84w+L8VN5Wts+OW4L6P5f751SPkDxWTMS3ObpP8X
h3YxW0qVfItGKeJv2jv390TrFUmgS+bXRc26NIUr7iwi1y8DMJ7X6tiLH9agRu2r
c/e5+IC0zmtRfhKlFYdEHY8KD+Eee4gKAg8ZsB+SMql9xqx3mh/FCxE2fTshvA6v
djx0gLohUanBJWeyIc8lFZyLP5uvbfaSVfn5Qf3T43i+2uGMnX34PhZaWj3UNG8c
yvl5x0DnC2bx96Vg8iuJLIZAgi0mqqZcGMH5YDBnKzjHCEJFvEvLL2udqp/5/f6Q
27AxC9krOiXfx6DWhyPw3mRp38IhR8nApCo8dNXES+ePjZiRiDHSRqY3ZIo+QbzN
b7prxiHKYP9OLewXbNVRGQvKSy8hNGhyL+hCXUIR/azfZ8dBm6eni2cdIO11pHPm
dYqvT4UrU5R3zP4Nq4ZIPMV88vjknCJp5l5cTZol7j7niOEvaSuU5TYezUF2FA/I
RI2ZEsDzltKR+o7G6hYd+swlQCs/R7o3pYYwWEe7/YZp88lA3+0fj3V1wdmwaeuP
/ZKNWoiMV7ZINCkwaFCtJRhC0pCvh4lndw83SPzFKrNyKDgTH3ANH3g7q2wLZ0ha
4sevLKaEHJJPI00wSXiS
=pUws
-----END PGP SIGNATURE-----
