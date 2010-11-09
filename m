Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab0KIN6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 08:58:55 -0500
Received: from mga14.intel.com ([143.182.124.37]:44949 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab0KIN6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 08:58:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,174,1288594800"; 
   d="scan'208";a="346432925"
Date: Tue, 9 Nov 2010 21:59:12 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com
Subject: Re: [PATCH 2/4] tracing: introduce trace_set_clr_module_event
Message-ID: <20101109135912.GB22928@localhost.localdomain>
References: <1289293967-31761-1-git-send-email-yuanhan.liu@linux.intel.com>
 <1289293967-31761-2-git-send-email-yuanhan.liu@linux.intel.com>
 <20101109112320.GA21828@localhost.localdomain>
 <b9dded$h15mrt@orsmga002.jf.intel.com>
 <20101109132058.GA22928@localhost.localdomain>
 <0d30dc$k4dmjb@orsmga001.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d30dc$k4dmjb@orsmga001.jf.intel.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 01:31:27PM +0000, Chris Wilson wrote:
> On Tue, 9 Nov 2010 21:20:59 +0800, Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:
> > On Tue, Nov 09, 2010 at 11:27:18AM +0000, Chris Wilson wrote:
> > > I've not looked closely at this yet, but it seems like we should be able
> > > to hook into a trace_module_notify 
> > 
> > But there should be someplace to enable these events, right?  And how do
> > you tell trace_module_notify to just enable one or several specific
> > event?
> 
> Yes, I was thinking of extending the module loader to permit core to
> hook into parse_args() and so the trace= facility could work with any
> module without exporting any new functions.

Got your idea. But is it OK? 

Thanks.

--
Yuanhan Liu

