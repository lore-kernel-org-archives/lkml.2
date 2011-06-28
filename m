Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759943Ab1F1RZh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 13:25:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35381 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100Ab1F1RWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 13:22:10 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=zgHg_0SvolMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=GbAfmPTXV3RS_HMMXYkA:9 a=qhbCNLylPjER_c_1xJoA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 2/2] mm: Document handle_mm_fault()
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Gleb Natapov <gleb@redhat.com>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Michel Lespinasse <walken@google.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
In-Reply-To: <BANLkTikgxKNx1eyR1m6NpVA5Ykfduzq-Mw@mail.gmail.com>
References: <20110628164750.281686775@goodmis.org>
	 <20110628165303.010143380@goodmis.org>
	 <BANLkTikgxKNx1eyR1m6NpVA5Ykfduzq-Mw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 28 Jun 2011 13:22:09 -0400
Message-ID: <1309281729.26417.14.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-28 at 10:02 -0700, Linus Torvalds wrote:
> On Tue, Jun 28, 2011 at 9:47 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > + * Note: if @flags has FAULT_FLAG_ALLOW_RETRY set then the mmap_sem
> > + *       may be released if it failed to arquire the page_lock. If the
> > + *       mmap_sem is released then it will return VM_FAULT_RETRY set.
> > + *       This is to keep the time mmap_sem is held when the page_lock
> > + *       is taken for IO.
> 
> So I know what that flag does, but I knew it without the comment.
> 
> WITH the comment, I'm just confused. "This is to keep the time
> mmap_sem is held when the page_lock is taken for IO."
> 
> Sounds like a google translation from swahili. "keep the time" what?

"When people ask me what language is my mother tongue, I simply reply C"

Google translate from C -> english is worse than swahily -> english :p

> 
> Maybe "keep" -> "minimize"? Or just "This is to avoid holding mmap_sem
> while waiting for IO"

OK, that sounds better. Thanks.

I'll go to cut a v2, but I'll wait a day or so for others to comment.

-- Steve


