Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab0CVXug (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 19:50:36 -0400
Received: from ozlabs.org ([203.10.76.45]:55551 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724Ab0CVXuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 19:50:35 -0400
Date: Tue, 23 Mar 2010 10:45:53 +1100
From: Anton Blanchard <anton@samba.org>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       David Howells <dhowells@redhat.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Compile error in latest =?utf-8?Q?-git?=
	=?utf-8?Q?=3A_ipc=2Fsyscall=2Ec=3A17=3A_error=3A_conflicting_types_for_?=
	=?utf-8?B?4oCYc3lzX2lwY+KAmQ==?=
Message-ID: <20100322234553.GG24064@kryten>
References: <4BA7C6B7.4030203@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4BA7C6B7.4030203@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

> Hi everyone (you were all identified by get_maintainer.pl, in case
> you are wondering),
> 
> In case this hasn't been reported before, I get the following
> compile error with latest git:
> 
> ipc/syscall.c:17: error: conflicting types for ‘sys_ipc’
> include/linux/syscalls.h:691: note: previous declaration of
> ‘sys_ipc’ was here

My fault:

http://lists.ozlabs.org/pipermail/linuxppc-dev/2010-March/081285.html

For my penance I promise to beat myself with a printout of the git manpages.

Anton
