Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290Ab1FUSo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 14:44:28 -0400
Received: from smtp-out.google.com ([216.239.44.51]:1367 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756783Ab1FUSo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 14:44:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=p0elObPyeYoxsHvjtSMKfnn3rzWtFkzf2FhMB8KXMJmnXWfuQAgC5N7PWxj6hb1QjN
         ug0NydUD343v6whtEb8w==
MIME-Version: 1.0
In-Reply-To: <20110616030200.GC18579@somewhere.redhat.com>
References: <1304107962-18576-1-git-send-email-vnagarnaik@google.com>
 <1306877298-31713-1-git-send-email-vnagarnaik@google.com> <20110531235957.GB5256@somewhere.redhat.com>
 <BANLkTi=YYCXHi5k82Q+sE6+134i97pjjAA@mail.gmail.com> <BANLkTinT6ULRWwHAGYFpQSw-ptQiuzrkPtZuKVZHD8b5mh9hpA@mail.gmail.com>
 <20110616030200.GC18579@somewhere.redhat.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Tue, 21 Jun 2011 11:43:54 -0700
Message-ID: <BANLkTin=9k8cMEtrvho-QkC3UgbNhcEvCP2mfh+qD1Tb+9GWVw@mail.gmail.com>
Subject: Re: [PATCH v2] trace: Add x86 irq vector entry/exit tracepoints
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Sharp <dhsharp@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiaying Zhang <jiayingz@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 8:02 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> If a generic tracepoint can replace one per arch, we all want that instead.
> This is 24 times (24 archs) less maintainance burden.
>
> So if that doesn't meet your needs, you really need to explain us in detail why.
>
> I believe it's fine to deduce from a generic timer tracepoint that the arch fired
> a specific interrupt to achieve that.

OK. We were approaching this problem by treating the IRQ vector
tracepoint as being a arch specific one since it is easier to trace it
there and every arch can add their specific instrumentation.

Anyhow, I looked through the patch and changed it to have the IRQs
traced in their generic handlers rather than the arch-specific handlers.
I may have missed a place or two where a timer IRQ vector might be
handled.

I am sending this patch out in a few minutes.


Vaibhav Nagarnaik
