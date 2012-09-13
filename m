Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125Ab2IMNlm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 09:41:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35211 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab2IMNlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 09:41:40 -0400
MIME-Version: 1.0
In-Reply-To: <1347524381.15764.100.camel@twins>
References: <1347509486-8688-1-git-send-email-vincent.guittot@linaro.org>
	<1347518991.6821.45.camel@marge.simpson.net>
	<1347524381.15764.100.camel@twins>
Date: Thu, 13 Sep 2012 19:41:39 +0600
Message-ID: <CADZ9YHjuQBK7obnwSGR0Z1Q85Rjvji_B0p91mbAzGd87EyNvqA@mail.gmail.com>
Subject: Re: [RFC] sched: nohz_idle_balance
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        mingo@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/13/12, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2012-09-13 at 08:49 +0200, Mike Galbraith wrote:
>> On Thu, 2012-09-13 at 06:11 +0200, Vincent Guittot wrote:
>
> Well, updating the load statistics on the cpu you're going to balance
> seems like a good end to me.. ;-) No point updating the local statistics
> N times and leaving the ones you're going to balance stale for god knows
> how long.

Don't you think this patch has a very poor subject line?

Thanks,
Rakib
