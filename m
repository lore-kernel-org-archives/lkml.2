Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab0CXCPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 22:15:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40028 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064Ab0CXCPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 22:15:14 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Starikov <ant.starikov@gmail.com>,
       Greg KH <greg@kroah.com>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bugme-new] [Bug 15618] New: 2.6.18->2.6.32->2.6.33 huge regression in performance
From: Andi Kleen <andi@firstfloor.org>
References: <bug-15618-10286@https.bugzilla.kernel.org/>
	<20100323102208.512c16cc.akpm@linux-foundation.org>
	<20100323173409.GA24845@elte.hu>
	<alpine.LFD.2.00.1003231037410.18017@i5.linux-foundation.org>
	<9D040E9A-80F2-468F-A6CD-A4912615CD3F@gmail.com>
	<alpine.LFD.2.00.1003231253570.18017@i5.linux-foundation.org>
	<9FC34DA1-D6DD-41E5-8B76-0712A813C549@gmail.com>
	<alpine.LFD.2.00.1003231602130.18017@i5.linux-foundation.org>
	<20100323233640.GA16798@elte.hu>
	<alpine.LFD.2.00.1003231653260.18017@i5.linux-foundation.org>
Date: Wed, 24 Mar 2010 03:15:12 +0100
In-Reply-To: <alpine.LFD.2.00.1003231653260.18017@i5.linux-foundation.org> (Linus Torvalds's message of "Tue, 23 Mar 2010 16:55:42 -0700 (PDT)")
Message-ID: <871vfah3db.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Wed, 24 Mar 2010, Ingo Molnar wrote:
>> 
>> We havent had any stability problems with them, except one trivial build bug, 
>> so -stable would be nice.
>
> Oh, you're right. There was that UML build bug. But I think that was 
> included in the list of commits Anton had - commit 4126faf0ab ("x86: Fix 
> breakage of UML from the changes in the rwsem system").

It would be also nice to get that change into 2.6.32 stable. That is
widely used on larger systems.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
