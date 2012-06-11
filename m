Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab2FKWi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 18:38:28 -0400
Received: from mailout-us.gmx.com ([74.208.5.67]:47003 "HELO
	mailout-us.gmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751515Ab2FKWi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 18:38:27 -0400
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Date: Mon, 11 Jun 2012 18:38:24 -0400
From: "Micheal Blue" <mblue@gmx.us>
Message-ID: <20120611223825.153810@gmx.com>
MIME-Version: 1.0
Subject: =?utf-8?Q?Re=3A_=5BBUG=5D_sysload_accounting_broken_in_bfs_v0=2E422=E2=80=8F?=
To: "Con Kolivas" <kernel@kolivas.org>
X-Authenticated: #135695170
X-Flags: 0001
X-Mailer: GMX.com Web Mailer
x-registered: 0
Content-Transfer-Encoding: 8bit
X-GMX-UID: Nhakb3Fd3zOlNSPofXwhl1V+IGRvb4DU
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Indeed it is fixed. Good job sir. Do you know what causes htop to ignore running processes in the table view but show them correctly in the progress graphs? You can see this bug when you are compiling and have htop sorting by CPU% use. Works just fine with the kernel.org kernel but as soon as bfs is enabled, the bug is there :/

> ----- Original Message -----
> From: Con Kolivas
> Sent: 06/10/12 08:03 PM
> To: Micheal Blue
> Subject: Re: [BUG] sysload accounting broken in bfs v0.422‏
> 
> On 10 June 2012 14:16, Con Kolivas <kernel@kolivas.org> wrote:
> > On 10 June 2012 01:56, Micheal Blue <mblue@gmx.us> wrote:
> >> Bug to report with bfs v0.422: no sysload even when compiling on a quad core with 4 threads.  This bug also affects htop.
> >>
> >> $ uptime
> >> 15:58:10 up 7:52, 2 users, load average: 0.00, 0.00, 0.00
> >>
> >> $ cat /proc/loadavg
> >> 0.00 0.00 0.00 6/336 31689
> >>
> >> Link to bfs patch: http://ck.kolivas.org/patches/bfs/3.4.0/3.4-sched-bfs-422.patch
> >>
> >> I think this is a long standing bug with bfs actually.
> >
> > Thanks. It's a known bug that started with 422. If I ever find time to
> > code on bfs in the near future I'll fix it. If this is unacceptable to
> > you please use an earlier kernel with bfs or don't use bfs at all. If
> > someone else wishes to debug it in the interim, be my guest as it's
> > likely a very trivial bug introduced in the 420-422 changes which were
> > necessary to merge with linux 3.4
> 
> This is fixed in BFS 423 and 3.4-ck2:
> 
> http://ck.kolivas.org/patches/bfs/3.4.0/3.4-sched-bfs-423.patch
> http://ck.kolivas.org/patches/3.0/3.4/3.4-ck2/
> 
> --
> -ck

