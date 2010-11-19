Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950Ab0KSBLj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 20:11:39 -0500
Received: from smtp-out.google.com ([216.239.44.51]:29781 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab0KSBLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 20:11:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=DSZ/uKb9tL4Bv3u1UApPu+/tAUNBP3ozPoErN1Zce2E8N9ufuPDXOEsG9ILyDJBiaq
         CALPEkmMBKVTto/mUJeg==
MIME-Version: 1.0
In-Reply-To: <1289950335.30543.8.camel@gandalf.stny.rr.com>
References: <AANLkTikfYy-kYb1=KbsYwHd0_vcf20d2nPSfFynugz8z@mail.gmail.com>
 <AANLkTikKwx6okpX4pxVzTvrVNm=KhUvLQGs0_ziwo6fX@mail.gmail.com>
 <AANLkTimnjun98phJ_KmwFG_ce3YGpmVGf5rufqPStWR-@mail.gmail.com>
 <1287013830.3673.224.camel@frodo> <AANLkTi=Y2X5EuqiCncPeNefgHs6vvGmnZpsyyddRR2g_@mail.gmail.com>
 <1289950335.30543.8.camel@gandalf.stny.rr.com>
From: Michael Rubin <mrubin@google.com>
Date: Thu, 18 Nov 2010 17:11:14 -0800
Message-ID: <AANLkTimrgXbZxQKjapXkDgYRZqdZkfe1eUdFTAu=+Q8f@mail.gmail.com>
Subject: Re: Benchmarks of kernel tracing options (ftrace and ktrace)
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 3:32 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> Mike may have been confused ;-)

I am always confused.

> I did tell him that some ring buffer improvements did make it into the
> kernel. You might want to try the latest mainline again.

You told me that you had patches (in 2.6.37) I think that would allow
us to specifically improve the syscall tracing performance.

Can you point us at em?

mrubin
