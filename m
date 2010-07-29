Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab0G2IDD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 04:03:03 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33884 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab0G2IC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 04:02:56 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 29 Jul 2010 16:58:01 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Luming Yu <luming.yu@gmail.com>
Cc: dann frazier <dannf@debian.org>, Hugh Dickins <hughd@google.com>,
        linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Nick Piggin <npiggin@suse.de>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: ia64 hang/mca running gdb 'make check'
Message-Id: <20100729165801.f3a6dfe9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTi=5tYjnvg2UyLUD7eEFgn-qzkiAWzUyp4F+Yjzw@mail.gmail.com>
References: <20100720173512.GF26783@ldl.fc.hp.com>
	<20100721105136.9d4440de.kamezawa.hiroyu@jp.fujitsu.com>
	<20100721030629.GA9987@lackof.org>
	<alpine.DEB.1.00.1007202106420.12760@tigran.mtv.corp.google.com>
	<20100727071914.GB22945@lackof.org>
	<20100727180330.b6ecba7f.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTi=5tYjnvg2UyLUD7eEFgn-qzkiAWzUyp4F+Yjzw@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jul 2010 15:38:06 +0800
Luming Yu <luming.yu@gmail.com> wrote:

> On Tue, Jul 27, 2010 at 5:03 PM, KAMEZAWA Hiroyuki

> # gdb ./foo
> GNU gdb (GDB) Red Hat Enterprise Linux (7.0.1-23.el5)
> Copyright (C) 2009 Free Software Foundation, Inc.
> License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
> This is free software: you are free to change and redistribute it.
> There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
> and "show warranty" for details.
> This GDB was configured as "ia64-redhat-linux-gnu".
> For bug reporting instructions, please see:
> <http://www.gnu.org/software/gdb/bugs/>...
> Reading symbols from /root/foo...done.
> (gdb) break leaf
> Breakpoint 1 at 0x40000000000005a1: file foo.c, line 2.
> (gdb) run
> Starting program: /root/foo
> 
> Breakpoint 1, leaf () at foo.c:2
> 2       }
> (gdb) gcore /tmp/save
> Segmentation fault
> # cat /proc/version
> Linux version 2.6.35-rc3+ ...
> 
> 

Hmm. What is EXEC_PAGESIZE installed in /usr/include/asm-generic/param.h ?
And what happnes when modify it to 16k if it's 64k ?

Thanks
-Kame




