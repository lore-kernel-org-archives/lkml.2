Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab1EQKAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 06:00:42 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:48059 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754024Ab1EQKAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 06:00:41 -0400
Date: Tue, 17 May 2011 11:01:49 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipc: Add missing sys_ni entries for ipc/compat.c
 functions
Message-ID: <20110517100149.GA7516@linux-mips.org>
References: <cb0939f54999dd3754808f2c5fc1cf0f@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb0939f54999dd3754808f2c5fc1cf0f@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 05:07:28PM -0700, Kevin Cernekee wrote:
> Date:   Fri, 13 May 2011 17:07:28 -0700
> From: Kevin Cernekee <cernekee@gmail.com>
> To: Andrew Morton <akpm@linux-foundation.org>, Al Viro
>  <viro@zeniv.linux.org.uk>, Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
> Subject: [PATCH] ipc: Add missing sys_ni entries for ipc/compat.c functions
> Content-Type: text/plain; charset=us-ascii
> 
> When building with:
> 
> CONFIG_64BIT=y
> CONFIG_MIPS32_COMPAT=y
> CONFIG_COMPAT=y
> CONFIG_MIPS32_O32=y
> CONFIG_MIPS32_N32=y
> CONFIG_SYSVIPC is not set
> (and implicitly: CONFIG_SYSVIPC_COMPAT is not set)
> 
> the final link fails with unresolved symbols for:
> 
> compat_sys_semctl, compat_sys_msgsnd, compat_sys_msgrcv,
> compat_sys_shmctl, compat_sys_msgctl, compat_sys_semtimedop
> 
> The fix is to add cond_syscall declarations for all syscalls in
> ipc/compat.c
> 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>

Acked-by: Ralf Baechle <ralf@linux-mips.org>

Thanks, Kevin!

  Ralf
