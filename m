Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044Ab0LUN67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 08:58:59 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:47354 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab0LUN66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 08:58:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qD8juxDcHxFCk8Yyd0sKBnGdUCokf+9JfH2e8li0hH3M4vRDiVvxaQXB+lCNMbZPQB
         yM9hyG6/LXjJfgjrgRyDSzsq0BRndifSD+3XreEeK4dlxA/47cfM4Yt6VhZHgw9zIrPE
         ziRC5ZUvDq2xA/kRaXlQfVfoWKt9yg6HA/kbg=
Date: Tue, 21 Dec 2010 14:58:52 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 02/15] nohz_task: Avoid nohz task cpu as non-idle
 timer target
Message-ID: <20101221135849.GE1750@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
 <1292858662-5650-3-git-send-email-fweisbec@gmail.com>
 <1292860078.5021.6.camel@laptop>
 <1292861202.22905.23.camel@gandalf.stny.rr.com>
 <1292861524.5021.22.camel@laptop>
 <20101221002005.GH1715@nowhere>
 <1292917902.5021.181.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292917902.5021.181.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 08:51:42AM +0100, Peter Zijlstra wrote:
> On Tue, 2010-12-21 at 01:20 +0100, Frederic Weisbecker wrote:
> > I can certainly deactivate TIMER_NOT_PINNED and make it a no-op
> > if CONFIG_NO_HZ_TASK.
> 
> Why would you want to make that a compile time switch? Dynamic is
> trivial to do.

Yep, I did not know the proc file at that time.
