Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab1JULa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 07:30:26 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:57704 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab1JULaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 07:30:25 -0400
Message-ID: <4EA157C9.30500@linux.vnet.ibm.com>
Date: Fri, 21 Oct 2011 17:00:17 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@ucw.cz, len.brown@intel.com,
        mingo@elte.hu, akpm@linux-foundation.org, suresh.b.siddha@intel.com,
        lucas.demarchi@profusion.mobi,
        "linux-pm@vger.kernel.org >> Linux PM mailing list" 
	<linux-pm@vger.kernel.org>,
        rusty@rustcorp.com.au, vatsa@linux.vnet.ibm.com, ashok.raj@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] CPU hotplug, freezer: Fix bugs in CPU hotplug call
 path
References: <4E88BF33.10407@linux.vnet.ibm.com> <1317636215.12973.16.camel@twins> <4E8B07EA.4020307@linux.vnet.ibm.com> <4E8B09F3.4080800@linux.vnet.ibm.com> <1317735440.32543.4.camel@twins> <4E8F6785.2010104@linux.vnet.ibm.com> <1318243739.14400.10.camel@laptop>
In-Reply-To: <1318243739.14400.10.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2011 04:18 PM, Peter Zijlstra wrote:
> On Sat, 2011-10-08 at 02:26 +0530, Srivatsa S. Bhat wrote:
>>
>> So, we should mutually exclude cpu hotplugging and freezing/thawing to
>> ensure that during the entire duration that the callbacks for the notified
>> event are running, the state introduced by that event holds good. 
> 
> Yes we should, but I'd rather see that done on a more fundamental level,
> and not frob yet another mutex in the already complex hotplug system.
> 

Sure, thank you for the feedback. I have now come up with another version
that doesn't introduce any new mutex. I'll post it out in a while.

-- 
Regards,
Srivatsa S. Bhat  <srivatsa.bhat@linux.vnet.ibm.com>
Linux Technology Center,
IBM India Systems and Technology Lab
