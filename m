Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916Ab0EGTGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 15:06:39 -0400
Received: from fifo99.com ([67.223.236.141]:43155 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932068Ab0EGTGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 15:06:37 -0400
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
In-Reply-To: <20100507184621.GA25978@srcf.ucam.org>
References: <20100506174331.GA29103@srcf.ucam.org>
	 <20100506183335.GE30928@atomide.com> <20100506184418.GA30669@srcf.ucam.org>
	 <20100507020541.GH30928@atomide.com> <20100507171218.GA23142@srcf.ucam.org>
	 <20100507173549.GF387@atomide.com> <20100507175025.GA23952@srcf.ucam.org>
	 <20100507180152.GH387@atomide.com> <20100507182824.GA25198@srcf.ucam.org>
	 <20100507184333.GL387@atomide.com>  <20100507184621.GA25978@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 May 2010 12:06:26 -0700
Message-ID: <1273259186.3542.93.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-07 at 19:46 +0100, Matthew Garrett wrote:
> On Fri, May 07, 2010 at 11:43:33AM -0700, Tony Lindgren wrote:
> > * Matthew Garrett <mjg@redhat.com> [100507 11:23]:
> > > On Fri, May 07, 2010 at 11:01:52AM -0700, Tony Lindgren wrote:
> > > > * Matthew Garrett <mjg@redhat.com> [100507 10:46]:
> > > > > Effective power management in the face of real-world applications is a 
> > > > > reasonable usecase.
> > > > 
> > > > Sure there's no easy solution to misbehaving apps.
> > > 
> > > That's the point of the suspend blockers.
> > 
> > To me it sounds like suspending the whole system to deal with
> > some misbehaving apps is an overkill. Sounds like kill -STOP
> > the misbehaving apps should do the trick?
> 
> Freezer cgroups would work better, but it doesn't really change the 
> point - if that application has an open network socket, how do you know 
> to resume that application when a packet comes in?

suspend blockers can get abused also .. I had my phone in my pocket and
accidentally ran "Google Talk" or something. It must have kept the
screen on or kept the phone from suspending, so the battery drained
completely over the course of an hour or so.

Daniel

