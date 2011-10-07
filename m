Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497Ab1JGC75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 22:59:57 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44592 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab1JGC74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 22:59:56 -0400
MIME-Version: 1.0
In-Reply-To: <m28vox36cm.fsf@firstfloor.org>
References: <CAOzbF4dvtM5WJ9-LkP4tFROA_gnT-gh-+-3qJLSqtUKOp0SvMg@mail.gmail.com>
	<m28vox36cm.fsf@firstfloor.org>
Date: Thu, 6 Oct 2011 19:59:55 -0700
Message-ID: <CAOzbF4d+4cZNu_jTPuWcxves2QvidczcfzMzspMKYkGHi-mFxA@mail.gmail.com>
Subject: Re: intercommunications between Linux kernel modules
From: Cyclonus J <cyclonusj@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 6, 2011 at 7:04 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Cyclonus J <cyclonusj@gmail.com> writes:
>
>> I am looking for a way to do an IPC-like communications between two
>> linux kernel modules, such as mqueue or shared memory. After searching
>> for a while, I can't find such information available inside existing
>> linux kernel or online.
>>
>> So, my question is if this is something discussed before here and gets
>> rejected or still might be accepted in the mainstream kernel tree?
>
> All kernel memory is shared in Linux, so the concept doesn't make sense.
>
> If you want to send messages or communicate inside the kernel there are
> lots of different facilities available.

Andi,

That would be great! Could you point me to some facilities that can do
this message passing between kernels?

Thanks,
CJ

>
> -Andi
> --
> ak@linux.intel.com -- Speaking for myself only
>
