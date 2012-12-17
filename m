Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392Ab2LQGJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 01:09:16 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:57129 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab2LQGJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 01:09:15 -0500
MIME-Version: 1.0
In-Reply-To: <1355724270-11579-1-git-send-email-lliubbo@gmail.com>
References: <1355724270-11579-1-git-send-email-lliubbo@gmail.com>
Date: Mon, 17 Dec 2012 14:09:14 +0800
Message-ID: <CAA_GA1c1GzTFykZmuVqs3DG-fnEXpV7w=DPtrpnj05qFtbL50A@mail.gmail.com>
Subject: Re: [GIT PULL] Blackfin changes for 3.8
From: Bob Liu <lliubbo@gmail.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
        sonic.zhang@analog.com, vapier@gentoo.org, Bob Liu <lliubbo@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 2:04 PM, Bob Liu <lliubbo@gmail.com> wrote:
>
> Hi linus,
>

Fix the lkml address, sorry.

> The following changes since commit 29594404d7fe73cd80eaa4ee8c43dcc53970c60e:
>
>   Linux 3.7 (2012-12-10 19:30:57 -0800)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/lliubbo/blackfin.git for-linus
>
> for you to fetch changes up to 86794b43569c9b8936dff2e8eed503393379af6e:
>
>   blackfin: SEC: clean up SEC interrupt initialization (2012-12-14 11:20:22 +0800)
>
> ----------------------------------------------------------------
> David Howells (1):
>       UAPI: (Scripted) Disintegrate arch/blackfin/include/asm
>
> Lars-Peter Clausen (5):
>       Blackfin: Annotate strncpy_from_user src parameter with __user
>       Blackfin: Add missing __user annotations to put_user
>       Blackfin: Annotate clear_user 'to' parameter with __user
>       Blackfin: Annotate strnlen_user and strlen_user 'src' parameter with __user
>       Blackfin: twi: Add missing __iomem annotation
>
> Sonic Zhang (3):
>       blackfin: anomaly: add anomaly 16000030 for bf5xx
>       blackfin: kgdb: call generic_exec_single() directly
>       blackfin: SEC: clean up SEC interrupt initialization
>
> Srinivas Kandagatla (1):
>       Blackfin: dpmc: use module_platform_driver macro
>
> Steven Rostedt (1):
>       blackfin: Use Kbuild infrastructure for kvm_para.h
>
> Tobias Klauser (2):
>       Blackfin: remove unnecessary prototype for kobjsize()
>       Blackfin: remove unused is_in_rom()
>
>  arch/blackfin/include/asm/Kbuild                   |    6 +-
>  arch/blackfin/include/asm/bfin_sport.h             |  128 +-----
>  arch/blackfin/include/asm/bfin_twi.h               |    2 +-
>  arch/blackfin/include/asm/fixed_code.h             |   30 +-
>  arch/blackfin/include/asm/kvm_para.h               |    1 -
>  arch/blackfin/include/asm/pgtable.h                |    2 -
>  arch/blackfin/include/asm/ptrace.h                 |  161 +-------
>  arch/blackfin/include/asm/uaccess.h                |   41 +-
>  arch/blackfin/include/asm/unistd.h                 |  430 +------------------
>  arch/blackfin/include/mach-common/irq.h            |    5 +-
>  arch/blackfin/include/uapi/asm/Kbuild              |   16 +
>  arch/blackfin/include/uapi/asm/bfin_sport.h        |  136 ++++++
>  arch/blackfin/include/{ => uapi}/asm/byteorder.h   |    0
>  arch/blackfin/include/{ => uapi}/asm/cachectl.h    |    0
>  arch/blackfin/include/{ => uapi}/asm/fcntl.h       |    0
>  arch/blackfin/include/uapi/asm/fixed_code.h        |   38 ++
>  arch/blackfin/include/{ => uapi}/asm/ioctls.h      |    0
>  arch/blackfin/include/{ => uapi}/asm/poll.h        |    0
>  arch/blackfin/include/{ => uapi}/asm/posix_types.h |    0
>  arch/blackfin/include/uapi/asm/ptrace.h            |  170 ++++++++
>  arch/blackfin/include/{ => uapi}/asm/sigcontext.h  |    0
>  arch/blackfin/include/{ => uapi}/asm/siginfo.h     |    0
>  arch/blackfin/include/{ => uapi}/asm/signal.h      |    0
>  arch/blackfin/include/{ => uapi}/asm/stat.h        |    0
>  arch/blackfin/include/{ => uapi}/asm/swab.h        |    0
>  arch/blackfin/include/uapi/asm/unistd.h            |  437 ++++++++++++++++++++
>  arch/blackfin/kernel/kgdb.c                        |   13 +-
>  arch/blackfin/mach-bf518/include/mach/anomaly.h    |    1 +
>  arch/blackfin/mach-bf527/include/mach/anomaly.h    |    1 +
>  arch/blackfin/mach-bf533/include/mach/anomaly.h    |    1 +
>  arch/blackfin/mach-bf537/include/mach/anomaly.h    |    1 +
>  arch/blackfin/mach-bf538/include/mach/anomaly.h    |    1 +
>  arch/blackfin/mach-bf548/include/mach/anomaly.h    |    1 +
>  arch/blackfin/mach-bf561/include/mach/anomaly.h    |    1 +
>  arch/blackfin/mach-bf609/include/mach/irq.h        |    3 -
>  arch/blackfin/mach-bf609/pm.c                      |    3 +-
>  arch/blackfin/mach-common/dpmc.c                   |   19 +-
>  arch/blackfin/mach-common/ints-priority.c          |  272 ++++++------
>  38 files changed, 972 insertions(+), 948 deletions(-)
>  delete mode 100644 arch/blackfin/include/asm/kvm_para.h
>  create mode 100644 arch/blackfin/include/uapi/asm/bfin_sport.h
>  rename arch/blackfin/include/{ => uapi}/asm/byteorder.h (100%)
>  rename arch/blackfin/include/{ => uapi}/asm/cachectl.h (100%)
>  rename arch/blackfin/include/{ => uapi}/asm/fcntl.h (100%)
>  create mode 100644 arch/blackfin/include/uapi/asm/fixed_code.h
>  rename arch/blackfin/include/{ => uapi}/asm/ioctls.h (100%)
>  rename arch/blackfin/include/{ => uapi}/asm/poll.h (100%)
>  rename arch/blackfin/include/{ => uapi}/asm/posix_types.h (100%)
>  create mode 100644 arch/blackfin/include/uapi/asm/ptrace.h
>  rename arch/blackfin/include/{ => uapi}/asm/sigcontext.h (100%)
>  rename arch/blackfin/include/{ => uapi}/asm/siginfo.h (100%)
>  rename arch/blackfin/include/{ => uapi}/asm/signal.h (100%)
>  rename arch/blackfin/include/{ => uapi}/asm/stat.h (100%)
>  rename arch/blackfin/include/{ => uapi}/asm/swab.h (100%)
>  create mode 100644 arch/blackfin/include/uapi/asm/unistd.h
>

--
Regards,
--Bob
