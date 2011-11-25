Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab1KYRlY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 12:41:24 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58268 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab1KYRlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 12:41:20 -0500
Date: Fri, 25 Nov 2011 18:41:14 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v3] printk: add console output tracing
Message-ID: <20111125174108.GA23978@somewhere.redhat.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322161388.5366.54.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 08:03:08PM +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Add a printk.console trace point to record any printk
> messages into the trace, regardless of the current
> console loglevel. This can help correlate (existing)
> printk debugging with other tracing.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Thanks!

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
