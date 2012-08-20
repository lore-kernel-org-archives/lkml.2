Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab2HTQ0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 12:26:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663Ab2HTQ0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 12:26:36 -0400
Date: Mon, 20 Aug 2012 18:23:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt <rostedt@goodmis.org>,
        dhowells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: lockdep trace from posix timers
Message-ID: <20120820162302.GA22354@redhat.com>
References: <1345140478.29668.54.camel@twins> <20120817151447.GA7918@redhat.com> <1345446957.23018.14.camel@twins> <1345463081.23018.34.camel@twins> <20120820150507.GC18499@redhat.com> <1345475530.23018.50.camel@twins> <20120820154154.GB20258@redhat.com> <1345478211.23018.69.camel@twins> <20120820161012.GC21400@redhat.com> <1345479590.23018.75.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345479590.23018.75.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20, Peter Zijlstra wrote:
>
> Anyway, would taking ->pi_lock over _cancel and _run suffice?

I thinks yes... But I can't think properly today.

Oleg.

