Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab1JBPcs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 11:32:48 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43497 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab1JBPcl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 11:32:41 -0400
MIME-Version: 1.0
In-Reply-To: <1317541807.6176.120.camel@marge.simson.net>
References: <CAOVSwNFp=p3TmkfvB=BKq8b_jJVTywRspJSE3fhyKQaCfnzUvg@mail.gmail.com>
	<CAOVSwNHoNuNBsuUecZhF0iWOL3PbJQt0cHR7Evf+gW6Q6SGA7Q@mail.gmail.com>
	<1317447669.6337.24.camel@marge.simson.net>
	<CAOVSwNEQzhzoKwnW5dZn8YsL5G+80_yvodmeJKBs2dSAxn7MsQ@mail.gmail.com>
	<1317541807.6176.120.camel@marge.simson.net>
Date: Sun, 2 Oct 2011 17:32:40 +0200
Message-ID: <CAOVSwNF8Qv7ZdARusZv3drcZsYu-=L6-oxcxDHnTu+4sLuzjXw@mail.gmail.com>
Subject: Re: [Priority Inheritance] SCHED_FIFO or SCHED_RR?
From: "Tadeus (Eus) Prastowo" <0x657573@googlemail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 2, 2011 at 9:50 AM, Mike Galbraith <efault@gmx.de> wrote:
> On Sat, 2011-10-01 at 22:29 +0200, Tadeus (Eus) Prastowo wrote:
>> On Sat, Oct 1, 2011 at 7:41 AM, Mike Galbraith <efault@gmx.de> wrote:
>> > On Fri, 2011-09-30 at 21:12 +0200, Tadeus (Eus) Prastowo wrote:
>> >> > Why should a SCHED_NORMAL task inheriting the priority of a SCHED_RR
>> >> > task get the privilege of SCHED_FIFO task for running as long as it
>> >> > wishes even when the task giving the inheritance does not have such
>> >> > privilege?
>> >
>> > Existence of a critical section > slice would be the real problem, no?
>>
>> No, it's not a problem because if a real-time system designer puts a
>> real-time task under SCHED_RR, he will calculate the length of the
>> critical section by taking into account the slice.
>
> Submit a patch, and see if it flies.

Okay, thank you for the direction. It seems that only with a patch I
can get the answer ;-)

>        -Mike

--
Eus
