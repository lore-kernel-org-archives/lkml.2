Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab0ICW4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 18:56:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:17121 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752871Ab0ICW4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 18:56:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,315,1280732400"; 
   d="scan'208";a="603633556"
Message-ID: <4C817D0E.6020702@linux.intel.com>
Date: Fri, 03 Sep 2010 15:56:14 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.11) Gecko/20100711 Thunderbird/3.0.6
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: Ingo Molnar <mingo@elte.hu>, Jean Pihet <jean.pihet@newoldbits.com>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>,
        arjan@infradead.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing, perf: add more power related events
References: <AANLkTikvbn3+JPc7pnGZk-H4B71MHTu+-vjuzfJw_7PC@mail.gmail.com> <201009032005.08268.trenn@suse.de> <20100903195555.GA1663@elte.hu> <201009032210.08524.trenn@suse.de>
In-Reply-To: <201009032210.08524.trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/3/2010 1:10 PM, Thomas Renninger wrote:
>
>> - and check how existing tools like
>> powertop make use of such events - and sync it all up.
>>      
> Does powertop use these events?
>
>    

the next version will; I've already coded this stuff ;-)

