Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762735Ab2FVVyH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 17:54:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51294 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab2FVVyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 17:54:05 -0400
Date: Fri, 22 Jun 2012 14:54:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "kay.sievers" <kay.sievers@vrfy.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] printk: Add printk_flush() to force buffered text to
 console
Message-Id: <20120622145402.8047a669.akpm@linux-foundation.org>
In-Reply-To: <1340322723.27036.220.camel@gandalf.stny.rr.com>
References: <1340322723.27036.220.camel@gandalf.stny.rr.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2012 19:52:03 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> But with the new printk() changes, text without a newline gets buffered
> and does not print out to the console at the location of the printk.

uh, how about we fix that?  The old behaviour was good, the new
behaviour is noxious.

Please idenfity these "new printk() changes".  Was the new noxiousness
an unavoidable effect of them?

