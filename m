Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364Ab1CRTky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 15:40:54 -0400
Received: from clem.clem-digital.net ([68.16.168.10]:44965 "EHLO
	clem.clem-digital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756464Ab1CRTks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 15:40:48 -0400
X-Greylist: delayed 521 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Mar 2011 15:40:48 EDT
From: Pete Clements <clem@clem.clem-digital.net>
Message-Id: <201103181932.p2IJW5cg002394@clem.clem-digital.net>
Subject: 38-git2-6 -- kernel/futex.c warning
To: linux-kernel@vger.kernel.org (linux-kernel)
Date: Fri, 18 Mar 2011 15:32:05 -0400 (EDT)
X-Mailer: ELM [version 2.5 PL7]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fyi. Have been experiencing the below since 38-git2. Continual scrolling
such that cannot complete system startup. System is i386 UP, Debian "squeeze".

WARNING: at kernel/futex.c:786 wake_futex+0x21/0x70()
Hardware name: XPST450
Modules linked in: ipv6
Pid: 1045, comm: rndc Not tainted 2.6.38-git6 #1
Call Trace:
[<c101eba8>] ? warn_slowpath_common+0x78/0xb0
[<c1040b21>] ? wake_futex+0x21/0x70
[<c1040b21>] ? wake_futex+0x21/0x70
[<c101ebf9>] ? warn_slowpath_null+0x19/0x20
[<c1040b21>] ? wake_futex+0x21/0x70
[<c10429d9>] ? do_futex+0x629/0x950
[<c108f2a3>] ? d_kill+0x73/0xd0
[<c1042d78>] ? sys_futex+0x78/0x130
[<c107c2dd>] ? filp_close+0x4d/0x80
[<c11fa8bd>] ? syscall_call+0x7/0xb
---[ end trace 595c935fe53c9cd0 ]---

-- 
Pete Clements 
