Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab0CVN5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 09:57:19 -0400
Received: from mga07.intel.com ([143.182.124.22]:29488 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754813Ab0CVN5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 09:57:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,287,1267430400"; 
   d="scan'208";a="257284588"
Message-ID: <4BA7773A.5080206@linux.intel.com>
Date: Mon, 22 Mar 2010 06:57:14 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Robert_Sch=F6ne?= <robert.schoene@tu-dresden.de>
CC: Thomas Renninger <trenn@suse.de>, Dave Jones <davej@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       cpufreq <cpufreq@vger.kernel.org>, x86@kernel.org
Subject: Re: [PATCH] trace power_frequency events on the correct cpu  (for
 Intel x86 CPUs)
References: <1268399863.3407.15.camel@localhost>	 <201003182143.22929.trenn@suse.de> <1268985679.3395.47.camel@localhost>	 <201003202237.57477.trenn@suse.de>  <4BA6BD0A.6030303@linux.intel.com> <1269241492.3485.16.camel@localhost>
In-Reply-To: <1269241492.3485.16.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/22/2010 0:04, Robert Schöne wrote:
> Am Sonntag, den 21.03.2010, 17:42 -0700 schrieb Arjan van de Ven:
>> On 3/20/2010 14:37, Thomas Renninger wrote:
>>
>>> It also seem to be (hopefully) a minor feature for timechart, so this should
>>> not hurt that much (yet).
>>
>> It's actually a major feature for timechart, and one of the key things I and a bunch of others
>> inside Intel use timechart for.
>>
> It's a major feature for us too.
> I suppose, the cpufreq_notify_transition calls are correct (meaning
> being called for all related cpus) for every driver. So there's still
> the option to include it in the POST_CHANGE section of this function.
> Could this be okay for the both of you?

post change would work... that gets frequency afaik..

>
>

