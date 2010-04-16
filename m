Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab0DPGQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 02:16:55 -0400
Received: from smtp.nokia.com ([192.100.105.134]:61457 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab0DPGQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 02:16:54 -0400
Date: Fri, 16 Apr 2010 09:09:24 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Borislav Petkov <bp@alien8.de>,
       Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       "sgunderson@bigfoot.com" <sgunderson@bigfoot.com>
Subject: Re: [PATCH] rmap: add exclusively owned pages to the newest
 anon_vma
Message-ID: <20100416060924.GD1710@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <alpine.LFD.2.00.1004111707360.3514@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004111759440.3521@i5.linux-foundation.org>
 <20100412072056.GA2432@liondog.tnic>
 <alpine.LFD.2.00.1004120854440.26679@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004120906370.26679@i5.linux-foundation.org>
 <20100412215027.GA6263@liondog.tnic>
 <alpine.LFD.2.00.1004121508290.3647@i5.linux-foundation.org>
 <20100413093827.GA6954@liondog.tnic>
 <20100414175928.5e1bdce2@annuminas.surriel.com>
 <alpine.LFD.2.00.1004151256090.15116@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004151256090.15116@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 16 Apr 2010 06:09:43.0450 (UTC) FILETIME=[682B97A0:01CADD2B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Apr 15, 2010 at 10:01:11PM +0200, ext Linus Torvalds wrote:
>+		avc = list_entry(vma->anon_vma_chain.prev, struct anon_vma_chain, same_vma);

while at that, would it make sense to first provide list_last_entry() 
since we already have list_first_entry() ??

totally unrelated to this patch, sorry

-- 
balbi
