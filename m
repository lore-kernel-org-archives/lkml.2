Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab0EGRk4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 13:40:56 -0400
Received: from fifo99.com ([67.223.236.141]:47110 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756229Ab0EGRky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 13:40:54 -0400
Subject: Re: [linux-pm] [PATCH 1/8] PM: Add suspend block api.
From: Daniel Walker <dwalker@fifo99.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Tony Lindgren <tony@atomide.com>, Brian Swetland <swetland@google.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       mark gross <mgross@linux.intel.com>, markgross@thegnar.org,
       Len Brown <len.brown@intel.com>, linux-doc@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20100507173621.GA23604@srcf.ucam.org>
References: <20100505234755.GI29604@atomide.com>
	 <20100506134015.GA23426@srcf.ucam.org> <20100506170151.GA30928@atomide.com>
	 <20100506170956.GA28104@srcf.ucam.org> <20100506171453.GC30928@atomide.com>
	 <1273167311.20494.13.camel@c-dwalke-linux.qualcomm.com>
	 <20100506183605.GF30928@atomide.com>
	 <1273173110.20494.19.camel@c-dwalke-linux.qualcomm.com>
	 <20100507020057.GG30928@atomide.com>
	 <1273252837.3542.30.camel@c-dwalke-linux.qualcomm.com>
	 <20100507173621.GA23604@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 May 2010 10:40:43 -0700
Message-ID: <1273254043.3542.37.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-07 at 18:36 +0100, Matthew Garrett wrote:
> On Fri, May 07, 2010 at 10:20:37AM -0700, Daniel Walker wrote:
> 
> > MSM doesn't have those power states unfortunately .. Your kind of
> > suggesting what I was suggesting in that we should suspend in idle. Your
> > hardware can do it easier tho since your have power states that are
> > equal to suspend.
> 
> If your wakeup latencies are sufficiently low and you have fine-grained 
> enough control over your hardware then suspend in idle is a reasonable 
> thing to do - but if you have a userspace app that's spinning then 
> that doesn't solve the issue.

If there's a userspace app spinning then you don't go idle (or that's my
assumption anyway). You mean like repeatedly blocking and unblocking
right?

Daniel


