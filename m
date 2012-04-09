Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125Ab2DIM2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 08:28:22 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53318 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab2DIM2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 08:28:20 -0400
MIME-Version: 1.0
In-Reply-To: <4F81F2F1.8010105@gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	<1333696481-3433-7-git-send-email-juri.lelli@gmail.com>
	<CAJd=RBBm8yDBrZFj48tP_5WsG=z0Rsv_=j=kArV1Mj6yJvQjVA@mail.gmail.com>
	<4F7F285A.1010703@gmail.com>
	<CAJd=RBC13JUuX0gtQidpNc=T+pnPgtKVQwRsP-mPQeiyfd9fPA@mail.gmail.com>
	<4F81F2F1.8010105@gmail.com>
Date: Mon, 9 Apr 2012 20:28:16 +0800
Message-ID: <CAJd=RBBDbqD5UwDwBsu9zMA2P4V2-m+v4QTN0An7KCSZZ=z+-A@mail.gmail.com>
Subject: Re: [PATCH 06/16] sched: SCHED_DEADLINE push and pull logic
From: Hillf Danton <dhillf@gmail.com>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 9, 2012 at 4:20 AM, Juri Lelli <juri.lelli@gmail.com> wrote:
>
> Do you mean at kernel_init time?
> Could you be more precise about the problem Steven encountered?
>
After change from kernel/sched_rt.c to kernel/sched/rt.c, I could not
find the git history of that fix, related to RCU IIRC, by Steven in mainline.
Steven, please give a link.

>
> Here we go:
> https://github.com/downloads/jlelli/sched-deadline/sched-dl-V4.patch
>
Thanks:)

> I noticed that the Cc list is changed... something went wrong?
>
I forget what was changed, simply because the mail agent beeps that
one mail address is not reachable.

-hd
