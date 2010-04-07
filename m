Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370Ab0DGBXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 21:23:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38093 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932411Ab0DGBXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 21:23:30 -0400
X-Authority-Analysis: v=1.1 cv=1G73JCAd+9Vhhx30tk0+Sc/rngIYAy4Ia+6Xn7XSY0k= c=1 sm=0 a=b8JJ-gGZIcIA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=z_nE5Eej0Be4saINjvMA:9 a=XrwZ1X--5_yUuQBHYPkuxSLF8owA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [patch 1/3] kernel: local_irq_{save,restore}_nmi()
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: David Miller <davem@davemloft.net>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, acme@redhat.com, paulus@samba.org,
       efault@gmx.de, fweisbec@gmail.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <20100406.181906.89249649.davem@davemloft.net>
References: <20100406132807.698467930@chello.nl>
	 <20100406133140.903644813@chello.nl>
	 <1270602790.19685.15603.camel@gandalf.stny.rr.com>
	 <20100406.181906.89249649.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 06 Apr 2010 21:23:26 -0400
Message-ID: <1270603406.19685.15609.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-06 at 18:19 -0700, David Miller wrote:

> That's the whole point, so that the problem is more easily noticed and
> it gets fixed long before I end up accidently testing the code on my
> machines :-)
> 
> To be honest, the fix is so trivial, you just need to add '_nmi' to
> the local_irq_{save,restore}() calls that warn like this.
> 
> I'm even willing to have you forward all of those reports to me and
> I'll be responsible for fixing them.
> 
> How's that? :-)

Sure.

/me sets up his procmailrc to search for the WARN_ON line in
trace_irqsoff.c and have it forward to davem.

-- Steve


