Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933603Ab1D1Xlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 19:41:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55883 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932693Ab1D1Xlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 19:41:52 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=fWhlP9NuFqEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=nE8fds9vAavfEeKKWeQA:9 a=6rUcbc9chKbRg81sk1UA:7 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] trace: Add special x86 irq entry/exit tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Jiaying Zhang <jiayingz@google.com>
In-Reply-To: <1303774907-13099-1-git-send-email-vnagarnaik@google.com>
References: <1303512981-26234-1-git-send-email-vnagarnaik@google.com>
	 <1303774907-13099-1-git-send-email-vnagarnaik@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 28 Apr 2011 19:41:50 -0400
Message-ID: <1304034110.18763.218.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-25 at 16:41 -0700, Vaibhav Nagarnaik wrote:
> From: Jiaying Zhang <jiayingz@google.com>
> 
> Apart from the normal interrupts, we often also need to trace
> architecture special interrupts. The following patch adds the event
> definition and trace instrumentation for some x86 special interrupts. We
> hope the similar approach can also be used to trace special interrupts
> on other architectures. However, the patch only supports x86 at this
> point.

Again, this requires an acked-by from Ingo or Thomas.

-- Steve


