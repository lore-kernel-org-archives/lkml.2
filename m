Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab0ESOoV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 10:44:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37513 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab0ESOoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 10:44:20 -0400
X-Authority-Analysis: v=1.1 cv=ThiPuEJrAfM5PTlEgIT3cJp8+3pkHBIG3CaogqDGxqo= c=1 sm=0 a=pjGjkNHRNmAA:10 a=0qYQvVkOOIcA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=rVFi2vXHS02sp9KjV5gA:9 a=NgsPNFqvbhenuB1Dg8jO5sBi4r8A:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: collecting static data related to tracing
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100519072838.GD5704@nowhere>
References: <1274191742.31554.10.camel@jlt3.sipsolutions.net>
	 <1274193698.26328.746.camel@gandalf.stny.rr.com>
	 <1274193909.31554.12.camel@jlt3.sipsolutions.net>
	 <20100519072838.GD5704@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 19 May 2010 10:44:17 -0400
Message-ID: <1274280257.26328.767.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 09:28 +0200, Frederic Weisbecker wrote:
> On Tue, May 18, 2010 at 04:45:09PM +0200, Johannes Berg wrote:

> This is a place where events injection might be suitable perhaps.
> Either kernel or user space event injection.
> 
> kernel space injection would be a simple trace event declared that
> have a callback called when it gets enabled. This callback would
> inject any events it wants.
> 
> userspace injection could be a bit different, the user can inject
> its own format and events content toward a debugfs or whatever file.
> This would be suitable if userspace have few things to inject,
> otherwise we would need to think about something else perhaps.
> 

The userspace injection actually sounds like a good idea. I don't think
it needs to tell the kernel about it. Since it is running the trace.
Perhaps just have a way that the userspace can add its own events to the
recording file.

I guess this would be closer to what LTTng does with channels.

That is, you could have a separate recording stream to write events that
tell the tracer what is happening. It would be nice to have a way that
userspace can read the trace clock timer though.

-- Steve


