Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab2FRBra (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 21:47:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:18329 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925Ab2FRBr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 21:47:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="158795471"
Message-ID: <4FDE88AF.3010902@intel.com>
Date: Mon, 18 Jun 2012 09:47:27 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: mingo@elte.hu, jolsa@redhat.com, eranian@google.com, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V6 08/13] perf: Add Sandy Bridge-EP uncore support
References: <1339741902-8449-1-git-send-email-zheng.z.yan@intel.com>  <1339741902-8449-9-git-send-email-zheng.z.yan@intel.com> <1339780230.2559.86.camel@twins>
In-Reply-To: <1339780230.2559.86.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2012 01:10 AM, Peter Zijlstra wrote:
> On Fri, 2012-06-15 at 14:31 +0800, Yan, Zheng wrote:
>> +static struct event_constraint snbep_uncore_r2pcie_constraints[] = {
>> +       UNCORE_EVENT_CONSTRAINT(0x10, 0x3),
>> +       UNCORE_EVENT_CONSTRAINT(0x11, 0x3),
>> +       UNCORE_EVENT_CONSTRAINT(0x12, 0x1),
>> +       UNCORE_EVENT_CONSTRAINT(0x23, 0x3),
>> +       UNCORE_EVENT_CONSTRAINT(0x24, 0x3),
>> +       UNCORE_EVENT_CONSTRAINT(0x25, 0x3),
>> +       UNCORE_EVENT_CONSTRAINT(0x26, 0x3),
>> +       UNCORE_EVENT_CONSTRAINT(0x32, 0x3),
>> +       UNCORE_EVENT_CONSTRAINT(0x33, 0x3),
>> +       UNCORE_EVENT_CONSTRAINT(0x34, 0x3),
>> +       EVENT_CONSTRAINT_END
>> +}; 
> 
> My E5-2600 Uncore Perf. Mon. Guide, March 2012 (Ref.# 327043-001)
> doesn't seem to list events 0x26 and up. 
> 
> I'm staring at 2.8.5, table 2-108.
> 
> Is my document out-dated or what's up?
> 
> the r3qpi table seems to match, but the cbox one is funny again, event
> 0x01 doesn't appear in the doc, nor does 0x3b, 0x38, 0x23.
>
Sorry, my document is out-dated. These events were listed in the old
document. should we remove them ?

> FWIW, cbox event constraint 0x1f needs to be an
> EVENT_CONSTRAINT_OVERLAP, see the comment near that macro definition.
> 
thanks for reminding

Regards
Yan, Zheng
