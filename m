Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab2CCQMj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 11:12:39 -0500
Received: from mga11.intel.com ([192.55.52.93]:44659 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250Ab2CCQMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 11:12:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="124619141"
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Word-at-a-time dcache name accesses
References: <alpine.LFD.2.02.1203021544300.28247@i5.linux-foundation.org>
	<4F516811.8060800@zytor.com>
Date: Sat, 03 Mar 2012 08:12:42 -0800
In-Reply-To: <4F516811.8060800@zytor.com> (H. Peter Anvin's message of "Fri,
	02 Mar 2012 16:38:41 -0800")
Message-ID: <m2eht964ud.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 03/02/2012 03:46 PM, Linus Torvalds wrote:
>> 
>> Comments?
>> 
>
> My biggest concern is what happens when this happens to be at the end of
> mapped kernel memory and we overrun the page?

A long time ago (AMD K7ish) we had hardware bugs to work around in
this area. Overlapping into some PCI hole MMIO areas could cause obscure
hangs.  That is why I was always careful to not do that in any x86
library code.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
