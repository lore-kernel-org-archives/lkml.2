Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab1KAMY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 08:24:29 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36446 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371Ab1KAMY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 08:24:28 -0400
MIME-Version: 1.0
Date: Tue, 1 Nov 2011 08:24:27 -0400
Message-ID: <CALKntY3E_opsxYBP+3xB0GTFefo=Q2A3A0w+dbXVnqs+CX3Kqw@mail.gmail.com>
Subject: Linux scheduler Questions
From: Xin Tong <xerox.time.tech@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2 questions on Linux 2.6.x scheduler.

1.  in Linux 2.6, when a process is waiting for IO. it will be placed
on the wait queue. is the wait queue per cpu or global ? I do not see
any field for the wait queue in the runqueue structure.
2. Linux 2.6 has the notion of scheduling domain, using an example to
explain what I am getting at here

In a HT enabled CPU, the CPU has 2 cores, each core has 2 threads.
there will be 2 levels of domain.
1. Domain of lev.1 ==> 2 groups, 1 physical core per group.
2. Domain of lev. 0 ==> 2 groups, 1 logical core per group.
When the load on the 2 logical cores is imbalanced, Linux will migrate
some jobs from one to another. What if there is an imbalance of
workload on the 2 physical cores ?

Thanks

Xin
