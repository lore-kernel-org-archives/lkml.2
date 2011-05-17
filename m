Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab1EQHcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 03:32:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:31552 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572Ab1EQHcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 03:32:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,224,1304319600"; 
   d="scan'208";a="643661508"
Message-ID: <4DD22480.7090309@intel.com>
Date: Tue, 17 May 2011 15:32:16 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110402 Iceowl/1.0b2 Icedove/3.1.9
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: huang ying <huang.ying.caritas@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Don Zickus <dzickus@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC] x86, NMI, Treat unknown NMI as hardware error
References: <1305275018-20596-1-git-send-email-ying.huang@intel.com>	<4DCD4B85.3040702@gmail.com>	<BANLkTin7LNo0dDLs-Rz6WqCQ9RvS=MLXcw@mail.gmail.com>	<4DCE3493.4090404@gmail.com> <BANLkTin1pvdnXtw53MhwfCsEQpsu0TUUmg@mail.gmail.com> <4DCF7413.4070704@gmail.com> <4DD07959.4030608@intel.com> <4DD17EAF.4040305@gmail.com>
In-Reply-To: <4DD17EAF.4040305@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2011 03:44 AM, Cyrill Gorcunov wrote:
> On 05/16/2011 05:09 AM, Huang Ying wrote:
> ...
>>>
>>>   I'm personally fine even if it's enabled by default, only worried to have
>>> an option to disable hwerr from boot line.
>>
>> The white list mechanism is not sufficient?  Spurious unknown NMI can
>> occur on white list machines?  People don't want to protect their data?
>>
> 
>   I suppose no, it's not sufficient considering how many cpu errata already
> out in general. And I see no guarantee that unknown NMIs never triggers on
> white list machines and I know that you know that as well ;)

I write this patch because I believe white listed machines will not
generate unknown NMI for no good reason ;)

If we just want to push the unknown NMI logic to user space, existing
"unknown_nmi_panic" is sufficient.

Best Regards,
Huang Ying
