Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab2DCI2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 04:28:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:53204 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084Ab2DCI2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 04:28:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="136981246"
Message-ID: <4F7AB4AC.1060108@intel.com>
Date: Tue, 03 Apr 2012 16:28:28 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: mingo@elte.hu, andi@firstfloor.org, eranian@google.com,
        linux-kernel@vger.kernel.org, ming.m.lin@intel.com
Subject: Re: [PATCH 2/5] perf: generic intel uncore support
References: <1332916998-10628-1-git-send-email-zheng.z.yan@intel.com>  <1332916998-10628-3-git-send-email-zheng.z.yan@intel.com>  <1333163902.2960.63.camel@laptop>  <4F77C75B.4060105@intel.com> <1333404693.2960.82.camel@laptop>
In-Reply-To: <1333404693.2960.82.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2012 06:11 AM, Peter Zijlstra wrote:
> On Sun, 2012-04-01 at 11:11 +0800, Yan, Zheng wrote:
>>
>> Because using per-cpu allocation is inconvenience for PCI uncore device.
> 
> What are those, where does one read about them and why?
> 
PCI uncore device support was added by patch 4. If using per-cpu pointer,
we have to setup the per-cpu pointer after the PCI driver's probe function
recognizes the uncore device. It means we have to first add the PCI uncore
device to a list, then call a function on all cpus to scan the list, find
the right uncore device and setup the per-cpu pointer.

Regards
Yan, Zheng
