Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab1JZAqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 20:46:36 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59049 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab1JZAqf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 20:46:35 -0400
MIME-Version: 1.0
In-Reply-To: <1316804080-6396-1-git-send-email-venki@google.com>
References: <1316804080-6396-1-git-send-email-venki@google.com>
Date: Wed, 26 Oct 2011 08:46:34 +0800
Message-ID: <CAGjg+kH577VE4cyq5zVNR962S6xbGCNnGS0w6N1DVuOppL3Khw@mail.gmail.com>
Subject: Re: [RFC] Introduce greedy hrtimer walk on idle
From: alex shi <lkml.alex@gmail.com>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org, "Chen, Tim C" <tim.c.chen@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Signed-off-by: Venkatesh Pallipadi <venki@google.com>
> ---
>  arch/x86/kernel/process_64.c |    2 +
>  include/linux/hrtimer.h      |   14 ++++
>  include/linux/sched.h        |    1 +
>  include/linux/timerqueue.h   |   11 +++
>  kernel/hrtimer.c             |  175 +++++++++++++++++++++++++++++++++++++-----
>  kernel/sched.c               |    2 +
>  kernel/sysctl.c              |    7 ++
>  7 files changed, 191 insertions(+), 21 deletions(-)
>
Hi, venki, what version of thia patch against? I want to test the
power consumption for your patch.
