Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297Ab2JLHAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 03:00:20 -0400
Received: from anubis.se.axis.com ([195.60.68.12]:60731 "EHLO
	anubis.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab2JLHAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 03:00:16 -0400
Date: Fri, 12 Oct 2012 09:00:13 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: David Howells <dhowells@redhat.com>
Cc: starvik@axis.com, linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Disintegrate UAPI for cris [ver #2]
Message-ID: <20121012070012.GF24942@axis.com>
References: <21122.1349774122@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21122.1349774122@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 10:15:22AM +0100, David Howells wrote:
> Can you merge the following branch into the cris tree please.
> 
> This is to complete part of the UAPI disintegration for which the preparatory
> patches were pulled recently.
> 
> Now that the fixups and the asm-generic chunk have been merged, I've
> regenerated the patches to get rid of those dependencies and to take account of
> any changes made so far in the merge window.

Looks good here, applied.

Thanks!

/Jesper

>   If you have already pulled the
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
>   git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-cris-20121009
> 
> for you to fetch changes up to e717abac8a9f65eee6de3bb37e10c6916bced483:
> 
>   UAPI: (Scripted) Disintegrate arch/cris/include/asm (2012-10-09 09:46:45 +0100)
> 
> ----------------------------------------------------------------
> UAPI Disintegration 2012-10-09
> 
> ----------------------------------------------------------------
> David Howells (3):
>       UAPI: (Scripted) Disintegrate arch/cris/include/arch-v10/arch
>       UAPI: (Scripted) Disintegrate arch/cris/include/arch-v32/arch
>       UAPI: (Scripted) Disintegrate arch/cris/include/asm
> 
>  arch/cris/include/arch-v10/arch/Kbuild             |   4 -
>  arch/cris/include/arch-v32/arch/Kbuild             |   2 -
>  arch/cris/include/arch-v32/arch/cryptocop.h        | 116 +------
>  arch/cris/include/asm/Kbuild                       |   5 -
>  arch/cris/include/asm/ptrace.h                     |   5 +-
>  arch/cris/include/asm/signal.h                     | 122 +-------
>  arch/cris/include/asm/swab.h                       |   3 +-
>  arch/cris/include/asm/termios.h                    |  43 +--
>  arch/cris/include/asm/types.h                      |   5 +-
>  arch/cris/include/asm/unistd.h                     | 342 +-------------------
>  arch/cris/include/uapi/arch-v10/arch/Kbuild        |   4 +
>  .../include/{ => uapi}/arch-v10/arch/sv_addr.agh   |   0
>  .../include/{ => uapi}/arch-v10/arch/sv_addr_ag.h  |   0
>  .../cris/include/{ => uapi}/arch-v10/arch/svinto.h |   0
>  arch/cris/include/{ => uapi}/arch-v10/arch/user.h  |   0
>  arch/cris/include/uapi/arch-v32/arch/Kbuild        |   2 +
>  arch/cris/include/uapi/arch-v32/arch/cryptocop.h   | 122 ++++++++
>  arch/cris/include/{ => uapi}/arch-v32/arch/user.h  |   0
>  arch/cris/include/uapi/asm/Kbuild                  |  34 ++
>  arch/cris/include/{ => uapi}/asm/auxvec.h          |   0
>  arch/cris/include/{ => uapi}/asm/bitsperlong.h     |   0
>  arch/cris/include/{ => uapi}/asm/byteorder.h       |   0
>  arch/cris/include/{ => uapi}/asm/errno.h           |   0
>  arch/cris/include/{ => uapi}/asm/ethernet.h        |   0
>  arch/cris/include/{ => uapi}/asm/etraxgpio.h       |   0
>  arch/cris/include/{ => uapi}/asm/fcntl.h           |   0
>  arch/cris/include/{ => uapi}/asm/ioctl.h           |   0
>  arch/cris/include/{ => uapi}/asm/ioctls.h          |   0
>  arch/cris/include/{ => uapi}/asm/ipcbuf.h          |   0
>  arch/cris/include/{ => uapi}/asm/mman.h            |   0
>  arch/cris/include/{ => uapi}/asm/msgbuf.h          |   0
>  arch/cris/include/{ => uapi}/asm/param.h           |   0
>  arch/cris/include/{ => uapi}/asm/poll.h            |   0
>  arch/cris/include/{ => uapi}/asm/posix_types.h     |   0
>  arch/cris/include/uapi/asm/ptrace.h                |   1 +
>  arch/cris/include/{ => uapi}/asm/resource.h        |   0
>  arch/cris/include/{ => uapi}/asm/rs485.h           |   0
>  arch/cris/include/{ => uapi}/asm/sembuf.h          |   0
>  arch/cris/include/{ => uapi}/asm/setup.h           |   0
>  arch/cris/include/{ => uapi}/asm/shmbuf.h          |   0
>  arch/cris/include/{ => uapi}/asm/sigcontext.h      |   0
>  arch/cris/include/{ => uapi}/asm/siginfo.h         |   0
>  arch/cris/include/uapi/asm/signal.h                | 122 ++++++++
>  arch/cris/include/{ => uapi}/asm/socket.h          |   0
>  arch/cris/include/{ => uapi}/asm/sockios.h         |   0
>  arch/cris/include/{ => uapi}/asm/stat.h            |   0
>  arch/cris/include/{ => uapi}/asm/statfs.h          |   0
>  arch/cris/include/{ => uapi}/asm/sync_serial.h     |   0
>  arch/cris/include/{ => uapi}/asm/termbits.h        |   0
>  arch/cris/include/uapi/asm/termios.h               |  45 +++
>  arch/cris/include/uapi/asm/types.h                 |   1 +
>  arch/cris/include/uapi/asm/unistd.h                | 344 +++++++++++++++++++++
>  52 files changed, 682 insertions(+), 640 deletions(-)
>  rename arch/cris/include/{ => uapi}/arch-v10/arch/sv_addr.agh (100%)
>  rename arch/cris/include/{ => uapi}/arch-v10/arch/sv_addr_ag.h (100%)
>  rename arch/cris/include/{ => uapi}/arch-v10/arch/svinto.h (100%)
>  rename arch/cris/include/{ => uapi}/arch-v10/arch/user.h (100%)
>  create mode 100644 arch/cris/include/uapi/arch-v32/arch/cryptocop.h
>  rename arch/cris/include/{ => uapi}/arch-v32/arch/user.h (100%)
>  rename arch/cris/include/{ => uapi}/asm/auxvec.h (100%)
>  rename arch/cris/include/{ => uapi}/asm/bitsperlong.h (100%)
>  rename arch/cris/include/{ => uapi}/asm/byteorder.h (100%)
>  rename arch/cris/include/{ => uapi}/asm/errno.h (100%)
>  rename arch/cris/include/{ => uapi}/asm/ethernet.h (100%)
>  rename arch/cris/include/{ => uapi}/asm/etraxgpio.h (100%)
>  rename arch/cris/include/{ => uapi}/asm/fcntl.h (100%)
>  rename arch/cris/include/{ => uapi}/asm/ioctl.h (100%)
>  rename arch/cris/include/{ => uapi}/asm/ioctls.h (100%)
>  rename arch/cris/include/{ => uapi}/asm/ipcbuf.h (100%)
>  rename arch/cris/include/{ => uapi}/asm/mman.h (100%)
>  rename arch/cris/include/{ => uapi}/asm/msgbuf.h (100%)
>  rename arch/cris/include/{ => uapi}/asm/param.h (100%)
>  rename arch/cris/include/{ => uapi}/asm/poll.h (100%)
>  rename arch/cris/include/{ => uapi}/asm/posix_types.h (100%)
>  create mode 100644 arch/cris/include/uapi/asm/ptrace.h
>  rename arch/cris/include/{ => uapi}/asm/resource.h (100%)
>  rename arch/cris/include/{ => uapi}/asm/rs485.h (100%)
>  rename arch/cris/include/{ => uapi}/asm/sembuf.h (100%)
>  rename arch/cris/include/{ => uapi}/asm/setup.h (100%)
>  rename arch/cris/include/{ => uapi}/asm/shmbuf.h (100%)
>  rename arch/cris/include/{ => uapi}/asm/sigcontext.h (100%)
>  rename arch/cris/include/{ => uapi}/asm/siginfo.h (100%)
>  create mode 100644 arch/cris/include/uapi/asm/signal.h
>  rename arch/cris/include/{ => uapi}/asm/socket.h (100%)
>  rename arch/cris/include/{ => uapi}/asm/sockios.h (100%)
>  rename arch/cris/include/{ => uapi}/asm/stat.h (100%)
>  rename arch/cris/include/{ => uapi}/asm/statfs.h (100%)
>  create mode 100644 arch/cris/include/uapi/asm/swab.h
>  rename arch/cris/include/{ => uapi}/asm/sync_serial.h (100%)
>  rename arch/cris/include/{ => uapi}/asm/termbits.h (100%)
>  create mode 100644 arch/cris/include/uapi/asm/termios.h
>  create mode 100644 arch/cris/include/uapi/asm/types.h
>  create mode 100644 arch/cris/include/uapi/asm/unistd.h
> .
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
