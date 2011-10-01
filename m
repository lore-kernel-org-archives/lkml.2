Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057Ab1JAUbN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 16:31:13 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46049 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756094Ab1JAUbE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 16:31:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAOVSwNEQzhzoKwnW5dZn8YsL5G+80_yvodmeJKBs2dSAxn7MsQ@mail.gmail.com>
References: <CAOVSwNFp=p3TmkfvB=BKq8b_jJVTywRspJSE3fhyKQaCfnzUvg@mail.gmail.com>
	<CAOVSwNHoNuNBsuUecZhF0iWOL3PbJQt0cHR7Evf+gW6Q6SGA7Q@mail.gmail.com>
	<1317447669.6337.24.camel@marge.simson.net>
	<CAOVSwNEQzhzoKwnW5dZn8YsL5G+80_yvodmeJKBs2dSAxn7MsQ@mail.gmail.com>
Date: Sat, 1 Oct 2011 22:31:03 +0200
Message-ID: <CAOVSwNH=K796hrtPkGh_y47gbkC+f_Cn+_CqBX-ozPtmQ3KfDA@mail.gmail.com>
Subject: Re: [Priority Inheritance] SCHED_FIFO or SCHED_RR?
From: "Tadeus (Eus) Prastowo" <0x657573@googlemail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 1, 2011 at 10:29 PM, Tadeus (Eus) Prastowo
<0x657573@googlemail.com> wrote:
> For the case of one SCHED_RR task sharing a critical section with one
> SCHED_NORMAL task, the worst-case blocking time of the SCHED_RR task
> is found by multiplying the critical section execution time taking
> into account the slice by two.

Sorry, the worst-case blocking time is just the critical section
execution time taking into account the slice.

>>        -Mike
>
> --
> Eus
