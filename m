Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab0KIOBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 09:01:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:44118 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab0KIOBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 09:01:23 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=9-zhcS6hyJAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=QyXUC8HyAAAA:8 a=-I8-8xu7YDJSFUgfim8A:9 a=Bjqq8lsUTDmkMWNuUz2vv7wQg_EA:4 a=PUjeQqilurYA:10 a=_pbZ7M8EQCx1uPhS:21 a=k7nObgzSAY_ejBll:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 2/4] tracing: introduce trace_set_clr_module_event
From: Steven Rostedt <rostedt@goodmis.org>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@redhat.com
In-Reply-To: <20101109135912.GB22928@localhost.localdomain>
References: <1289293967-31761-1-git-send-email-yuanhan.liu@linux.intel.com>
	 <1289293967-31761-2-git-send-email-yuanhan.liu@linux.intel.com>
	 <20101109112320.GA21828@localhost.localdomain>
	 <b9dded$h15mrt@orsmga002.jf.intel.com>
	 <20101109132058.GA22928@localhost.localdomain>
	 <0d30dc$k4dmjb@orsmga001.jf.intel.com>
	 <20101109135912.GB22928@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 09 Nov 2010 09:01:22 -0500
Message-ID: <1289311282.12418.90.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 21:59 +0800, Yuanhan Liu wrote:
> On Tue, Nov 09, 2010 at 01:31:27PM +0000, Chris Wilson wrote:
> > On Tue, 9 Nov 2010 21:20:59 +0800, Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:
> > > On Tue, Nov 09, 2010 at 11:27:18AM +0000, Chris Wilson wrote:
> > > > I've not looked closely at this yet, but it seems like we should be able
> > > > to hook into a trace_module_notify 
> > > 
> > > But there should be someplace to enable these events, right?  And how do
> > > you tell trace_module_notify to just enable one or several specific
> > > event?
> > 
> > Yes, I was thinking of extending the module loader to permit core to
> > hook into parse_args() and so the trace= facility could work with any
> > module without exporting any new functions.
> 
> Got your idea. But is it OK? 

Of course it is. It's the one that makes the most sense.

-- Steve


