Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717Ab0CWXhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 19:37:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51094 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab0CWXhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 19:37:41 -0400
Date: Wed, 24 Mar 2010 00:36:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Anton Starikov <ant.starikov@gmail.com>, Greg KH <greg@kroah.com>,
       stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bugme-new] [Bug 15618] New: 2.6.18->2.6.32->2.6.33 huge
 regression in performance
Message-ID: <20100323233640.GA16798@elte.hu>
References: <bug-15618-10286@https.bugzilla.kernel.org/>
 <20100323102208.512c16cc.akpm@linux-foundation.org>
 <20100323173409.GA24845@elte.hu>
 <alpine.LFD.2.00.1003231037410.18017@i5.linux-foundation.org>
 <9D040E9A-80F2-468F-A6CD-A4912615CD3F@gmail.com>
 <alpine.LFD.2.00.1003231253570.18017@i5.linux-foundation.org>
 <9FC34DA1-D6DD-41E5-8B76-0712A813C549@gmail.com>
 <alpine.LFD.2.00.1003231602130.18017@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003231602130.18017@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Tue, 23 Mar 2010, Anton Starikov wrote:
> >
> > I think we got a winner!
> > 
> > Problem seems to be fixed.
> > 
> > Just for record, I used next patches:
> > 
> > 59c33fa7791e9948ba467c2b83e307a0d087ab49
> > 5d0b7235d83eefdafda300656e97d368afcafc9a
> > 1838ef1d782f7527e6defe87e180598622d2d071
> > 4126faf0ab7417fbc6eb99fb0fd407e01e9e9dfe
> > bafaecd11df15ad5b1e598adc7736afcd38ee13d
> > 0d1622d7f526311d87d7da2ee7dd14b73e45d3fc
> 
> Ok. If you have performance numbers for before/after these patches for 
> your actual workload, I'd suggest posting them to stable@kernel.org, and 
> maybe those rwsem fixes will get back-ported.
> 
> The patches are pretty small, and should be fairly safe. So they are 
> certainly stable material.

We havent had any stability problems with them, except one trivial build bug, 
so -stable would be nice.

	Ingo
