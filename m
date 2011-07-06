Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab1GFJbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 05:31:53 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:49960 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab1GFJbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 05:31:52 -0400
Date: Wed, 6 Jul 2011 15:01:46 +0530
From: Ankita Garg <ankita@in.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, svaidy@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 0/5] mm,debug: VM framework to capture memory reference
 pattern
Message-ID: <20110706093146.GB19518@in.ibm.com>
Reply-To: Ankita Garg <ankita@in.ibm.com>
References: <1309854159-8277-1-git-send-email-ankita@in.ibm.com>
 <20110706020103.53ed8706.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110706020103.53ed8706.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jul 06, 2011 at 02:01:03AM -0700, Andrew Morton wrote:
> On Tue,  5 Jul 2011 13:52:34 +0530 Ankita Garg <ankita@in.ibm.com> wrote:
> 
> > 
> > This patch series is an instrumentation/debug infrastructure that captures
> > the memory reference pattern of applications (workloads). 
> 
> Can't the interfaces described in Documentation/vm/pagemap.txt be used
> for this?

The pagemap interface does not closely track the hardware reference bit
of the pages. The 'REFERENCED' flag maintained in /proc/kpageflags
only indicates if the page has been referenced since last LRU list
enqueue/requeue. So estimating the rate at which a particular page of
memory is referenced cannot be obtained. Further, it does not provide
information on the amount of kernel memory referenced on behalf of
the process.

-- 
Regards,
Ankita Garg (ankita@in.ibm.com)
Linux Technology Center
IBM India Systems & Technology Labs,
Bangalore, India
