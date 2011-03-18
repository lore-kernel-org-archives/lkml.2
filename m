Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402Ab1CRT5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 15:57:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46791
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756802Ab1CRT5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 15:57:31 -0400
Date: Fri, 18 Mar 2011 12:58:08 -0700 (PDT)
Message-Id: <20110318.125808.233714688.davem@davemloft.net>
To: clem@clem.clem-digital.net
Cc: linux-kernel@vger.kernel.org, mroos@linux.ee, sparclinux@vger.kernel.org
Subject: Re: 38-git2-6 -- kernel/futex.c warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <201103181932.p2IJW5cg002394@clem.clem-digital.net>
References: <201103181932.p2IJW5cg002394@clem.clem-digital.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pete Clements <clem@clem.clem-digital.net>
Date: Fri, 18 Mar 2011 15:32:05 -0400 (EDT)

> Fyi. Have been experiencing the below since 38-git2. Continual scrolling
> such that cannot complete system startup. System is i386 UP, Debian "squeeze".

Looks similar to the problems reported by Meelis, CC:'d

> WARNING: at kernel/futex.c:786 wake_futex+0x21/0x70()
> Hardware name: XPST450
> Modules linked in: ipv6
> Pid: 1045, comm: rndc Not tainted 2.6.38-git6 #1
> Call Trace:
> [<c101eba8>] ? warn_slowpath_common+0x78/0xb0
> [<c1040b21>] ? wake_futex+0x21/0x70
> [<c1040b21>] ? wake_futex+0x21/0x70
> [<c101ebf9>] ? warn_slowpath_null+0x19/0x20
> [<c1040b21>] ? wake_futex+0x21/0x70
> [<c10429d9>] ? do_futex+0x629/0x950
> [<c108f2a3>] ? d_kill+0x73/0xd0
> [<c1042d78>] ? sys_futex+0x78/0x130
> [<c107c2dd>] ? filp_close+0x4d/0x80
> [<c11fa8bd>] ? syscall_call+0x7/0xb
> ---[ end trace 595c935fe53c9cd0 ]---
> 
> -- 
> Pete Clements 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
