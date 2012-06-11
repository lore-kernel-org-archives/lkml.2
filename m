Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab2FKAEB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 20:04:01 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42989 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab2FKAEA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 20:04:00 -0400
MIME-Version: 1.0
In-Reply-To: <CABqErrG5WEy6+daqLo6JwoZOOZgh7wFUtdjGXJh7enHQ6--F+g@mail.gmail.com>
References: <20120609155632.153780@gmx.com>
	<CABqErrG5WEy6+daqLo6JwoZOOZgh7wFUtdjGXJh7enHQ6--F+g@mail.gmail.com>
Date: Mon, 11 Jun 2012 10:03:58 +1000
X-Google-Sender-Auth: gFKeDwf6ZyHAjea_mmPiZw44KQU
Message-ID: <CABqErrFJWWeujW5XAkD3kMRDUbF7hCdaVt28+_QAMSeUQtg0mw@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_=5BBUG=5D_sysload_accounting_broken_in_bfs_v0=2E422=E2=80=8F?=
From: Con Kolivas <kernel@kolivas.org>
To: Micheal Blue <mblue@gmx.us>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 June 2012 14:16, Con Kolivas <kernel@kolivas.org> wrote:
> On 10 June 2012 01:56, Micheal Blue <mblue@gmx.us> wrote:
>> Bug to report with bfs v0.422: no sysload even when compiling on a quad core with 4 threads.  This bug also affects htop.
>>
>> $ uptime
>> 15:58:10 up 7:52, 2 users, load average: 0.00, 0.00, 0.00
>>
>> $ cat /proc/loadavg
>> 0.00 0.00 0.00 6/336 31689
>>
>> Link to bfs patch: http://ck.kolivas.org/patches/bfs/3.4.0/3.4-sched-bfs-422.patch
>>
>> I think this is a long standing bug with bfs actually.
>
> Thanks. It's a known bug that started with 422. If I ever find time to
> code on bfs in the near future I'll fix it. If this is unacceptable to
> you please use an earlier kernel with bfs or don't use bfs at all. If
> someone else wishes to debug it in the interim, be my guest as it's
> likely a very trivial bug introduced in the 420-422 changes which were
> necessary to merge with linux 3.4

This is fixed in BFS 423 and 3.4-ck2:

http://ck.kolivas.org/patches/bfs/3.4.0/3.4-sched-bfs-423.patch
http://ck.kolivas.org/patches/3.0/3.4/3.4-ck2/

--
-ck
