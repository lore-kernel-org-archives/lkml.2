Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030559Ab2AFTD7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 14:03:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35419 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030526Ab2AFTD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 14:03:58 -0500
Date: Fri, 6 Jan 2012 20:01:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@suse.com>
Cc: tglx@linutronix.de, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86-64: fix memset() to support sizes of 4Gb and above
Message-ID: <20120106190154.GA4164@elte.hu>
References: <4F05D992020000780006AA09@nat28.tlf.novell.com>
 <20120106110519.GA32673@elte.hu>
 <4F06F7BA020000780006ACEB@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F06F7BA020000780006ACEB@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@suse.com> wrote:

> > Would be nice to add support for arch/x86/lib/memset_64.S as 
> > well, and look at the before/after performance of it. In 
> > userspace we can do a lot more accurate measurements of this 
> > kind:
> 
> I'll see whether I can get this done, but I admit that I'm 
> entirely unfamiliar with this tool and its infrastructure. 
> [...]

Just check what it does for memcpy and duplicate it.

> [...] I hope doing this is not going to be a requirement for 
> acceptance of the patch.

No, but it would certainly help us make sure there's no 
performance side effect.

Thanks,

	Ingo
