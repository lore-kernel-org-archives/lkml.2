Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab1AXUkz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 15:40:55 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44241 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab1AXUkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 15:40:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wy9ARqP9H69DrO3x2JdCzJXVoyRLMp27w+ClASL6SALSqz0pAUY7C2OJJPLnlpYhLn
         Xw5HTVGnqgEmqUyEj5+7cfPbyXdUjIm9wAI33U/CpWf3F6tcFPe6cryfxvQWr+LDUYVK
         7U4EGbmr9Zo0TrJtjxnOfPxqaISvi+GtaSRuc=
Date: Mon, 24 Jan 2011 21:40:44 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Renninger <trenn@suse.de>, tardyp@gmail.com,
        jean.pihet@newoldbits.com, acme@ghostprotocols.net,
        linux-perf-users@vger.kernel.org, mathieu.desnoyers@efficios.com,
        linux-trace-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Perf ABI versioning
Message-ID: <20110124204042.GD2318@nowhere>
References: <201101241704.01021.trenn@suse.de>
 <20110124203449.GC2318@nowhere>
 <1295901543.28776.475.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295901543.28776.475.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 09:39:03PM +0100, Peter Zijlstra wrote:
> On Mon, 2011-01-24 at 21:34 +0100, Frederic Weisbecker wrote:
> > 
> > But instead of a global tracing ABI number, I would rather suggest
> > one number per tracepoint subsystem (sched, power, etc...).
> > 
> > Ideally it would be per event, but sometimes those events tend to be
> > renamed or a whole tracepoint subsystem refactored (see workqueue
> > lately). Hence it might be better per subsystem. 
> 
> What's wrong with what we have? the /format file is pretty unique to
> function as a version number of you use a hash over it.

Yeah we could in fact use it to find if fields have been added,
removed. Right, all in one that looks enough to me.
