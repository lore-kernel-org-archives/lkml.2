Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab2DDBrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 21:47:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:37731 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755107Ab2DDBrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 21:47:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="128428519"
Message-ID: <4F7BA82B.8060107@intel.com>
Date: Wed, 04 Apr 2012 09:47:23 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: mingo@elte.hu, andi@firstfloor.org, eranian@google.com,
        linux-kernel@vger.kernel.org, ming.m.lin@intel.com
Subject: Re: [PATCH 2/5] perf: generic intel uncore support
References: <1332916998-10628-1-git-send-email-zheng.z.yan@intel.com>  <1332916998-10628-3-git-send-email-zheng.z.yan@intel.com>  <1333163902.2960.63.camel@laptop>  <4F77C75B.4060105@intel.com>  <1333404693.2960.82.camel@laptop>  <4F7AB4AC.1060108@intel.com> <1333463364.2960.100.camel@laptop>
In-Reply-To: <1333463364.2960.100.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2012 10:29 PM, Peter Zijlstra wrote:
> On Tue, 2012-04-03 at 16:28 +0800, Yan, Zheng wrote:
>> On 04/03/2012 06:11 AM, Peter Zijlstra wrote:
>>> On Sun, 2012-04-01 at 11:11 +0800, Yan, Zheng wrote:
>>>>
>>>> Because using per-cpu allocation is inconvenience for PCI uncore device.
>>>
>>> What are those, where does one read about them and why?
>>>
>> PCI uncore device support was added by patch 4. If using per-cpu pointer,
>> we have to setup the per-cpu pointer after the PCI driver's probe function
>> recognizes the uncore device. It means we have to first add the PCI uncore
>> device to a list, then call a function on all cpus to scan the list, find
>> the right uncore device and setup the per-cpu pointer.
> 
> Yeah, I saw that, but it was all completely lacking in where one can
> find actual detail on that stuff. What parts of the SDM do I read? Is
> there anything other than the SDM, etc..
> 

I'm sorry, the SDM for SandyBridge-EP uncore doesn't release to public so far.

Regards
Yan, Zheng


