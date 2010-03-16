Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966298Ab0CPOTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 10:19:19 -0400
Received: from mga12.intel.com ([143.182.124.36]:42261 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966283Ab0CPOTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 10:19:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,650,1262592000"; 
   d="scan'208";a="255225107"
Message-ID: <4B9F9361.6060208@linux.intel.com>
Date: Tue, 16 Mar 2010 07:19:13 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: =?ISO-8859-15?Q?Robert_Sch=F6ne?= <robert.schoene@tu-dresden.de>,
       Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       cpufreq <cpufreq@vger.kernel.org>, x86@kernel.org
Subject: Re: [PATCH] trace power_frequency events on the correct cpu  (for
 Intel x86 CPUs)
References: <1268399863.3407.15.camel@localhost> <201003151151.05741.trenn@suse.de> <1268723628.3367.16.camel@localhost> <201003161159.24424.trenn@suse.de>
In-Reply-To: <201003161159.24424.trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> But something else...:
> What exactly is the power tracer good for and what is it
> capable of which cpufreq_stats is not capable to do?

look at timechart for example.....
it's extremely useful to have this for us that do power tuning...
cpufreq_stats is nice but not nearly good enough since you only get averages,
not time behavior.
