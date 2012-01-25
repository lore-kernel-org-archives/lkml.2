Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab2AYPMt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 10:12:49 -0500
Received: from mga02.intel.com ([134.134.136.20]:5557 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994Ab2AYPMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 10:12:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="102555360"
Message-ID: <4F201BE4.6000503@linux.intel.com>
Date: Wed, 25 Jan 2012 07:12:36 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Indan Zupancic <indan@nul.nu>, Youquan Song <youquan.song@intel.com>,
        Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v1 1/2] sched: unified sched_powersavings sysfs tunable
References: <20120116161740.29759.4679.stgit@localhost>  <20120116162241.29759.13220.stgit@localhost> <1327504213.2614.78.camel@laptop>
In-Reply-To: <1327504213.2614.78.camel@laptop>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/25/2012 7:10 AM, Peter Zijlstra wrote:


btw... any reason why this feature is a config option with tons of
ifdefs... why not just have this available all the time?
it shouldn't be all that much code in the first place.

