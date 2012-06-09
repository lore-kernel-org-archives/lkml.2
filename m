Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab2FIP4o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 11:56:44 -0400
Received: from mailout-us.gmx.com ([74.208.5.67]:37307 "HELO
	mailout-us.gmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753649Ab2FIP4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 11:56:35 -0400
Cc: kernel@kolivas.org, mblue@gmx.us
Content-Type: text/plain; charset="utf-8"
Date: Sat, 09 Jun 2012 11:56:31 -0400
From: "Micheal Blue" <mblue@gmx.us>
Message-ID: <20120609155632.153780@gmx.com>
MIME-Version: 1.0
Subject: =?utf-8?Q?=5BBUG=5D_sysload_accounting_broken_in_bfs_v0=2E422=E2=80=8F?=
To: linux-kernel@vger.kernel.org
X-Authenticated: #135695170
X-Flags: 0001
X-Mailer: GMX.com Web Mailer
x-registered: 0
Content-Transfer-Encoding: 8bit
X-GMX-UID: Zxehb3Zd3zOlNSPofXwhBmJ+IGRvb0Du
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bug to report with bfs v0.422: no sysload even when compiling on a quad core with 4 threads.  This bug also affects htop.

$ uptime
15:58:10 up 7:52, 2 users, load average: 0.00, 0.00, 0.00

$ cat /proc/loadavg 
0.00 0.00 0.00 6/336 31689

Link to bfs patch: http://ck.kolivas.org/patches/bfs/3.4.0/3.4-sched-bfs-422.patch

I think this is a long standing bug with bfs actually.
