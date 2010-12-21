Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933442Ab0LUBep (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 20:34:45 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:35601 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933384Ab0LUBen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 20:34:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uk5da5jck1ZvSDX9wR+dGIoIoCGGbJQYuU2NPxEQzx3Uh1FdnCPCy2dieLv+orjXAY
         jWnfHW9q9/BuClv+I7NZaHDn39yQU2fu2uUbf24mYlhdDUmTHjjJf6+XAtQoeE6bKf9m
         JYCR8h/cwyxfC9Yi8esdkI+d5XqBawHkSB0Pw=
Date: Tue, 21 Dec 2010 02:34:39 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 03/15] nohz_task: Make tick stop and restart
 callable outside idle
Message-ID: <20101221013437.GL1715@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
 <1292858662-5650-4-git-send-email-fweisbec@gmail.com>
 <1292860133.5021.7.camel@laptop>
 <1292861950.22905.26.camel@gandalf.stny.rr.com>
 <1292862311.5021.34.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292862311.5021.34.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 05:25:11PM +0100, Peter Zijlstra wrote:
> On Mon, 2010-12-20 at 11:19 -0500, Steven Rostedt wrote:
> > On Mon, 2010-12-20 at 16:48 +0100, Peter Zijlstra wrote:
> > > On Mon, 2010-12-20 at 16:24 +0100, Frederic Weisbecker wrote:
> > > > +                       if (!current->pid)
> > > 
> > > I'm not exactly sure that's the sanest way to test if you're the idle
> > > thread...
> > 
> > Would
> > 
> >  if (idle_cpu(cpu))
> > 
> > be better?
> 
> Lots ;-)

I wondered about that too, will update.

Thanks.
