Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834Ab1ETUfK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 16:35:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:65244 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab1ETUfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 16:35:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kevin Cernekee <cernekee@gmail.com>
Subject: Re: [PATCH resend] ipc: Add missing sys_ni entries for ipc/compat.c functions
Date: Fri, 20 May 2011 22:34:44 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
References: <5a124a3b070fd1dc1f28d72e78e72534@localhost>
In-Reply-To: <5a124a3b070fd1dc1f28d72e78e72534@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105202234.44260.arnd@arndb.de>
X-Provags-ID: V02:K0:fW7eRvK1TQgxTLZDEN7dX4wtJ7GADnO9/nGyEmFb1sl
 qpChrNt1Nuxp6Xo9ZGY7x+FCXEuFeXrMTTMsSrd1NKNKxIRxe5
 4UFzekUcpg1PNzSWvFVZbWQh7N0B1ihffUHW1Tl6M4iJ+FWbZf
 6WjvE8S8OUTReFyvVEapSBcaZc4hbeC3p8hH7pTUQHuFJ9ZTZ+
 MS3etcO4WTHGZCmJpYBhw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 May 2011 19:39:58 Kevin Cernekee wrote:
> the final link fails with unresolved symbols for:
> 
> compat_sys_semctl, compat_sys_msgsnd, compat_sys_msgrcv,
> compat_sys_shmctl, compat_sys_msgctl, compat_sys_semtimedop
> 
> The fix is to add cond_syscall declarations for all syscalls in
> ipc/compat.c
> 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
> Acked-by: Ralf Baechle <ralf@linux-mips.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>

Acked-by: Arnd Bergmann <arnd@arndb.de>
