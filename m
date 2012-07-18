Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab2GRP50 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 11:57:26 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:31309 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab2GRP5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 11:57:24 -0400
Date: Wed, 18 Jul 2012 18:55:33 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: potential NULL dereference in futex_wait_requeue_pi()
Message-ID: <20120718155533.GF16348@mwanda>
References: <20120718142514.GA18850@elgon.mountain>
 <20120718153123.GA24408@redhat.com>
 <5006D932.1060407@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5006D932.1060407@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 08:41:38AM -0700, Darren Hart wrote:
> 
> 
> On 07/18/2012 08:31 AM, Dave Jones wrote:
> > On Wed, Jul 18, 2012 at 05:25:14PM +0300, Dan Carpenter wrote:
> >  > Hi Darren,
> >  > 
> >  > The patch 52400ba94675: "futex: add requeue_pi functionality" from
> >  > Apr 3, 2009, leads to the following warning:
> >  > kernel/futex.c:2373 futex_wait_requeue_pi()
> >  > 	 error: potential NULL dereference 'pi_mutex'.
> > 
> > This sounds like the oops I saw that I reported at https://lkml.org/lkml/2012/7/13/328
> 
> I'm looking into the report Dave sent today (delayed from piles of
> urgent issues after returning from vacation, my apologies).
> 
> Dan, under which workload are you seeing this?
> 

This was a static checker warning.  It was Dave who saw the oops
from syscall fuzzing with trinity.

regards,
dan carpenter

