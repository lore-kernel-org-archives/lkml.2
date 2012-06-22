Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761657Ab2FVIYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 04:24:12 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33345 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761632Ab2FVIYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 04:24:09 -0400
Message-ID: <1340353448.31821.0.camel@joe2Laptop>
Subject: Re: [PATCH] printk: Add printk_flush() to force buffered text to
 console
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "kay.sievers" <kay.sievers@vrfy.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        AndrewMorton <akpm@linux-foundation.org>
Date: Fri, 22 Jun 2012 01:24:08 -0700
In-Reply-To: <1340322723.27036.220.camel@gandalf.stny.rr.com>
References: <1340322723.27036.220.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-21 at 19:52 -0400, Steven Rostedt wrote:
> Fengguang Wu had a config that caused the system to lockup. It reported:
[]

It'd have been nicer if you'd have cc'd me.

What I submitted is far simpler and it allows a knob
to control the printk buffering on a global basis.

Did you try it?  It seems to work here, but I don't
have your other patches to rcu-torture with inserted
printk_flush patches to verify it.  Can I have a
copy of those please.




