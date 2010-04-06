Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351Ab0DFTh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 15:37:26 -0400
Received: from cassarossa.samfundet.no ([129.241.93.19]:45760 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab0DFThU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 15:37:20 -0400
X-Greylist: delayed 1600 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Apr 2010 15:37:20 EDT
Date: Tue, 6 Apr 2010 21:10:23 +0200
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <bp@alien8.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux
 2.6.34-rc3)
Message-ID: <20100406191023.GE14054@uio.no>
References: <4BBB475A.7070002@redhat.com>
 <1270568096.1814.145.camel@barrios-desktop>
 <alpine.LFD.2.00.1004060841460.3487@i5.linux-foundation.org>
 <1270571019.1814.163.camel@barrios-desktop>
 <alpine.LFD.2.00.1004060926430.3487@i5.linux-foundation.org>
 <1270572327.1711.3.camel@barrios-desktop>
 <alpine.LFD.2.00.1004060951030.3487@i5.linux-foundation.org>
 <4BBB69A9.5090906@redhat.com>
 <alpine.LFD.2.00.1004061053450.3487@i5.linux-foundation.org>
 <20100406120315.53ad7390.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100406120315.53ad7390.akpm@linux-foundation.org>
X-Operating-System: Linux 2.6.29.1 on a x86_64
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 12:03:15PM -0700, Andrew Morton wrote:
>> For example, maybe some list corruption causes us to do that 
>> "anon_vma_chain_link()" _twice_ on the same avc entry. So we do that 
>> "list_add_tail(&avc->same_anon_vma, &anon_vma->head);" on an entry that 
>> already had "same_anon_vma" on one list.
> The lib/list_debug.c stuff might detect such things.  I wonder if
> either Borislav or Steinar had CONFIG_DEBUG_LIST enabled?

Not set on my kernel.

/* Steinar */
-- 
Homepage: http://www.sesse.net/
