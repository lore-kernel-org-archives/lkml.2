Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab0EGRgz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 13:36:55 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:55168 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab0EGRgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 13:36:53 -0400
Date: Fri, 7 May 2010 18:36:21 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Daniel Walker <dwalker@fifo99.com>
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
Subject: Re: [linux-pm] [PATCH 1/8] PM: Add suspend block api.
Message-ID: <20100507173621.GA23604@srcf.ucam.org>
References: <20100505234755.GI29604@atomide.com> <20100506134015.GA23426@srcf.ucam.org> <20100506170151.GA30928@atomide.com> <20100506170956.GA28104@srcf.ucam.org> <20100506171453.GC30928@atomide.com> <1273167311.20494.13.camel@c-dwalke-linux.qualcomm.com> <20100506183605.GF30928@atomide.com> <1273173110.20494.19.camel@c-dwalke-linux.qualcomm.com> <20100507020057.GG30928@atomide.com> <1273252837.3542.30.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273252837.3542.30.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 10:20:37AM -0700, Daniel Walker wrote:

> MSM doesn't have those power states unfortunately .. Your kind of
> suggesting what I was suggesting in that we should suspend in idle. Your
> hardware can do it easier tho since your have power states that are
> equal to suspend.

If your wakeup latencies are sufficiently low and you have fine-grained 
enough control over your hardware then suspend in idle is a reasonable 
thing to do - but if you have a userspace app that's spinning then 
that doesn't solve the issue.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
