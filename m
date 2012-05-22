Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137Ab2EVOJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 10:09:39 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45709 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005Ab2EVOJh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 10:09:37 -0400
MIME-Version: 1.0
In-Reply-To: <CANQmPXgqjSuo0jy-O04-qp64b4J-Lk64sv0wzmdG1yUtc9v-Sw@mail.gmail.com>
References: <j2MgV-2Qe-9@gated-at.bofh.it>
	<4FB8B2E6.5010601@onlinehome.de>
	<CAJd=RBDY3Vd8EYFz=n6smFK2EhypgHpvyC_eG1QyE3Us-Y8-qg@mail.gmail.com>
	<CANQmPXh+0LECyLJ-MrDBZf2ZwLv5BJk0+DCFgPzqSChrFV=2WA@mail.gmail.com>
	<CAJd=RBDbqMHcmKdFVJEEq8LSQP1+Dfo7ancWhTV4uR2fO9k+Jg@mail.gmail.com>
	<CANQmPXhYMbDG7Wiaiwbr3J+Fft3FnaS=RM2t=FSRN-hYDSbMzw@mail.gmail.com>
	<CAJd=RBA79ygaWxigMfLZkNjURg2r0DwrzKzRZytzHDMQE2XoNA@mail.gmail.com>
	<CANQmPXgqjSuo0jy-O04-qp64b4J-Lk64sv0wzmdG1yUtc9v-Sw@mail.gmail.com>
Date: Tue, 22 May 2012 22:09:36 +0800
Message-ID: <CAJd=RBArne+LupLRxiCUAyCV16Xg4VVLn6R=uU2QPPJk_cdS0w@mail.gmail.com>
Subject: Re: BFS 420: cleanup in tick handling
From: Hillf Danton <dhillf@gmail.com>
To: Chen <hi3766691@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 10:07 PM, Chen <hi3766691@gmail.com> wrote:
>
> 在 2012-5-22 下午10:04，"Hillf Danton" <dhillf@gmail.com>写道：
>
>
>>
>> On Tue, May 22, 2012 at 10:00 PM, Chen <hi3766691@gmail.com> wrote:
>> >
>> > 在 2012-5-22 下午9:50，"Hillf Danton" <dhillf@gmail.com>写道：
>> >>
>> >> On Tue, May 22, 2012 at 9:45 PM, Chen <hi3766691@gmail.com> wrote:
>> >> > Actually the lowest deadline task selection algorithm now BFS used is
>> >> > O(n).
>> >> > I have already had an idea to enhance the lowest deadline task
>> >> > selection
>> >> > algorithm to O(1)
>> >>
>> >> Would you please announce it on LKML?
>> >
>> > First of all let me talk how to do it .We can use 40 list_head instead
>> > of
>> > the single list for time sharing scheduling policy.
>> > Then for task selection we will select the task from these 40
>> > list_head(actually not 40, just decide by next_sched_bit), then make a
>> > comparsion of these tasks(actually in the worse case we just need to do
>> > 40
>> > times of comparsion) and pick the lowest task. If a task wake, it would
>> > be
>> > the first node of (queue + p->prio). If a task run out of its timeslice,
>> > it
>> > will become the last node of(queue + p->prio). This is a concept of BFS
>> > deadline presort algorithm and the time complexity is O(1)
>>
>> Thank you for shedding light, I will study it soon.
> If you are free could you also help me to maintain my cpu scheduler, thanks.
> . :-)
No promise but try my best, ok?
