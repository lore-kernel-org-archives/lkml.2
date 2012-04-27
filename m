Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab2D0VMG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 17:12:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:25894 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab2D0VMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 17:12:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="159188102"
Message-ID: <4F9B0B9B.9020909@linux.intel.com>
Date: Fri, 27 Apr 2012 14:11:55 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: RFC: How to handle function tracing, frame pointers and -mfentry?
References: <1335552399.28106.228.camel@gandalf.stny.rr.com>  <20120427202701.GA5949@merkur.ravnborg.org>  <4F9B020B.9050205@linux.intel.com> <1335560259.28106.234.camel@gandalf.stny.rr.com>
In-Reply-To: <1335560259.28106.234.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2012 01:57 PM, Steven Rostedt wrote:
>>
>> Except it is the wrong thing.  This is not the only user of frame
>> pointer.  What I think you mean is remove the dependency in Kconfig, but
>> force the frame pointer enabled if -mfentry is not supported.
> 
> You mean option 3?
> 
> 3) Add frame pointers silently if gcc fails to build with gcc -pg.
> 

Yes, your option 3.

	-hypa

