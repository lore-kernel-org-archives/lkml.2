Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab0DFUrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 16:47:17 -0400
Received: from cassarossa.samfundet.no ([129.241.93.19]:47421 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756275Ab0DFUrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 16:47:10 -0400
Date: Tue, 6 Apr 2010 22:46:55 +0200
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux
 2.6.34-rc3)
Message-ID: <20100406204655.GG14054@uio.no>
References: <alpine.LFD.2.00.1004060841460.3487@i5.linux-foundation.org>
 <1270571019.1814.163.camel@barrios-desktop>
 <alpine.LFD.2.00.1004060926430.3487@i5.linux-foundation.org>
 <1270572327.1711.3.camel@barrios-desktop>
 <alpine.LFD.2.00.1004060951030.3487@i5.linux-foundation.org>
 <4BBB69A9.5090906@redhat.com>
 <alpine.LFD.2.00.1004061053450.3487@i5.linux-foundation.org>
 <20100406120315.53ad7390.akpm@linux-foundation.org>
 <20100406194238.GB20357@a1.tnic>
 <alpine.LFD.2.00.1004061243240.3487@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004061243240.3487@i5.linux-foundation.org>
X-Operating-System: Linux 2.6.29.1 on a x86_64
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 01:02:35PM -0700, Linus Torvalds wrote:
>    I haven't looked at the kernel config files: do they perhaps share the 
>    same (odd?) SLUB/SLAB/SLOB config?

http://storage.sesse.net/config-crashing-2.6.34-rc2

>    Did people have KSM enabled?

No KSM for me.

/* Steinar */
-- 
Homepage: http://www.sesse.net/
