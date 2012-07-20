Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab2GTB2C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 21:28:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10048 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab2GTB2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 21:28:01 -0400
X-Authority-Analysis: v=2.0 cv=IOWA+3TG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=kEgnM1vrZgIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=1XJs-Sz2x8cPrqNUI5QA:9 a=PUjeQqilurYA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1342747678.12353.84.camel@gandalf.stny.rr.com>
Subject: Re: [RFC][PATCH 2/4 v4] ftrace/x86: Add save_regs for i386 function
 calls
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Date: Thu, 19 Jul 2012 21:27:58 -0400
In-Reply-To: <50089323.6050203@zytor.com>
References: <20120711195048.885039013@goodmis.org>
	   <20120711195745.379060003@goodmis.org> <4FFEC58E.5070202@hitachi.com>
	   <1342205273.30075.19.camel@gandalf.stny.rr.com>
	   <1342627145.11900.7.camel@gandalf.stny.rr.com>
	   <50076ED9.3000100@hitachi.com>
	   <1342702344.12353.16.camel@gandalf.stny.rr.com>
	  <1342702682.12353.20.camel@gandalf.stny.rr.com>
	  <50088FD4.4060401@zytor.com>
	 <1342739063.12353.82.camel@gandalf.stny.rr.com>
	 <50089323.6050203@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-19 at 16:07 -0700, H. Peter Anvin wrote:
> On 07/19/2012 04:04 PM, Steven Rostedt wrote:
>  
> > Basically, all we want to do is add 8 to the stack pointer. And this is
> > for the x86_32 version of whatever hardware is in use.
> > 
> 
> What I'm telling you is that it depends on the context.

It doesn't really matter anyway. My questions are more academic than
practical, as I'm just sticking with addl. Quibbling over addl or lea is
pointless, as addl at least shows us what we want to actually do: add 8
to the stack pointer.

-- Steve


