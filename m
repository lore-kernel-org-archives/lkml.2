Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760568Ab0FQR4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 13:56:06 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53607 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760409Ab0FQR4E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 13:56:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OXsLwYcWGrAapXxYJgsq+HGN9B15WyUjrFNECDQ+Tj1NjeNZysSpdVSaGkpUmKcT6c
         MG5RCPBKY51byi3i0QDCbxj8UQRdZJ99mT4Q3Qy8kU4m5wJOpuMbIG+5ZEkFq6stgsJk
         Zt0NWLsXdhf5YEFtiJNPGHkJu098Ou8hfSnEE=
MIME-Version: 1.0
In-Reply-To: <20100525071147.GC5985@elte.hu>
References: <20100523144912.jfmkhsp50kcgk8os@webmail-stud.polimi.it>
	<20100525071147.GC5985@elte.hu>
Date: Thu, 17 Jun 2010 19:02:49 +0200
Message-ID: <AANLkTikuunLAsrtS2GhSkICkYfN_0H0jdZyo7fxjQl9b@mail.gmail.com>
Subject: Re: Sched_class documentation
From: sebastiano spicuglia <spicuglia.sebastiano@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

I made many progress. But I have two doubts yet.
First: what does hrtick_start do?
I think that: if I call hrtick_start(rq, 500)  then, after 500ns, the
task_tick function will be invocated.
Is it right?
Second: if my schedule_class decides to preempt the current task, it
has to call resched_task(rq->curr).
Is it right?

Thanks in advance.
Kind Regards.
Sebastiano.

On Tue, May 25, 2010 at 9:11 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Hi,
>
> * sebastiano.spicuglia@mail.polimi.it <sebastiano.spicuglia@mail.polimi.it> wrote:
>
>> Hi Ingo,
>>
>> excuse me for contacting you in this way.
>> I don't want hurt you.
>> I am implementing a new schedule class for my bachelor
>> project degree at Politecnico di Milano.
>> I experienced many problems but sometimes the kernel starts.
>> The main problem is the documentation.
>> Could you explain me when sched.c calls sched_class functions (
>> enqueue_task, dequeue_task, etc... )
>> and what sched_class functions should do?
>> My reverse engineering skills don't work very well and
>> in internet there are not many information about this and
>> however they are generic and incomplete.
>>
>> I am working with version 2.6.34.
>
> There's a couple of files in Documentation/sched/ which give a high-level
> description - but some of that info is outdated. Most of the documentation is
> the code itself, as usual ;-)
>
> If you have any questions, please also Cc: lkml and Peter Zijstra
> (co-maintainer of the scheduler):
>
>  Peter Zijlstra <a.p.zijlstra@chello.nl>
>
> Thanks,
>
>        Ingo
>
