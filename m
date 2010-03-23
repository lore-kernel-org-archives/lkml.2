Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab0CXABW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 20:01:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51025 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751607Ab0CXABV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 20:01:21 -0400
Date: Tue, 23 Mar 2010 16:55:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Anton Starikov <ant.starikov@gmail.com>, Greg KH <greg@kroah.com>,
       stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bugme-new] [Bug 15618] New: 2.6.18->2.6.32->2.6.33 huge regression
 in performance
In-Reply-To: <20100323233640.GA16798@elte.hu>
Message-ID: <alpine.LFD.2.00.1003231653260.18017@i5.linux-foundation.org>
References: <bug-15618-10286@https.bugzilla.kernel.org/> <20100323102208.512c16cc.akpm@linux-foundation.org> <20100323173409.GA24845@elte.hu> <alpine.LFD.2.00.1003231037410.18017@i5.linux-foundation.org> <9D040E9A-80F2-468F-A6CD-A4912615CD3F@gmail.com>
 <alpine.LFD.2.00.1003231253570.18017@i5.linux-foundation.org> <9FC34DA1-D6DD-41E5-8B76-0712A813C549@gmail.com> <alpine.LFD.2.00.1003231602130.18017@i5.linux-foundation.org> <20100323233640.GA16798@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 24 Mar 2010, Ingo Molnar wrote:
> 
> We havent had any stability problems with them, except one trivial build bug, 
> so -stable would be nice.

Oh, you're right. There was that UML build bug. But I think that was 
included in the list of commits Anton had - commit 4126faf0ab ("x86: Fix 
breakage of UML from the changes in the rwsem system").

		Linus
