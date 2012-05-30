Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab2E3Le6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 07:34:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6059 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab2E3Le4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 07:34:56 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=75BMjhiLndgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=lcdBw6rLHvJ_5wa56_AA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338377694.13348.304.camel@gandalf.stny.rr.com>
Subject: Re: [RFC PATCH -tip 2/9] ftrace/x86-64: support SAVE_REGS feature
 on x86-64
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Date: Wed, 30 May 2012 07:34:54 -0400
In-Reply-To: <4FC5C09C.6030703@hitachi.com>
References: <20120529124833.9191.23007.stgit@localhost.localdomain>
	  <20120529124905.9191.91563.stgit@localhost.localdomain>
	 <1338332727.13348.301.camel@gandalf.stny.rr.com>
	 <4FC5C09C.6030703@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-30 at 15:39 +0900, Masami Hiramatsu wrote:

> BTW, that code which dynamically selects trace_caller on your
> ftrace-v2 tree, seems to be an uncompleted work. Would you
> already have done it?

I'll have to see where I left off. I'm a bit ADHD when it comes to some
of my projects. I work on them for a bit, then the next day I'll go work
on something else. Eventually all my projects get done (well, I like to
think they do ;-)

I'm currently working on a nasty bug that's in mainline when you enable
both LOCKDEP and FUNCTION_TRACING. I've been at it since Thursday (even
worked a bit over the US holiday here). I'm hoping I have a working
solution for it today. But I can't work on anything else till this is
complete.

After I get this bug fixed, I can take a look at the multi select code I
have.

Thanks,

-- Steve


