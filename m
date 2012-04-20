Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab2DTOB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 10:01:26 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:19205 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab2DTOBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 10:01:25 -0400
Date: Fri, 20 Apr 2012 17:03:48 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] tracing: Remove an unneeded check
Message-ID: <20120420140348.GQ6498@mwanda>
References: <20120420063145.GA22649@elgon.mountain>
 <1334929881.28106.77.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334929881.28106.77.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090208.4F916C27.007A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 09:51:21AM -0400, Steven Rostedt wrote:
> On Fri, 2012-04-20 at 09:31 +0300, Dan Carpenter wrote:
> > memcpy() returns a pointer to "bug".  Hopefully, it's not NULL here or
> > we would already have Oopsed.
> 
> You're right that the ret is useless, and the real bug was already fixed
> (the possibility that buf could be an invalid pointer).
> 
> Not only is this needed, but also get rid of the ret < 0 check in
> tracing_splice_read_pipe().
> 

We still return -EBUSY so we need the check.

regards,
dan carpenter

