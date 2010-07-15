Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933545Ab0GOPQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 11:16:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51507 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933418Ab0GOPQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 11:16:09 -0400
X-Authority-Analysis: v=1.1 cv=kjawQlkT3vujM0lFy4b69hWxQTW3SR1XdVtFii1ut0g= c=1 sm=0 a=T3RyHyitX6oA:10 a=UBIxAjGgU1YA:10 a=IkcTkHD0fZMA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=aRz6YxriGauX9KCPEREA:9 a=sn4-GlgzWcroLFcLvr3JXo0g2BYA:4 a=QEXdDO2ut3YA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] tracing: properly align linker defined symbols
From: Steven Rostedt <rostedt@goodmis.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Zeev Tarantov <zeev.tarantov@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20100715150514.GB14073@merkur.ravnborg.org>
References: <1278705402.1537.157.camel@gandalf.stny.rr.com>
	 <20100709203301.GA13839@merkur.ravnborg.org>
	 <AANLkTinWkfkXNVA2Sx-apVQMZa-5ehugtd7JQ36np7xM@mail.gmail.com>
	 <1278721339.1537.166.camel@gandalf.stny.rr.com>
	 <20100710063459.GA14596@merkur.ravnborg.org>
	 <20100715150514.GB14073@merkur.ravnborg.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Jul 2010 11:15:59 -0400
Message-ID: <1279206959.4190.55.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-15 at 17:05 +0200, Sam Ravnborg wrote:
> On Sat, Jul 10, 2010 at 08:34:59AM +0200, Sam Ravnborg wrote:
> > Zeev - please try this replacement patch.
> > The alignmnet is increased to 32 bytes compared to my previous version and
> > we introduce alignmnet for ftrace_events too.
> > 
> > 	Sam
> 
> Steven - Zeev reported that this fixed the boot problem.
> What is next step?
> Do you forward this patch or do you prefer another fix?
> 

Hi Sam,

I'm currently at OLS (yes it still exists!) I'll test it and send off
this fix to Ingo when I get back on Monday, as I believe Linus did
prefer this one.

-- Steve


