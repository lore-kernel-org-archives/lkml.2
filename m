Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475Ab1EYQNM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 12:13:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:41735 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756044Ab1EYQNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 12:13:10 -0400
Date: Wed, 25 May 2011 09:12:52 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: liubo <liubo2009@cn.fujitsu.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 1/2] tracing: add __print_symbolic_u64 to avoid warnings
 on 32bit machine
Message-Id: <20110525091252.8899385e.randy.dunlap@oracle.com>
In-Reply-To: <1306326464.1465.85.camel@gandalf.stny.rr.com>
References: <4D9573DB.4010009@cn.fujitsu.com>
	<1301665762.2160.22.camel@gandalf.stny.rr.com>
	<4D9C2FF6.7090607@cn.fujitsu.com>
	<1303150309.7181.51.camel@gandalf.stny.rr.com>
	<4DACE6E0.7000507@cn.fujitsu.com>
	<4DBA8C95.4000300@cn.fujitsu.com>
	<1304264124.25414.1079.camel@gandalf.stny.rr.com>
	<4DDDE9E6.7090303@cn.fujitsu.com>
	<1306326464.1465.85.camel@gandalf.stny.rr.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090203.4DDD2A91.016D:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011 08:27:44 -0400 Steven Rostedt wrote:

> On Thu, 2011-05-26 at 01:49 -0400, liubo wrote:
> > On 05/01/2011 11:35 AM, Steven Rostedt wrote:
> > > On Fri, 2011-04-29 at 18:01 +0800, liubo wrote:
> > >> ping?
> > > 
> > > Sorry, I've been trying to get the new ftrace function tracer features
> > > out ASAP. I plan on looking at this when I'm done.
> > > 
> > > Thanks,
> > > 
> > 
> > Hi, Steven,
> > 
> > I've seen your latest git-pull, but these 2 patches are not included yet,
> > so is there any problem with them?
> 
> Actually, I was trying to get out what I had. There's a bit more patches
> that I need to process still. This being one of them.
> 
> But what I sent out previously is not going into 2.6.40 anyway. Ingo
> feels that it's too late in the merge window to pull those changes and
> wants to wait till the next merge window. Since there's some fixes in
> that pull request, I'll need to cherry pick them out and rebase the rest
> for the next window.

Sorry to hear all of that.  This fix is needed in mainline.

> I'll look at this patch soon. It's still in my queue "todo" ;)
> 
> -- Steve
> 
> > 
> > If it does, I can be helpful. :)


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
