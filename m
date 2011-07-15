Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704Ab1GORue (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:50:34 -0400
Received: from smtp-out.google.com ([74.125.121.67]:55076 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655Ab1GORua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:50:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=uy5ZjVtFYPBu3Vewn8x2dk0t8jql86QFDycnpAEV/QnQoSKVmQfkVvPPyD/ht3Hqa
	kRTW2+3gd09fquLB0mBxQ==
MIME-Version: 1.0
In-Reply-To: <1310719682.2586.289.camel@twins>
References: <1310679495-29104-1-git-send-email-vnagarnaik@google.com>
 <1310679495-29104-5-git-send-email-vnagarnaik@google.com> <20110714220233.GC26786@somewhere.redhat.com>
 <1310719682.2586.289.camel@twins>
From: David Sharp <dhsharp@google.com>
Date: Fri, 15 Jul 2011 10:50:07 -0700
Message-ID: <CAJL_ektnxUZaRJmx14H9psJ8MFBZ8iD5ET14WgT8CoJdMvH40w@mail.gmail.com>
Subject: Re: [PATCH 4/6] trace: Add tracepoints to reschedule interrupt handler
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 1:48 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Fri, 2011-07-15 at 00:02 +0200, Frederic Weisbecker wrote:
>> > This is a part of overall effort to trace all the interrupts happening
>> > in a system to figure out what time is spent in kernel space versus user
>> > space.
>
> How about you enable CONFIG_IRQ_TIME_ACCOUNTING and get all that?
>

It's not just about how long, it's when, and what other events the
interrupts are interacting with.
