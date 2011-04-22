Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab1DVTJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 15:09:51 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39465 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448Ab1DVTJt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 15:09:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=iuWABqs0BtBMi6WmhSZqT5Exk98Zmp0KHgesdOO54paMHPEiPidpw6jItKrKSTzqpf
         BSO7GxAo+RrzhoGJyhwxNlmMClhg2c9brfp/B3BOpLhvMBM8sWCKbb4763cd2ITHo3WD
         buPx+tWlsxE66cAxAYgcF5b9kMHWQPqwix/WQ=
MIME-Version: 1.0
In-Reply-To: <20110422134648.GB23965@elte.hu>
References: <201104222333.25546.chris@csamuel.org>
	<20110422134648.GB23965@elte.hu>
Date: Fri, 22 Apr 2011 12:09:48 -0700
X-Google-Sender-Auth: 6PDQIhe_IXGsbS87nQlGqDDcwto
Message-ID: <BANLkTin7mXkuUm=p49WJcw_PiFH5K7TsmA@mail.gmail.com>
Subject: Re: 2.6.38.3 and 2.6.39-rc4 hangs after "Booting the kernel" on quad
 Pentium Pro system
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Chris Samuel <chris@csamuel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 22, 2011 at 6:46 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Chris Samuel <chris@csamuel.org> wrote:
>
>> This box has given me good service over the past 8 years or
>> so and I'd hate to have to retire it now due to this when I
>> feel Linux should still work on it..
>>
>> Any ideas please ?
>
> Have you tried the earlyprintk=vga boot parameter yet? Maybe that shows more
> than just a silent hang ...
>
> Other than that, do you have some other box where you can build bzImages for
> this system in reasonable time? If yes then you might be able to bisect to the
> commit that broke it.

with Chris's config for 2.6.39-rc4, current tip tree says:

kernel/sched.c: In function ‘sched_init’:
kernel/sched.c:7845:28: error: ‘load_balance_tmpmask’ undeclared
(first use in this function)
kernel/sched.c:7845:28: note: each undeclared identifier is reported
only once for each function it appears in
kernel/sched.c:7845:3: warning: type defaults to ‘int’ in type name
kernel/sched.c:7845:28: warning: initialization makes pointer from
integer without a cast
kernel/sched.c:7845:3: warning: type defaults to ‘int’ in type name
