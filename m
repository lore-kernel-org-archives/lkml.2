Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab2GRPnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 11:43:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:17386 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754153Ab2GRPnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 11:43:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="179712063"
Message-ID: <5006D932.1060407@linux.intel.com>
Date: Wed, 18 Jul 2012 08:41:38 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Dan Carpenter <dan.carpenter@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: potential NULL dereference in futex_wait_requeue_pi()
References: <20120718142514.GA18850@elgon.mountain> <20120718153123.GA24408@redhat.com>
In-Reply-To: <20120718153123.GA24408@redhat.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/18/2012 08:31 AM, Dave Jones wrote:
> On Wed, Jul 18, 2012 at 05:25:14PM +0300, Dan Carpenter wrote:
>  > Hi Darren,
>  > 
>  > The patch 52400ba94675: "futex: add requeue_pi functionality" from
>  > Apr 3, 2009, leads to the following warning:
>  > kernel/futex.c:2373 futex_wait_requeue_pi()
>  > 	 error: potential NULL dereference 'pi_mutex'.
> 
> This sounds like the oops I saw that I reported at https://lkml.org/lkml/2012/7/13/328

I'm looking into the report Dave sent today (delayed from piles of
urgent issues after returning from vacation, my apologies).

Dan, under which workload are you seeing this?

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


