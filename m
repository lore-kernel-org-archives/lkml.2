Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab2DRDuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 23:50:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398Ab2DRDuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 23:50:10 -0400
Date: Tue, 17 Apr 2012 23:50:04 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [3.4-rc3] Thread overran stack, or stack corrupted
Message-ID: <20120418035004.GA31465@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20120417172142.GA30237@redhat.com>
 <CA+55aFy-uhOgEoEBr-LkOjFQBVh14wwr-20jTrtsg_2EnuNY5g@mail.gmail.com>
 <20120417203223.GA31699@redhat.com>
 <CA+55aFzWzhxaVHuPY_oB5PVhw2Gxiwr46vyHCHEsU0o-HFikTw@mail.gmail.com>
 <20120418022705.GA23877@home.goodmis.org>
 <20120418031557.GA29828@redhat.com>
 <1334720611.28106.25.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334720611.28106.25.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 11:43:31PM -0400, Steven Rostedt wrote:
 > On Tue, 2012-04-17 at 23:15 -0400, Dave Jones wrote:
 > 
 > > That looks handy. Doesn't seem to work for me though on my test box.
 > > (config option is enabled.)
 > > 
 > > # echo 1 > /proc/sys/kernel/stack_tracer_enabled
 > > # cat /sys/kernel/debug/tracing/stack_trace
 > >         Depth    Size   Location    (-1 entries)
 > >         -----    ----   --------
 > > 
 > > That's all she wrote.
 > 
 > Hmm, was there any problems with the function tracer?
 > Messages in dmesg?

nope.

 > Just to make sure, what does
 > 
 >  /sys/kernel/debug/tracing/enabled_functions
 > 
 > have?

33503 lines.
 
 > This would show what functions the stack tracer is using.
 > 
 > I just compiled the latest vanilla kernel and tried it out, and it
 > worked for me.

works on my other machines too with similar kernel configs, just not on the one I'm profiling.

	Dave
