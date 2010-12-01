Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab0LAS4H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:56:07 -0500
Received: from smtp-out.google.com ([216.239.44.51]:27935 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab0LAS4F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:56:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KuQwoLFueyd0UNlHbzUjJospevtYJZ4iXivWG7UqmEaap3PjomOy+JTTCZ+B7eKycy
         M419BQ8qolgfmSvFIj4g==
MIME-Version: 1.0
In-Reply-To: <AANLkTikRh0mKkPY=m+kX47+5QNxE-hHSoRbQST3hnDUq@mail.gmail.com>
References: <1286237003-12406-7-git-send-email-venki@google.com>
	<tip-305e6835e05513406fa12820e40e4a8ecb63743c@git.kernel.org>
	<AANLkTin-U-kzr27ArR60K=eE5Jq+sPdTQ7JNhQg711c7@mail.gmail.com>
	<1291031990.32004.24.camel@laptop>
	<20101129142213.GA2573@zhy>
	<1291050395.2697.259.camel@Palantir>
	<AANLkTikRh0mKkPY=m+kX47+5QNxE-hHSoRbQST3hnDUq@mail.gmail.com>
Date: Wed, 1 Dec 2010 10:55:59 -0800
Message-ID: <AANLkTinv6M-aeNjUStMi05UDbi15ZvTKSu9N-hM63F7J@mail.gmail.com>
Subject: Re: [tip:sched/core] sched: Do not account irq time to current task
From: Venkatesh Pallipadi <venki@google.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Raistlin <raistlin@linux.it>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 9:57 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> On Tue, Nov 30, 2010 at 1:06 AM, Raistlin <raistlin@linux.it> wrote:
>> On Mon, 2010-11-29 at 22:22 +0800, Yong Zhang wrote:
>>> > If you still want to throttle RT tasks simply ensure their bandwidth
>>> > constraint is lower than the available time.
>>>
>>> But the available time is harder to calculated than before.
>>>
>> Well, it shouldn't... I would say it makes it easier! :-P
>
> It depends on the way how we see it.
> From the side that we can just focus on task time, it's easy
> and well understood.  :)
>
> Now I think we need a way to export the irq_time to user,
> then the user can determine the average time spending
> on IRQ.
> Maybe Venkatesh Pallipadi's patchset titled "Proper
> kernel irq time reporting" is the one.
>

Yes. That second patchset exports this information through /proc/stat.
Peter: Can you pull that patchset into tip.

Thanks,
Venki
