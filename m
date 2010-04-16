Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620Ab0DPQw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 12:52:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34917 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758606Ab0DPQwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 12:52:55 -0400
X-Authority-Analysis: v=1.1 cv=E9k1WvbCwWjFc1mtZtTZCb4xMnZJ3NelAETgZ6iwC6Q= c=1 sm=0 a=8-Qj6YJtbBAA:10 a=IkcTkHD0fZMA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=-ng-20whkgzMNQfB5IsA:9 a=aRyompmJXHAOm8Gb15_Tnb8kuJoA:4 a=QEXdDO2ut3YA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 3/3] Stop tracing on a schedule bug
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Chase Douglas <chase.douglas@canonical.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <20100416014937.GD15570@nowhere>
References: <1271262016-18650-1-git-send-email-chase.douglas@canonical.com>
	 <1271262016-18650-3-git-send-email-chase.douglas@canonical.com>
	 <20100415210357.GG5069@nowhere>
	 <k2u40ec3ea41004151445je53e7ef2u5c0e48e038e4efca@mail.gmail.com>
	 <alpine.LFD.2.00.1004160051390.3625@localhost.localdomain>
	 <p2n40ec3ea41004151627u11ca4d7dw46cbd6b58df9f1c8@mail.gmail.com>
	 <alpine.LFD.2.00.1004160138200.3625@localhost.localdomain>
	 <alpine.LFD.2.00.1004160204510.3625@localhost.localdomain>
	 <20100416014937.GD15570@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Apr 2010 12:41:24 -0400
Message-ID: <1271436084.1934.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-16 at 03:49 +0200, Frederic Weisbecker wrote:

> > 2) tracing off can be done via filters on functions and/or events
> >    already - so I doubt that the tracing_off_event(level) is necessary
> >    at all.
> 
> 
> 
> Yeah it works for the function tracer, but not for events (or other tracers),
> or I missed this feature somehow.

It is currently only for the function tracer. It's been on my todo list
for events for quite a while. Perhaps I'll push that up to the top of
the list next week.

-- Steve



