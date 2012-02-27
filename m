Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab2B0JIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 04:08:32 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:34604 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab2B0JIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 04:08:31 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of yong.zhang0@gmail.com designates 10.224.33.66 as permitted sender) smtp.mail=yong.zhang0@gmail.com; dkim=pass header.i=yong.zhang0@gmail.com
Date: Mon, 27 Feb 2012 17:08:19 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Venki Pallipadi <venki@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Extend mwait idle to optimize away CAL and RES
 interrupts to an idle CPU -v1
Message-ID: <20120227090819.GB1112@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1329957415-15239-1-git-send-email-venki@google.com>
 <1329989454.24994.57.camel@twins>
 <CABeCy1a0U8Hk3Yfp54M-U80t2fbPrFQw=GnNQ_V082e9VxJQow@mail.gmail.com>
 <20120224054150.GA17543@zhy>
 <20120224061350.GB17543@zhy>
 <1330331881.11248.28.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1330331881.11248.28.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 09:38:01AM +0100, Peter Zijlstra wrote:
> On Fri, 2012-02-24 at 14:13 +0800, Yong Zhang wrote:
> 
> > This remind me that we should have moved the irq_enter()/irq_exit() to
> > each arch's related irq handler.
> > see: http://marc.info/?l=linux-kernel&m=130709505700821&w=2
> > 
> > So Peter, is there someone alread on it? or it still worth doing now?
> 
> trouble was that some people didn't feel comfortable adding that
> overhead to plain resched IPIs that didn't need to do anything.

Any ideas on where the plain resched IPIs come from?

Thanks,
Yong

> So I
> more or less let it sit for a while.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Only stand for myself
