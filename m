Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab1LBSFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 13:05:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59458 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066Ab1LBSF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 13:05:29 -0500
X-Authority-Analysis: v=2.0 cv=QqvcLCOd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=RlPbyBo6Jk8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=QyXUC8HyAAAA:8 a=pGLkceISAAAA:8 a=80Tajo_Xs6IX53R-FEQA:9 a=QEXdDO2ut3YA:10 a=dGJ0OcVc7YAA:10 a=MSl-tDqOz04A:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH v3] printk: add console output tracing
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20111125174108.GA23978@somewhere.redhat.com>
References: <20111117150040.GB18437@somewhere>
	 <1321543268.3997.40.camel@jlt3.sipsolutions.net>
	 <20111118184401.GA24787@somewhere.redhat.com>
	 <1321641975.10266.73.camel@jlt3.sipsolutions.net>
	 <20111118185449.GB24787@somewhere.redhat.com>
	 <1321642752.10266.75.camel@jlt3.sipsolutions.net>
	 <20111123131622.GA10669@somewhere.redhat.com>
	 <1322140919.5366.17.camel@jlt3.sipsolutions.net>
	 <20111124154519.GB18579@somewhere.redhat.com>
	 <1322161388.5366.54.camel@jlt3.sipsolutions.net>
	 <20111125174108.GA23978@somewhere.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Dec 2011 13:05:27 -0500
Message-ID: <1322849127.30977.51.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-25 at 18:41 +0100, Frederic Weisbecker wrote:
> On Thu, Nov 24, 2011 at 08:03:08PM +0100, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > Add a printk.console trace point to record any printk
> > messages into the trace, regardless of the current
> > console loglevel. This can help correlate (existing)
> > printk debugging with other tracing.
> > 
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> 
> Thanks!
> 
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Is everyone happy with this change?

Should I pull it into my queue for 3.3?

-- Steve


