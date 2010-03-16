Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354Ab0CPQmZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 12:42:25 -0400
Received: from mga12.intel.com ([143.182.124.36]:10181 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752857Ab0CPQmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 12:42:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,650,1262592000"; 
   d="scan'208";a="501084968"
Message-ID: <4B9FB472.5060702@linux.intel.com>
Date: Tue, 16 Mar 2010 09:40:18 -0700
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
References: <1268399863.3407.15.camel@localhost> <201003161159.24424.trenn@suse.de> <4B9F9361.6060208@linux.intel.com> <201003161550.18102.trenn@suse.de>
In-Reply-To: <201003161550.18102.trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/16/2010 7:50, Thomas Renninger wrote:
> Still, as this is totally broken:
>     - by design ->  only one of a dozen cpufreq drivers is supported

the one I care about is supported. The others... anyone can add support for their favorite driver.


> please submit my patch and remove this again until a proper
> implementation is provided.


how about not. it works right now, and is in active use right now.
feel free to add support to other drivers if you care about those....
