Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab1I1Mil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 08:38:41 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:33992 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab1I1Mik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 08:38:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAOVSwNFp=p3TmkfvB=BKq8b_jJVTywRspJSE3fhyKQaCfnzUvg@mail.gmail.com>
References: <CAOVSwNFp=p3TmkfvB=BKq8b_jJVTywRspJSE3fhyKQaCfnzUvg@mail.gmail.com>
Date: Wed, 28 Sep 2011 14:38:39 +0200
Message-ID: <CAOVSwNEmhh8wbo79EY_MKOkGy9pVXZVALujBbBYAVg06_YuukQ@mail.gmail.com>
Subject: Re: [Priority Inheritance] SCHED_FIFO or SCHED_RR?
From: "Tadeus (Eus) Prastowo" <0x657573@googlemail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping :)

On Wed, Sep 28, 2011 at 1:06 AM, Tadeus (Eus) Prastowo
<0x657573@googlemail.com> wrote:
> Hi!
>
> When a SCHED_RR task with RT priority X blocks on a
> priority-inheriting mutex held by a SCHED_NORMAL task with nice value
> Y, RT-Mutex code will change the SCHED_NORMAL task priority to that of
> the SCHED_RR task and based on the new priority, will change the
> scheduling class too. But, each task retains its own scheduling
> policy.
>
> This means that the task inheriting the SCHED_RR priority will be
> scheduled using SCHED_FIFO policy because task_tick_rt does not
> enforce the SCHED_RR time slice when the task policy is not SCHED_RR.
>
> Why should a SCHED_NORMAL task inheriting the priority of a SCHED_RR
> task get the privilege of SCHED_FIFO task for running as long as it
> wishes even when the task giving the inheritance does not have such
> privilege?
>
> Thank you very much.
>
> Please kindly put me in the CC since I am not subscribed to the list.
>
> --
> Eus
