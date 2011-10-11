Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab1JKOzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 10:55:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58933 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab1JKOzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 10:55:11 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=pqC9jsU8ATT2jZCvhFMA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: Commits missed for stable
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg KH <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, stable <stable@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Date: Tue, 11 Oct 2011 10:55:08 -0400
In-Reply-To: <20111011142423.GB31776@suse.de>
References: <1318337139.7904.170.camel@gandalf.stny.rr.com>
	 <20111011142006.GA18281@suse.de> <20111011142331.GA31776@suse.de>
	 <20111011142423.GB31776@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1318344909.7904.180.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-11 at 08:24 -0600, Greg KH wrote:
> On Tue, Oct 11, 2011 at 08:23:31AM -0600, Greg KH wrote:
> > On Tue, Oct 11, 2011 at 08:20:06AM -0600, Greg KH wrote:
> > > On Tue, Oct 11, 2011 at 08:45:38AM -0400, Steven Rostedt wrote:
> > > > It's come to my attention that a bug that was fixed by:
> > > > 
> > > > 43dd61c9a09bd413e837df829e6bfb42159be52a
> > > > ftrace: Fix regression of :mod:module function enabling
> > 
> > Wait, that patch causes a TON of warnings to the build, so either I drop
> > it, or is there some other follow-on patch that I can apply to fix these
> > warnings?
> 
> Ah, I think I want 04da85b86188f224cc9b391b5bdd92a3ba20ffcf, right?
> 
> I'll go try that...

If it stops the warnings, you want that one :)

-- Steve


