Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab3AIIA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 03:00:29 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:43817 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757210Ab3AIIA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 03:00:27 -0500
X-AuditID: 9c93016f-b7b54ae000000e9e-35-50ed2398e2ac
From: Namhyung Kim <namhyung@kernel.org>
To: Alex Shi <alex.shi@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Mike Galbraith <efault@gmx.de>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [PATCH] sched: Get rid of unnecessary checks from select_idle_sibling
References: <1357714256-24373-1-git-send-email-namhyung@kernel.org>
	<50ED1D54.70208@intel.com> <50ED1E63.8090008@intel.com>
Date: Wed, 09 Jan 2013 17:00:23 +0900
In-Reply-To: <50ED1E63.8090008@intel.com> (Alex Shi's message of "Wed, 09 Jan
	2013 15:38:11 +0800")
Message-ID: <871udurdk8.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jan 2013 15:38:11 +0800, Alex Shi wrote:
>> 
>> Uh, we don't know if the target is this_cpu or previous cpu, If we just
>> check the target idle status, we may miss another idle cpu. So this
>> patch change the logical in this function.
>
> But, you can fold wake_affine into select_idle_sibling(). that will save
> a complicate calculation whichever cpu idle. :)

Looks like a good idea. :)  Will send v2.

Thanks,
Namhyung
