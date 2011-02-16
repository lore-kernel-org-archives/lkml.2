Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890Ab1BPCDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 21:03:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33603 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932871Ab1BPCDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 21:03:32 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=JHiq1QXJJuAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=E373_p38LkWbquhfQTYA:9 a=q7gSUgondfIktjOKW3atAy5sLO8A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Patch "sched: Give CPU bound RT tasks preference" has been
 added to the 2.6.32-longterm tree
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Galbraith <efault@gmx.de>
Cc: gregkh@suse.de, srostedt <srostedt@redhat.com>, a.p.zijlstra@chello.nl,
        ghaskins@novell.com, mingo@elte.hu, stable@kernel.org,
        stable-commits@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1297821667.5126.11.camel@marge.simson.net>
References: <12978046423644@kroah.org>
	 <1297810967.23343.122.camel@gandalf.stny.rr.com>
	 <1297821667.5126.11.camel@marge.simson.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 15 Feb 2011 21:03:29 -0500
Message-ID: <1297821809.23343.133.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-16 at 03:01 +0100, Mike Galbraith wrote:

> > I don't mind this patch being added to the long term tree. But I'm
> > curious about what is the criteria for adding changes to it? This is a
> > performance improvement and not a critical bug fix.
> 
> Yes, I added it for the performance.  .32-stable is enterprise beans and
> biscuits.  Same reason I added the load balancing fixes, boxen won't
> explode without them, but load balancing performs better with them.

Thanks for clarifying.

-- Steve


