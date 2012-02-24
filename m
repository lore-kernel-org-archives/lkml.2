Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab2BXIEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 03:04:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60817 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755545Ab2BXIEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 03:04:43 -0500
Date: Fri, 24 Feb 2012 09:04:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        a.p.zijlstra@chello.nl, mathieu.desnoyers@efficios.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups +
 docs
Message-ID: <20120224080423.GA814@elte.hu>
References: <1329856745.25686.72.camel@gandalf.stny.rr.com>
 <20120222073251.GB17291@elte.hu>
 <20120222075334.GA25053@elte.hu>
 <7479958c-1932-4ced-a7a4-53ac6ea3a38e@email.android.com>
 <20120222081855.GB25318@elte.hu>
 <20120222213343.GA19758@bloggs.ozlabs.ibm.com>
 <20120223100205.GD24310@elte.hu>
 <CA+55aFwwV3GsqHue8oUsx-XbvSQXSawJ0w5z=wL8ue=EH4ifzw@mail.gmail.com>
 <20120223223348.GA25513@elte.hu>
 <CA+55aFyc+C4YjfMvS5EKrL1JD4oMBLM58Zn+FfcWevNZO9vSKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyc+C4YjfMvS5EKrL1JD4oMBLM58Zn+FfcWevNZO9vSKA@mail.gmail.com>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Seriously, I don't understand why you don't just use the 
> obvious name. The data structure is named "static_key". The 
> things that change it are named "static_key_inc()" or 
> something. So a name like "static_key_true()" is simply 
> *better*, isn't it?

Yes, you are right, in hindsight it's indeed obviously and 
trivially better :-/

> It's not just about less confusion, it's actually about just 
> having consistent naming.

Okay. I sent out the slightly reworked patch that gets rid of 
this confusion and makes it all consistent.

Thanks,

	Ingo
