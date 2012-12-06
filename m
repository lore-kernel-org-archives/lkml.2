Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946453Ab2LFRuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 12:50:08 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:49644 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932888Ab2LFRuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 12:50:07 -0500
MIME-Version: 1.0
In-Reply-To: <1354542848-29638-2-git-send-email-alex.shi@intel.com>
References: <1354542848-29638-1-git-send-email-alex.shi@intel.com>
	<1354542848-29638-2-git-send-email-alex.shi@intel.com>
Date: Thu, 6 Dec 2012 18:50:05 +0100
Message-ID: <CAFTL4hw1Zq+nUG5CXe+7sGNa_1A3YGpe-TBbSTeaPtzXWD57hg@mail.gmail.com>
Subject: Re: [PATCH 01/10] sched: select_task_rq_fair clean up
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alex Shi <alex.shi@intel.com>
Cc: npiggin@kernel.dk, mingo@redhat.com, peterz@infradead.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/3 Alex Shi <alex.shi@intel.com>:
> It is impossible to miss a task allowed cpu in a eligible group.
>
> And since find_idlest_group only return a different group which
> excludes old cpu, it's also imporissible to find a new cpu same as old
> cpu.

Is it possible for weighted_cpuload() to return ULONG_MAX? If so,
find_idlest_cpu() can return -1.
