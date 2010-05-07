Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab0EGRUz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 13:20:55 -0400
Received: from fifo99.com ([67.223.236.141]:37896 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386Ab0EGRUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 13:20:53 -0400
Subject: Re: [linux-pm] [PATCH 1/8] PM: Add suspend block api.
From: Daniel Walker <dwalker@fifo99.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Matthew Garrett <mjg@redhat.com>, Brian Swetland <swetland@google.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       mark gross <mgross@linux.intel.com>, markgross@thegnar.org,
       Len Brown <len.brown@intel.com>, linux-doc@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20100507020057.GG30928@atomide.com>
References: <Pine.LNX.4.44L0.1005051705200.1885-100000@iolanthe.rowland.org>
	 <z2ta55d774e1005051437heb584584q6afca0b4b254d5d0@mail.gmail.com>
	 <20100505234755.GI29604@atomide.com> <20100506134015.GA23426@srcf.ucam.org>
	 <20100506170151.GA30928@atomide.com> <20100506170956.GA28104@srcf.ucam.org>
	 <20100506171453.GC30928@atomide.com>
	 <1273167311.20494.13.camel@c-dwalke-linux.qualcomm.com>
	 <20100506183605.GF30928@atomide.com>
	 <1273173110.20494.19.camel@c-dwalke-linux.qualcomm.com>
	 <20100507020057.GG30928@atomide.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 May 2010 10:20:37 -0700
Message-ID: <1273252837.3542.30.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-06 at 19:00 -0700, Tony Lindgren wrote:

> Oh some SoC devices like omap hit retention or off modes in the idle loop.
> That brings down the idle consumption of a running system to minimal
> levels. It's basically the same as suspending the device in every idle loop.
> 
> The system wakes up every few seconds or so, but that already provides
> battery life of over ten days or so on an idle system. Of course the
> wakeup latencies are in milliseconds then.

MSM doesn't have those power states unfortunately .. Your kind of
suggesting what I was suggesting in that we should suspend in idle. Your
hardware can do it easier tho since your have power states that are
equal to suspend.

Daniel

