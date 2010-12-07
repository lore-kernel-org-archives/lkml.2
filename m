Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab0LGNHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 08:07:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45943 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705Ab0LGNHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 08:07:23 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=sDWRAbKr6x0A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=8gwz1naH7LiYVNwGCOYA:9 a=R-twcrxJ3Y1bpBirQThA-D9qVR8A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 03/10] workqueue: It is likely that
 WORKER_NOT_RUNNING is true
From: Steven Rostedt <rostedt@goodmis.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4CFE0346.6090904@kernel.org>
References: <20101207015834.196176991@goodmis.org>
	 <20101207021328.847976021@goodmis.org>  <4CFE0346.6090904@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 07 Dec 2010 08:07:21 -0500
Message-ID: <1291727241.16223.141.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-07 at 10:49 +0100, Tejun Heo wrote:

> > The wq_worker_sleeping() is called from schedule when a worker thread
> > is putting itself to sleep. Which happens most of the time outside
> > of that [ do work stuff ].
> 
> Yeah, I was lost thinking about the busiest case where workers are
> busy processing works consecutively.  Usually workers are of course
> switching in and out of idle state all the time.
> 
> How about just dropping likely/unlikely?

I have no problem in dropping them too. I'll do that in my next version.

Thanks,

-- Steve


