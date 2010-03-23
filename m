Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab0CWXKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 19:10:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49891 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753390Ab0CWXKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 19:10:05 -0400
Date: Tue, 23 Mar 2010 16:04:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Anton Starikov <ant.starikov@gmail.com>, Greg KH <greg@kroah.com>,
       stable@kernel.org
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bugme-new] [Bug 15618] New: 2.6.18->2.6.32->2.6.33 huge regression
 in performance
In-Reply-To: <9FC34DA1-D6DD-41E5-8B76-0712A813C549@gmail.com>
Message-ID: <alpine.LFD.2.00.1003231602130.18017@i5.linux-foundation.org>
References: <bug-15618-10286@https.bugzilla.kernel.org/> <20100323102208.512c16cc.akpm@linux-foundation.org> <20100323173409.GA24845@elte.hu> <alpine.LFD.2.00.1003231037410.18017@i5.linux-foundation.org> <9D040E9A-80F2-468F-A6CD-A4912615CD3F@gmail.com>
 <alpine.LFD.2.00.1003231253570.18017@i5.linux-foundation.org> <9FC34DA1-D6DD-41E5-8B76-0712A813C549@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 23 Mar 2010, Anton Starikov wrote:
>
> I think we got a winner!
> 
> Problem seems to be fixed.
> 
> Just for record, I used next patches:
> 
> 59c33fa7791e9948ba467c2b83e307a0d087ab49
> 5d0b7235d83eefdafda300656e97d368afcafc9a
> 1838ef1d782f7527e6defe87e180598622d2d071
> 4126faf0ab7417fbc6eb99fb0fd407e01e9e9dfe
> bafaecd11df15ad5b1e598adc7736afcd38ee13d
> 0d1622d7f526311d87d7da2ee7dd14b73e45d3fc

Ok. If you have performance numbers for before/after these patches for 
your actual workload, I'd suggest posting them to stable@kernel.org, and 
maybe those rwsem fixes will get back-ported.

The patches are pretty small, and should be fairly safe. So they are 
certainly stable material.

		Linus
