Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab2JIKPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 06:15:25 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:53660 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab2JIKPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 06:15:23 -0400
MIME-Version: 1.0
In-Reply-To: <21116.1349774117@warthog.procyon.org.uk>
References: <21116.1349774117@warthog.procyon.org.uk>
Date: Tue, 9 Oct 2012 18:15:22 +0800
Message-ID: <CAA_GA1ck9vs4aeUCY-+J=nv_R7KHLFrcSUqK0t122exk80p1ew@mail.gmail.com>
Subject: Re: [uclinux-dist-devel] [GIT PULL] Disintegrate UAPI for blackfin
 [ver #2]
From: Bob Liu <lliubbo@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: vapier@gentoo.org, uclinux-dist-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 9, 2012 at 5:15 PM, David Howells <dhowells@redhat.com> wrote:
> Can you merge the following branch into the blackfin tree please.
>

Merged into my git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/lliubbo/blackfin.git for-linus

And what time i need to ask linus to pull? Next merge window?

> This is to complete part of the UAPI disintegration for which the preparatory
> patches were pulled recently.
>
> Now that the fixups and the asm-generic chunk have been merged, I've
> regenerated the patches to get rid of those dependencies and to take account of
> any changes made so far in the merge window.  If you have already pulled the
> older version of the branch aimed at you, then please feel free to ignore this
> request.
>
> The following changes since commit 9e2d8656f5e8aa214e66b462680cf86b210b74a8:
>
>   Merge branch 'akpm' (Andrew's patch-bomb) (2012-10-09 16:23:15 +0900)
>
> are available in the git repository at:
>
>
>   git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-blackfin-20121009
>
> for you to fetch changes up to ac3a050e89f2e6b8025e4176a36ed34de470fcad:
>
>   UAPI: (Scripted) Disintegrate arch/blackfin/include/asm (2012-10-09 09:46:39 +0100)
>
> ----------------------------------------------------------------
> UAPI Disintegration 2012-10-09
>
> ----------------------------------------------------------------
> David Howells (1):
>       UAPI: (Scripted) Disintegrate arch/blackfin/include/asm
>
>  arch/blackfin/include/asm/Kbuild                   |   5 -
>  arch/blackfin/include/asm/bfin_sport.h             | 128 +-----
>  arch/blackfin/include/asm/fixed_code.h             |  30 +-
>  arch/blackfin/include/asm/ptrace.h                 | 161 +-------
>  arch/blackfin/include/asm/unistd.h                 | 430 +-------------------
>  arch/blackfin/include/uapi/asm/Kbuild              |  16 +
>  arch/blackfin/include/uapi/asm/bfin_sport.h        | 136 +++++++
>  arch/blackfin/include/{ => uapi}/asm/byteorder.h   |   0
>  arch/blackfin/include/{ => uapi}/asm/cachectl.h    |   0
>  arch/blackfin/include/{ => uapi}/asm/fcntl.h       |   0
>  arch/blackfin/include/uapi/asm/fixed_code.h        |  38 ++
>  arch/blackfin/include/{ => uapi}/asm/ioctls.h      |   0
>  arch/blackfin/include/{ => uapi}/asm/kvm_para.h    |   0
>  arch/blackfin/include/{ => uapi}/asm/poll.h        |   0
>  arch/blackfin/include/{ => uapi}/asm/posix_types.h |   0
>  arch/blackfin/include/uapi/asm/ptrace.h            | 170 ++++++++
>  arch/blackfin/include/{ => uapi}/asm/sigcontext.h  |   0
>  arch/blackfin/include/{ => uapi}/asm/siginfo.h     |   0
>  arch/blackfin/include/{ => uapi}/asm/signal.h      |   0
>  arch/blackfin/include/{ => uapi}/asm/stat.h        |   0
>  arch/blackfin/include/{ => uapi}/asm/swab.h        |   0
>  arch/blackfin/include/uapi/asm/unistd.h            | 437 +++++++++++++++++++++
>  22 files changed, 802 insertions(+), 749 deletions(-)
>  create mode 100644 arch/blackfin/include/uapi/asm/bfin_sport.h
>  rename arch/blackfin/include/{ => uapi}/asm/byteorder.h (100%)
>  rename arch/blackfin/include/{ => uapi}/asm/cachectl.h (100%)
>  rename arch/blackfin/include/{ => uapi}/asm/fcntl.h (100%)
>  create mode 100644 arch/blackfin/include/uapi/asm/fixed_code.h
>  rename arch/blackfin/include/{ => uapi}/asm/ioctls.h (100%)
>  rename arch/blackfin/include/{ => uapi}/asm/kvm_para.h (100%)
>  rename arch/blackfin/include/{ => uapi}/asm/poll.h (100%)
>  rename arch/blackfin/include/{ => uapi}/asm/posix_types.h (100%)
>  create mode 100644 arch/blackfin/include/uapi/asm/ptrace.h
>  rename arch/blackfin/include/{ => uapi}/asm/sigcontext.h (100%)
>  rename arch/blackfin/include/{ => uapi}/asm/siginfo.h (100%)
>  rename arch/blackfin/include/{ => uapi}/asm/signal.h (100%)
>  rename arch/blackfin/include/{ => uapi}/asm/stat.h (100%)
>  rename arch/blackfin/include/{ => uapi}/asm/swab.h (100%)
>  create mode 100644 arch/blackfin/include/uapi/asm/unistd.h
> .
> _______________________________________________
> Uclinux-dist-devel mailing list
> Uclinux-dist-devel@blackfin.uclinux.org
> https://blackfin.uclinux.org/mailman/listinfo/uclinux-dist-devel

-- 
Regards,
--Bob
