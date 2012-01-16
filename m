Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab2APNAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 08:00:06 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37987 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab2APNAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 08:00:04 -0500
MIME-Version: 1.0
In-Reply-To: <CADZ9YHiNWddjLBGnvDO==Jpz9nQtPREmkFOX0P5ELOK2neW1=g@mail.gmail.com>
References: <CADZ9YHicin2YjGm_m9B0LMv3NW1Z3cb7HSCaqwycFmVfRpvpWA@mail.gmail.com>
	<1326302955.2442.174.camel@twins>
	<CADZ9YHiC8732D=D8KpkT0d+81_BNdAvj0ZJLwL5mhyq9OPLW0Q@mail.gmail.com>
	<1326353130.2442.177.camel@twins>
	<4F13D77B.9070103@linux.vnet.ibm.com>
	<CADZ9YHiNWddjLBGnvDO==Jpz9nQtPREmkFOX0P5ELOK2neW1=g@mail.gmail.com>
Date: Mon, 16 Jan 2012 21:00:02 +0800
Message-ID: <CAJd=RBCp+Pdkip7O+xRhGFU2kpFyJQmxeXR5dJu7xmQ2uNrW9Q@mail.gmail.com>
Subject: Re: [Question] sched: Should nr_uninterruptible be decremented in ttwu_do_activate()?
From: Hillf Danton <dhillf@gmail.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Michael Wang <wangyun@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 4:27 PM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
> On Mon, Jan 16, 2012 at 1:53 PM, Michael Wang
> <wangyun@linux.vnet.ibm.com> wrote:
>> I think the task in rq->wake_list should already have state:TASK_WAKING,
>> because it's a wake list.
>>
> But, what I got by means of TASK_WAKING is this task is about to RUN,
> very soon it'll have TASK_RUNNING state. And, if I hadn't miss any
> portion of code, then rq->wake_list doesn't have TASK_WAKING state.
>
Hi Rakib

The question maybe settled down by adding a BUG_ON or similar to
capture what you concern, and wait results while drinking tea or
coffee.

Best regards
Hillf
