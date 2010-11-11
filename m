Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114Ab0KKSjH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 13:39:07 -0500
Received: from mga01.intel.com ([192.55.52.88]:62627 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753712Ab0KKSjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 13:39:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,184,1288594800"; 
   d="scan'208";a="625869769"
Message-ID: <4CDC3845.4030104@linux.intel.com>
Date: Thu, 11 Nov 2010 19:39:01 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
        acme@redhat.com, eranian@google.com
Subject: Re: [PATCH 2/3] perf: Add support for extra parameters for raw events
References: <1289492117-18066-1-git-send-email-andi@firstfloor.org> <1289492117-18066-2-git-send-email-andi@firstfloor.org> <4CDC2DDD.50508@linux.vnet.ibm.com>
In-Reply-To: <4CDC2DDD.50508@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> It's not clear to me that a comma is the best character to use in this 
> instance, because multiple events can be listed after the -e separated 
> by commas as well, for example:  -e rXXXX,cycles.
> -e rXXXX,YYYY,cycles would be confusing to read.
>
> How about -e rXXXX[+YYYY]

That's a good point. The comma seems to work in my testing though for 
some reason, but I guess
I broke the multiple events case then. I'll switch over to +

-Andi

