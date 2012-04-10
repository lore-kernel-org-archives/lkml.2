Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab2DJIMB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 04:12:01 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33891 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab2DJIL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 04:11:58 -0400
Message-ID: <4F83EB49.3050100@gmail.com>
Date: Tue, 10 Apr 2012 10:11:53 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Hillf Danton <dhillf@gmail.com>
CC: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, Fabio Checconi <fchecconi@gmail.com>,
        Tommaso Cucinotta <tommaso.cucinotta@sssup.it>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <luca.abeni@unitn.it>,
        Dhaval Giani <dhaval.giani@gmail.com>, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, Dario Faggioli <raistlin@linux.it>,
        Insop Song <insop.song@ericsson.com>, liming.wang@windriver.com
Subject: Re: [PATCH 06/16] sched: SCHED_DEADLINE push and pull logic
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com> <1333696481-3433-7-git-send-email-juri.lelli@gmail.com> <CAJd=RBBm8yDBrZFj48tP_5WsG=z0Rsv_=j=kArV1Mj6yJvQjVA@mail.gmail.com> <4F7F285A.1010703@gmail.com> <CAJd=RBC13JUuX0gtQidpNc=T+pnPgtKVQwRsP-mPQeiyfd9fPA@mail.gmail.com> <4F81F2F1.8010105@gmail.com> <CAJd=RBBDbqD5UwDwBsu9zMA2P4V2-m+v4QTN0An7KCSZZ=z+-A@mail.gmail.com>
In-Reply-To: <CAJd=RBBDbqD5UwDwBsu9zMA2P4V2-m+v4QTN0An7KCSZZ=z+-A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2012 02:28 PM, Hillf Danton wrote:
> On Mon, Apr 9, 2012 at 4:20 AM, Juri Lelli<juri.lelli@gmail.com>  wrote:
>>
>> Do you mean at kernel_init time?
>> Could you be more precise about the problem Steven encountered?
>>
> After change from kernel/sched_rt.c to kernel/sched/rt.c, I could not
> find the git history of that fix, related to RCU IIRC, by Steven in mainline.
> Steven, please give a link.
>

Ok, found!
https://lkml.org/lkml/2011/6/14/366
  
>>
>> Here we go:
>> https://github.com/downloads/jlelli/sched-deadline/sched-dl-V4.patch
>>
> Thanks:)
>
>> I noticed that the Cc list is changed... something went wrong?
>>
> I forget what was changed, simply because the mail agent beeps that
> one mail address is not reachable.
>
> -hd

Thanks and Regards,

- Juri
