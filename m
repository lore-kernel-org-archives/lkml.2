Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab1J0Qns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 12:43:48 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37299 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab1J0Qnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 12:43:47 -0400
MIME-Version: 1.0
In-Reply-To: <CAOSRKdSTiLRiwusJEmvudzuLYc+AkYYTka3+AQEpjcb81YtE0w@mail.gmail.com>
References: <CAOSRKdSTiLRiwusJEmvudzuLYc+AkYYTka3+AQEpjcb81YtE0w@mail.gmail.com>
Date: Thu, 27 Oct 2011 22:43:46 +0600
Message-ID: <CADZ9YHiNkU9Hq6jMrWULGj6kTnJdaPoDcAGCpGCmRNV9TzKM=Q@mail.gmail.com>
Subject: Re: How to choose a default sched policy
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Sebastiano Spicuglia <spicuglia.sebastiano@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        peterz <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 9:09 PM, Sebastiano Spicuglia
<spicuglia.sebastiano@gmail.com> wrote:
> Hi all,
>
> I implemented, just for accademic purposes, a new sched
> policy. Now I need to substitute it to the fair one, so when the kernel
> runs, normal tasks are scheduled by mine policy.
> How can i perform this switch? Is there in sched.c a single
> point of switch or I have to change every occurance of
> "p->sched_class = &fair_sched_class;" with
> "p->sched_class = &mine_sched_class;"?
>
Yes, you can do it in this way. You'll also need to create a Kconfig
option, from there you can select your scheduling policy.
Alternatively, you can also take a look at Con Kolivas's sched_bfs
implementation.

Thanks,
Rakib
