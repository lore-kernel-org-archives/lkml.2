Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab1CYTiD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 15:38:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136Ab1CYTiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 15:38:01 -0400
Subject: Re: [tip:core/urgent] WARN_ON_SMP(): Allow use in if() statements
 on UP
From: Steven Rostedt <srostedt@redhat.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, dvhart@linux.intel.com,
        peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de,
        laijs@cn.fujitsu.com, mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <20110325193128.GA5839@p183.telecom.by>
References: <20110317192208.444147791@goodmis.org>
	 <tip-2092e6be82ec71ecbf5a8ceeef004bbcbdb78812@git.kernel.org>
	 <AANLkTikfq9bz_cKdvq9ab+KS218Q7uVvoNdJeMe_-RUg@mail.gmail.com>
	 <1301076981.14261.197.camel@gandalf.stny.rr.com>
	 <1301077163.14261.199.camel@gandalf.stny.rr.com>
	 <20110325193128.GA5839@p183.telecom.by>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Fri, 25 Mar 2011 15:36:57 -0400
Message-ID: <1301081817.27473.4.camel@fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-25 at 21:31 +0200, Alexey Dobriyan wrote:

> Try ((void)0)

But then if ((void)0) wont work.

-- Steve



