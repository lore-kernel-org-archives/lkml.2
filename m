Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab2LEHJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 02:09:10 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51044 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab2LEHJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 02:09:07 -0500
MIME-Version: 1.0
In-Reply-To: <1354542848-29638-1-git-send-email-alex.shi@intel.com>
References: <1354542848-29638-1-git-send-email-alex.shi@intel.com>
Date: Wed, 5 Dec 2012 15:09:06 +0800
Message-ID: <CAGjg+kE9dFSfnridN_5ngtuC1r5rbnkLVfyqkdTwWCE0LOG4OQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] sched: fork/exec/wake clean up
From: Alex Shi <lkml.alex@gmail.com>
To: Alex Shi <alex.shi@intel.com>
Cc: npiggin@kernel.dk, mingo@redhat.com, peterz@infradead.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 3, 2012 at 9:54 PM, Alex Shi <alex.shi@intel.com> wrote:
> This patchset try to clean up select_task_rq_fair which used for
> fork/exec/wake scheduling.
>
> With this patchset, our system NHM EX and SNB EP 4 socket machine
> has 10% hackbench performance increase.

Any comments for this patchset?
>
> Regards
> Alex
>
> [PATCH 01/4] sched: select_task_rq_fair clean up
> [PATCH 02/4] sched: fix find_idlest_group mess logical
> [PATCH 03/4] sched: don't need go to smaller sched domain
> [PATCH 04/4] sched: remove domain iterations in fork/exec/wake
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks
    Alex
