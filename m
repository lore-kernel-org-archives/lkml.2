Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717Ab0LUPOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 10:14:40 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:58083 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab0LUPOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 10:14:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GCcFRjupdDKgXl7x5Fldr6P7B5pFjgKuZ2K0lWgTmrOxPmSYvGTs9c8NOu746febS1
         ZrAkvgvR/Qa8QHRFYQhWGAkvN5FAJZLSanYSgUh+XT7gbKvSQCw3gKhPRIN6arYprIH7
         3iE/junzDmx3hn3yGz/M2P/aw4Jx3WGvQmcD8=
Date: Tue, 21 Dec 2010 16:14:32 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 04/15] nohz_task: Stop the tick when the nohz task
 runs alone
Message-ID: <20101221151430.GK1750@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
 <1292858662-5650-5-git-send-email-fweisbec@gmail.com>
 <1292860299.5021.8.camel@laptop>
 <20101220233659.GB1715@nowhere>
 <1292916958.5021.171.camel@laptop>
 <20101221132226.GB1750@nowhere>
 <1292942079.22905.125.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292942079.22905.125.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 09:34:39AM -0500, Steven Rostedt wrote:
> On Tue, 2010-12-21 at 14:22 +0100, Frederic Weisbecker wrote:
> > On Tue, Dec 21, 2010 at 08:35:58AM +0100, Peter Zijlstra wrote:
> 
> > > No, and that worries me, you don't even seem to know what the tick does
> > > and yet you're working on stopping it.
> > 
> > Yeah, I've been focusing a lot on preemption and rcu because they seemed
> > to be the trickiest part of the thing, and I in the meantime I just forgot
> > the rest or tagged it too quickly as details to deal with later. And I
> > finally forgot them :)
> > 
> > Bah it's a first take, it can only improve ;)
> 
> Exactly!
> 
> This is an RFC, a "release early, release often" approach. And you Cc'd
> all the right people. This is not something I expect to make into 2.6.38
> though ;-)


No, even before posting I was way from expecting it for .38 ;)
