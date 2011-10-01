Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab1JAU3R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 16:29:17 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60283 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab1JAU3G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 16:29:06 -0400
MIME-Version: 1.0
In-Reply-To: <1317447669.6337.24.camel@marge.simson.net>
References: <CAOVSwNFp=p3TmkfvB=BKq8b_jJVTywRspJSE3fhyKQaCfnzUvg@mail.gmail.com>
	<CAOVSwNHoNuNBsuUecZhF0iWOL3PbJQt0cHR7Evf+gW6Q6SGA7Q@mail.gmail.com>
	<1317447669.6337.24.camel@marge.simson.net>
Date: Sat, 1 Oct 2011 22:29:04 +0200
Message-ID: <CAOVSwNEQzhzoKwnW5dZn8YsL5G+80_yvodmeJKBs2dSAxn7MsQ@mail.gmail.com>
Subject: Re: [Priority Inheritance] SCHED_FIFO or SCHED_RR?
From: "Tadeus (Eus) Prastowo" <0x657573@googlemail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 1, 2011 at 7:41 AM, Mike Galbraith <efault@gmx.de> wrote:
> On Fri, 2011-09-30 at 21:12 +0200, Tadeus (Eus) Prastowo wrote:
>> > Why should a SCHED_NORMAL task inheriting the priority of a SCHED_RR
>> > task get the privilege of SCHED_FIFO task for running as long as it
>> > wishes even when the task giving the inheritance does not have such
>> > privilege?
>
> Existence of a critical section > slice would be the real problem, no?

No, it's not a problem because if a real-time system designer puts a
real-time task under SCHED_RR, he will calculate the length of the
critical section by taking into account the slice.

For the case of one SCHED_RR task sharing a critical section with one
SCHED_NORMAL task, the worst-case blocking time of the SCHED_RR task
is found by multiplying the critical section execution time taking
into account the slice by two.

>        -Mike

-- 
Eus
