Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240Ab2BHNqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 08:46:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52382 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab2BHNqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 08:46:32 -0500
X-Authority-Analysis: v=2.0 cv=T9kOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=u3c7F3_yX9UA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=RyntE7Qo8n45HNVYxpsA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1328708789.2200.117.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH RT 0/2 v5] preempt-rt/x86: Handle sending signals from
 do_trap() by gdb
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Andi Kleen <ak@linux.intel.com>, Clark Williams <williams@redhat.com>,
        Luis Goncalves <lgoncalv@redhat.com>
Date: Wed, 08 Feb 2012 08:46:29 -0500
In-Reply-To: <20120208115754.GA30029@redhat.com>
References: <20120208005612.852040607@goodmis.org>
	 <20120208115754.GA30029@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-08 at 12:57 +0100, Oleg Nesterov wrote:
> On 02/07, Steven Rostedt wrote:
> >
> > Oleg, please take a look at the modifications I made to your patch,
> > and if you are fine with it, please ack it.
> 
> Yes, I believe the modifications are fine.

Thanks Oleg,

Thomas, can you add these to the 3.2-rt series.

-- Steve


