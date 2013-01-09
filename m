Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab3AIHhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 02:37:05 -0500
Received: from mga11.intel.com ([192.55.52.93]:56085 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757283Ab3AIHhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 02:37:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,435,1355126400"; 
   d="scan'208";a="274594067"
Message-ID: <50ED1E63.8090008@intel.com>
Date: Wed, 09 Jan 2013 15:38:11 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Mike Galbraith <efault@gmx.de>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [PATCH] sched: Get rid of unnecessary checks from select_idle_sibling
References: <1357714256-24373-1-git-send-email-namhyung@kernel.org> <50ED1D54.70208@intel.com>
In-Reply-To: <50ED1D54.70208@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Uh, we don't know if the target is this_cpu or previous cpu, If we just
> check the target idle status, we may miss another idle cpu. So this
> patch change the logical in this function.

But, you can fold wake_affine into select_idle_sibling(). that will save
a complicate calculation whichever cpu idle. :)

-- 
Thanks Alex
