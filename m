Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab0CWTW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 15:22:26 -0400
Received: from relay3.sgi.com ([192.48.152.1]:56230 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752061Ab0CWTWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 15:22:20 -0400
Date: Tue, 23 Mar 2010 14:22:13 -0500
From: Robin Holt <holt@sgi.com>
To: Anton Starikov <ant.starikov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org,
       bugme-daemon@bugzilla.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bugme-new] [Bug 15618] New: 2.6.18->2.6.32->2.6.33 huge
 regression in performance
Message-ID: <20100323192213.GA6169@sgi.com>
References: <bug-15618-10286@https.bugzilla.kernel.org/>
 <20100323102208.512c16cc.akpm@linux-foundation.org>
 <20100323173409.GA24845@elte.hu>
 <alpine.LFD.2.00.1003231037410.18017@i5.linux-foundation.org>
 <20100323180002.GA2965@elte.hu>
 <15090451-C292-44D6-B2BA-DCBCBEEF429D@gmail.com>
 <20100323112141.7f248f2b.akpm@linux-foundation.org>
 <41DAB29F-59B7-4D38-A389-75FAC47225BF@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41DAB29F-59B7-4D38-A389-75FAC47225BF@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 07:25:43PM +0100, Anton Starikov wrote:
> On Mar 23, 2010, at 7:21 PM, Andrew Morton wrote:
> >> I will apply this commits to 2.6.32, I afraid current OFED (which I need also) will not work on 2.6.33+.
> >> 
> > 
> > You should be able to simply set CONFIG_RWSEM_GENERIC_SPINLOCK=n,
> > CONFIG_RWSEM_XCHGADD_ALGORITHM=y by hand, as I mentioned earlier?
> 
> Hm. I tried, but when I do "make oldconfig", then it gets rewritten, so I assume that it conflicts with some other setting from default fedora kernel config. trying to figure out which one exactly.

Have you tracked this down yet?  I just got the patches applied against
an older kernel and am running into the same issue.

Thanks,
Robin
