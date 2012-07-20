Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab2GTIi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 04:38:56 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:45109 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab2GTIix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 04:38:53 -0400
Date: Fri, 20 Jul 2012 11:36:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        mgalbraith@novell.com, mmokrejs@fold.natur.cuni.cz
Subject: Re: [QUESTION ON BUG] the rcu stall issue could not be reproduced
Message-ID: <20120720083619.GM16348@mwanda>
References: <5008CBD4.6070907@linux.vnet.ibm.com>
 <20120720064156.GI16348@mwanda>
 <500915B9.2030104@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500915B9.2030104@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 04:24:25PM +0800, Michael Wang wrote:
> On 07/20/2012 02:41 PM, Dan Carpenter wrote:
> > My bug was fixed in March.  There was an email thread about it when
> > the merge window opened but I can't find it...
> Hi, Dan
> 
> Thanks for your reply.
> 
> Currently this issue won't appear because the
> CONFIG_RCU_CPU_STALL_TIMEOUT=60, which is big enough to avoid the
> warning info.
> 
> So is this the fix you mentioned? or someone has find out the true
> reason and fixed it?

I don't think there was an email thread on the RCU stall issue after
all.  I'm not sure what how it was fixed.

The 60 second time out would have still triggered with my bug.  It
was a complete system hang, the RCU stall message was just a
debugging hint.  I was hitting the bug every couple days reliably on
all my systems.

regards,
dan carpenter

