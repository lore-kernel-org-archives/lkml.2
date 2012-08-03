Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab2HCUJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 16:09:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2875 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab2HCUJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 16:09:42 -0400
X-Authority-Analysis: v=2.0 cv=StQSGYy0 c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=WuP7blGMd1gA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=pGLkceISAAAA:8 a=oCbVhmq1XZeMNOJaOzAA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1344024579.27983.115.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 1/5] code_domain: New code domain tracking susbsystem
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 03 Aug 2012 16:09:39 -0400
In-Reply-To: <20120803194536.GA2974@gmail.com>
References: <1344006145-26115-1-git-send-email-fweisbec@gmail.com>
	 <1344006145-26115-2-git-send-email-fweisbec@gmail.com>
	 <20120803194536.GA2974@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-03 at 21:45 +0200, Ingo Molnar wrote:
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Create a new subsystem that handles the probing on kernel 
> > boundaries to keep track of the transitions between code 
> > domains with two basic initial domains: user or kernel.
> 
> To do a bit more bike shed painting, I'd call it "context 
> tracking" - user mode, kernel mode (guest mode, etc.).
> 
> The term 'code domain' would bring up blank stares from most 
> kernel developers, me thinks.

Heh, that would be a second new term I heard this week for context.
Earlier, I noticed that Paul McKenney called it 'levels'. So now there's
four names:

user/kernel context
user/kernel state
user/kernel level
user/kernel domain

And we could probably add a fifth:

user/kernel mode

;-)

-- Steve


