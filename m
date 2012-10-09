Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab2JIJpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 05:45:36 -0400
Received: from cassarossa.samfundet.no ([129.241.93.19]:53880 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab2JIJpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 05:45:34 -0400
X-Greylist: delayed 1494 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Oct 2012 05:45:34 EDT
Date: Tue, 9 Oct 2012 11:20:36 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: David Howells <dhowells@redhat.com>
Cc: hskinnemoen@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Disintegrate UAPI for avr32 [ver #2]
Message-ID: <20121009092036.GB22203@samfundet.no>
References: <21113.1349774115@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21113.1349774115@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Tue 09 Oct 2012 10:15:15 +0100 or thereabout, David Howells wrote:
> Can you merge the following branch into the avr32 tree please.
> 

Neither Haavard or me have a GIT tree at kernel.org anymore, I hope to get my
key signed in Barcelona during ELCE. Could you ask Linus to pull directly, or
pass it through Andrew.

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
>   git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-avr32-20121009
> 
> for you to fetch changes up to b9ba6b52cfb7f564c205bc42fed3297d623fc50f:
> 
>   UAPI: (Scripted) Disintegrate arch/avr32/include/asm (2012-10-09 09:46:37 +0100)
> 
> ----------------------------------------------------------------
> UAPI Disintegration 2012-10-09
> 
> ----------------------------------------------------------------
> David Howells (1):
>       UAPI: (Scripted) Disintegrate arch/avr32/include/asm
> 
>  arch/avr32/include/asm/Kbuild                   |   3 -
>  arch/avr32/include/asm/param.h                  |  18 +-
>  arch/avr32/include/asm/ptrace.h                 | 115 +--------
>  arch/avr32/include/asm/setup.h                  |   5 +-
>  arch/avr32/include/asm/signal.h                 | 121 +---------
>  arch/avr32/include/asm/termios.h                |  41 +---
>  arch/avr32/include/asm/types.h                  |   6 +-
>  arch/avr32/include/asm/unistd.h                 | 296 +----------------------
>  arch/avr32/include/uapi/asm/Kbuild              |  32 +++
>  arch/avr32/include/{ => uapi}/asm/auxvec.h      |   0
>  arch/avr32/include/{ => uapi}/asm/bitsperlong.h |   0
>  arch/avr32/include/{ => uapi}/asm/byteorder.h   |   0
>  arch/avr32/include/{ => uapi}/asm/cachectl.h    |   0
>  arch/avr32/include/{ => uapi}/asm/errno.h       |   0
>  arch/avr32/include/{ => uapi}/asm/fcntl.h       |   0
>  arch/avr32/include/{ => uapi}/asm/ioctl.h       |   0
>  arch/avr32/include/{ => uapi}/asm/ioctls.h      |   0
>  arch/avr32/include/{ => uapi}/asm/ipcbuf.h      |   0
>  arch/avr32/include/{ => uapi}/asm/kvm_para.h    |   0
>  arch/avr32/include/{ => uapi}/asm/mman.h        |   0
>  arch/avr32/include/{ => uapi}/asm/msgbuf.h      |   0
>  arch/avr32/include/uapi/asm/param.h             |  18 ++
>  arch/avr32/include/{ => uapi}/asm/poll.h        |   0
>  arch/avr32/include/{ => uapi}/asm/posix_types.h |   0
>  arch/avr32/include/uapi/asm/ptrace.h            | 126 ++++++++++
>  arch/avr32/include/{ => uapi}/asm/resource.h    |   0
>  arch/avr32/include/{ => uapi}/asm/sembuf.h      |   0
>  arch/avr32/include/uapi/asm/setup.h             |  17 ++
>  arch/avr32/include/{ => uapi}/asm/shmbuf.h      |   0
>  arch/avr32/include/{ => uapi}/asm/sigcontext.h  |   0
>  arch/avr32/include/{ => uapi}/asm/siginfo.h     |   0
>  arch/avr32/include/uapi/asm/signal.h            | 128 ++++++++++
>  arch/avr32/include/{ => uapi}/asm/socket.h      |   0
>  arch/avr32/include/{ => uapi}/asm/sockios.h     |   0
>  arch/avr32/include/{ => uapi}/asm/stat.h        |   0
>  arch/avr32/include/{ => uapi}/asm/statfs.h      |   0
>  arch/avr32/include/{ => uapi}/asm/swab.h        |   0
>  arch/avr32/include/{ => uapi}/asm/termbits.h    |   0
>  arch/avr32/include/uapi/asm/termios.h           |  50 ++++
>  arch/avr32/include/uapi/asm/types.h             |   8 +
>  arch/avr32/include/uapi/asm/unistd.h            | 305 ++++++++++++++++++++++++
>  41 files changed, 692 insertions(+), 597 deletions(-)
>  rename arch/avr32/include/{ => uapi}/asm/auxvec.h (100%)
>  rename arch/avr32/include/{ => uapi}/asm/bitsperlong.h (100%)
>  rename arch/avr32/include/{ => uapi}/asm/byteorder.h (100%)
>  rename arch/avr32/include/{ => uapi}/asm/cachectl.h (100%)
>  rename arch/avr32/include/{ => uapi}/asm/errno.h (100%)
>  rename arch/avr32/include/{ => uapi}/asm/fcntl.h (100%)
>  rename arch/avr32/include/{ => uapi}/asm/ioctl.h (100%)
>  rename arch/avr32/include/{ => uapi}/asm/ioctls.h (100%)
>  rename arch/avr32/include/{ => uapi}/asm/ipcbuf.h (100%)
>  rename arch/avr32/include/{ => uapi}/asm/kvm_para.h (100%)
>  rename arch/avr32/include/{ => uapi}/asm/mman.h (100%)
>  rename arch/avr32/include/{ => uapi}/asm/msgbuf.h (100%)
>  create mode 100644 arch/avr32/include/uapi/asm/param.h
>  rename arch/avr32/include/{ => uapi}/asm/poll.h (100%)
>  rename arch/avr32/include/{ => uapi}/asm/posix_types.h (100%)
>  create mode 100644 arch/avr32/include/uapi/asm/ptrace.h
>  rename arch/avr32/include/{ => uapi}/asm/resource.h (100%)
>  rename arch/avr32/include/{ => uapi}/asm/sembuf.h (100%)
>  create mode 100644 arch/avr32/include/uapi/asm/setup.h
>  rename arch/avr32/include/{ => uapi}/asm/shmbuf.h (100%)
>  rename arch/avr32/include/{ => uapi}/asm/sigcontext.h (100%)
>  rename arch/avr32/include/{ => uapi}/asm/siginfo.h (100%)
>  create mode 100644 arch/avr32/include/uapi/asm/signal.h
>  rename arch/avr32/include/{ => uapi}/asm/socket.h (100%)
>  rename arch/avr32/include/{ => uapi}/asm/sockios.h (100%)
>  rename arch/avr32/include/{ => uapi}/asm/stat.h (100%)
>  rename arch/avr32/include/{ => uapi}/asm/statfs.h (100%)
>  rename arch/avr32/include/{ => uapi}/asm/swab.h (100%)
>  rename arch/avr32/include/{ => uapi}/asm/termbits.h (100%)
>  create mode 100644 arch/avr32/include/uapi/asm/termios.h
>  create mode 100644 arch/avr32/include/uapi/asm/types.h
>  create mode 100644 arch/avr32/include/uapi/asm/unistd.h
> .
> 

-- 
mvh
Hans-Christian Egtvedt
