Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab3AJPba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 10:31:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679Ab3AJPb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 10:31:29 -0500
Message-ID: <50EEDEC1.9020708@redhat.com>
Date: Thu, 10 Jan 2013 10:31:13 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: linux-kernel@vger.kernel.org, aquini@redhat.com, walken@google.com,
        eric.dumazet@gmail.com, lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>, knoel@redhat.com,
        chegu_vinod@hp.com, raghavendra.kt@linux.vnet.ibm.com,
        mingo@redhat.com
Subject: Re: [PATCH 0/5] x86,smp: make ticket spinlock proportional backoff
 w/ auto tuning
References: <20130108172632.1126898a@annuminas.surriel.com> <1357831182.5841.21.camel@marge.simpson.net>
In-Reply-To: <1357831182.5841.21.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2013 10:19 AM, Mike Galbraith wrote:
> On Tue, 2013-01-08 at 17:26 -0500, Rik van Riel wrote:
>
>> Please let me know if you manage to break this code in any way,
>> so I can fix it...
>
> I didn't break it, but did let it play with rq->lock contention.  Using
> cyclictest -Smp99 -i 100 -d 0, with 3 rt tasks for pull_rt_task() to
> pull around appears to have been a ~dead heat.

Good to hear that the code seems to be robust. It seems to
help prevent performance degradation in some workloads, and
nobody seems to have found regressions yet.

Thank you for testing.
