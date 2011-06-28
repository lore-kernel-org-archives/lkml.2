Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759977Ab1F1RMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 13:12:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43335 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759945Ab1F1RJu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 13:09:50 -0400
MIME-Version: 1.0
In-Reply-To: <20110628165303.010143380@goodmis.org>
References: <20110628164750.281686775@goodmis.org> <20110628165303.010143380@goodmis.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 28 Jun 2011 10:02:15 -0700
Message-ID: <BANLkTikgxKNx1eyR1m6NpVA5Ykfduzq-Mw@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm: Document handle_mm_fault()
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Gleb Natapov <gleb@redhat.com>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Michel Lespinasse <walken@google.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 9:47 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> + * Note: if @flags has FAULT_FLAG_ALLOW_RETRY set then the mmap_sem
> + *       may be released if it failed to arquire the page_lock. If the
> + *       mmap_sem is released then it will return VM_FAULT_RETRY set.
> + *       This is to keep the time mmap_sem is held when the page_lock
> + *       is taken for IO.

So I know what that flag does, but I knew it without the comment.

WITH the comment, I'm just confused. "This is to keep the time
mmap_sem is held when the page_lock is taken for IO."

Sounds like a google translation from swahili. "keep the time" what?

Maybe "keep" -> "minimize"? Or just "This is to avoid holding mmap_sem
while waiting for IO"

                        Linus
