Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab1CWFno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 01:43:44 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46161 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab1CWFnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 01:43:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ZTCwOllpHDAlryG9kRdaSS1rU/TYEYwwFJ7IOwwobNioEDvNK4ows0nqnOSlDZBQwY
         MWtCV0eEqtVRB5JduUd2cR6FN+GVIzc9/QPgTgckE/qfZb4POdfA532zdMeL4l3maiJG
         6+FjceCz19AtbZtL0NDeTWEMDmOd2L80MTpqY=
MIME-Version: 1.0
In-Reply-To: <AANLkTikHqJR=JgZzKc1G-m8z82hBFmD-w1bLn5aENTcr@mail.gmail.com>
References: <AANLkTinmjGaK9ZSbKYTm5g-wuQ-K1hQaJBA+gSN5ERJ=@mail.gmail.com>
	<AANLkTikHqJR=JgZzKc1G-m8z82hBFmD-w1bLn5aENTcr@mail.gmail.com>
Date: Wed, 23 Mar 2011 11:13:41 +0530
Message-ID: <AANLkTi=ZnTv57N=GyvhOfU+Cam6S_RyuZVXzuxHVC6LF@mail.gmail.com>
Subject: Re: Tests for cpusets and cgroup performance measurement
From: Jaswinder Singh <jaswinderlinux@gmail.com>
To: Paul Menage <menage@google.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Paul,

On Mon, Mar 21, 2011 at 11:03 PM, Paul Menage <menage@google.com> wrote:
> On Mon, Mar 21, 2011 at 3:42 AM, Jaswinder Singh
> <jaswinderlinux@gmail.com> wrote:
>>
>> Can you please suggest some simple tests to measure the performance
>> enhancement by using cpusets/cgroups.
>
> The cgroups framework is simply a way of grouping processes together
> and allowing subsystems (memory, CPU, disk I/O, etc) to associate
> state objects with each group. Generally this is for improving
> isolation rather than improving performance - sticking extra machinery
> and scheduling in will typically reduce overall throughput, but make
> it more practical to share resources safely between multiple groups of
> processes.
>
> Your question is pretty open-ended - what's your ultimate goal? You
> should probably be focusing on some particular problem that you're
> trying to measure/improve via resource isolation/scheduling.
>

As per http://www.clusterresources.com/torquedocs21/3.5linuxcpusets.shtml :

Under section 3.5.4 Cpuset advantages / disadvantages

"Jobs on larger NUMA systems may see a performance boost if jobs can be
intelligently assigned to specific CPUs. Jobs may perform better if
striped across physical processors, or contained within the fewest
number of memory controllers."


I am curious and want to try some simple tests so that I can see the
performance improvement by using cpusets on my PCs.

Can you suggest some tests so that I can study them.

Thank you,
--
Jaswinder Singh.
