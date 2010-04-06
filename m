Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab0DFVF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 17:05:28 -0400
Received: from cassarossa.samfundet.no ([129.241.93.19]:55385 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769Ab0DFVFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 17:05:22 -0400
Date: Tue, 6 Apr 2010 23:05:11 +0200
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
Message-ID: <20100406210511.GH14054@uio.no>
References: <alpine.LFD.2.00.1004060926430.3487@i5.linux-foundation.org>
 <1270572327.1711.3.camel@barrios-desktop>
 <alpine.LFD.2.00.1004060951030.3487@i5.linux-foundation.org>
 <4BBB69A9.5090906@redhat.com>
 <alpine.LFD.2.00.1004061053450.3487@i5.linux-foundation.org>
 <20100406120315.53ad7390.akpm@linux-foundation.org>
 <20100406194238.GB20357@a1.tnic>
 <alpine.LFD.2.00.1004061243240.3487@i5.linux-foundation.org>
 <20100406204655.GG14054@uio.no>
 <alpine.LFD.2.00.1004061348110.3487@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.1004061348110.3487@i5.linux-foundation.org>
X-Operating-System: Linux 2.6.29.1 on a x86_64
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 01:56:19PM -0700, Linus Torvalds wrote:
>>>    Did people have KSM enabled?
>> No KSM for me.
> Ok, not anything odd there either, and you're not using any odd RCU setup 
> either. Nothing odd at all strikes me about your config, in fact. Lots and 
> lots of modules, but I guess it comes from some distro default config..

I think it was originally some distro config, yes, but that «config fork» was
at 2.6.16 or something...

/* Steinar */
-- 
Homepage: http://www.sesse.net/
