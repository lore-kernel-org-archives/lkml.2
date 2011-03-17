Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab1CQWFD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 18:05:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37674 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab1CQWE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 18:04:59 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=cjxWWOd7KoAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=tZ7Su8vB0_FpT8dFUP0A:9 a=Va8U8hxkGywzCozVmEAA:7 a=fCj0QMQdWdRPvFQQ6KbPTJP12cMA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: make checkpatch warn about memset with swapped arguments.
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20110317145730.8e650401.akpm@linux-foundation.org>
References: <20110317045209.GA18656@redhat.com>
	 <20110317193645.GD14675@home.goodmis.org>
	 <20110317200215.GA4084@redhat.com>
	 <1300394224.16880.518.camel@gandalf.stny.rr.com>
	 <20110317141108.52697d81.akpm@linux-foundation.org>
	 <20110317213252.GB4084@redhat.com>
	 <20110317145730.8e650401.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 17 Mar 2011 18:04:58 -0400
Message-ID: <1300399498.16880.612.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-17 at 14:57 -0700, Andrew Morton wrote:

> I'm OK with switching from memset to bzero as the preferred way of
> clearing memory (shorter, clearer, not susceptible to the arg reversal
> bug).  Is Linus?

I suspect that a lot of memset(foo, 0, size); are before a kmalloc and
can also be replaced with kzalloc();

-- Steve


