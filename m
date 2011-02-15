Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab1BOOIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 09:08:11 -0500
Received: from mx3-phx2.redhat.com ([209.132.183.24]:58937 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab1BOOIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 09:08:09 -0500
Date: Tue, 15 Feb 2011 09:07:34 -0500 (EST)
From: Dave Anderson <anderson@redhat.com>
To: "Discussion list for crash utility usage, maintenance and development" 
	<crash-utility@redhat.com>,
        ebiederm@xmission.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alex Riesen <raa.lkml@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>
Message-ID: <1786262081.42701.1297778854137.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <AANLkTiko+Rsaf4-erkXdriGhSSt8DFptTaMBWd7ZsotA@mail.gmail.com>
Subject: Re: [Crash-utility] Heads up Linux 2.6.38-rc4 compile problems.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.72]
X-Mailer: Zimbra 6.0.9_GA_2686 (ZimbraWebClient - FF3.0 (Linux)/6.0.9_GA_2686)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> Hey Eric,
> 
> On Mon, Feb 14, 2011 at 12:34 AM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
> >
> > And for completeness. When I was rebooting v2.6.38-rc4 to start running
> > 795abaf1e4e188c4171e3cd3dbb11a9fcacaf505 I hit this.
> >
> > Sigh. I wish crash worked on something besides redhats enterprise
> > kernels. Then I could use the system core file I have to do more than
> > extract the dmesg.

I update the upstream version of crash typically once a month.

Perhaps you are using an older version?  I just built a 2.6.38-rc4 
kernel, and the latest version of crash (5.1.2) works OK with it:

  [root@hp-z400-02 ~]# crash
  
  crash 5.1.2
  Copyright (C) 2002-2011  Red Hat, Inc.
  Copyright (C) 2004, 2005, 2006  IBM Corporation
  Copyright (C) 1999-2006  Hewlett-Packard Co
  Copyright (C) 2005, 2006  Fujitsu Limited
  Copyright (C) 2006, 2007  VA Linux Systems Japan K.K.
  Copyright (C) 2005  NEC Corporation
  Copyright (C) 1999, 2002, 2007  Silicon Graphics, Inc.
  Copyright (C) 1999, 2000, 2001, 2002  Mission Critical Linux, Inc.
  This program is free software, covered by the GNU General Public License,
  and you are welcome to change it and/or distribute copies of it under
  certain conditions.  Enter "help copying" to see the conditions.
  This program has absolutely no warranty.  Enter "help warranty" for details.
   
  GNU gdb (GDB) 7.0
  Copyright (C) 2009 Free Software Foundation, Inc.
  License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
  This is free software: you are free to change and redistribute it.
  There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
  and "show warranty" for details.
  This GDB was configured as "x86_64-unknown-linux-gnu"...
  
        KERNEL: /vmlinux
      DUMPFILE: /dev/mem
          CPUS: 6
          DATE: Tue Feb 15 08:57:17 2011
        UPTIME: 00:00:54
  LOAD AVERAGE: 0.37, 0.10, 0.04
         TASKS: 132
      NODENAME: hp-z400-02.lab.bos.redhat.com
       RELEASE: 2.6.38-rc4
       VERSION: #1 SMP Mon Feb 14 17:41:17 EST 2011
       MACHINE: x86_64  (3067 Mhz)
        MEMORY: 4 GB
           PID: 1539
       COMMAND: "crash"
          TASK: ffff8801363f9710  [THREAD_INFO: ffff880135f2a000]
           CPU: 0
         STATE: TASK_RUNNING (ACTIVE)
  
  crash>

Dave

> 
> Then you should cc crash-utility@redhat.com (now cc'd) and work with
> Dave Anderson (e.g. get him your vmlinux and core files, which version
> of crash you're using and how it fails). Dave does an amazing job of
> working through crash issues which are reported against upstream
> kernels -- the key first step is the report.
> 
> Mike
> 
> --
> Crash-utility mailing list
> Crash-utility@redhat.com
> https://www.redhat.com/mailman/listinfo/crash-utility
