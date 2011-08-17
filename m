Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab1HQUhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 16:37:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:56750 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754173Ab1HQUhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 16:37:15 -0400
Date: Wed, 17 Aug 2011 22:35:17 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, lueckintel@yahoo.com,
        kimwooyoung@gmail.com, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <bp@alien8.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: NACK! Re: [PATCH 4/4] Add vsyscalls to
 feature-removal-schedule.txt
Message-ID: <20110817203517.GF16512@kernel.org>
References: <cover.1312899174.git.luto@mit.edu>
 <066852f3f344c1733e0db9a2427981ea1815db7d.1312899174.git.luto@mit.edu>
 <m24o1mmqr8.fsf_-_@firstfloor.org>
 <CAObL_7HCqoBT_YY+mtb7wcAAHd1pxuACp8kZ62M47KAqjzLHNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAObL_7HCqoBT_YY+mtb7wcAAHd1pxuACp8kZ62M47KAqjzLHNQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (hera.kernel.org [127.0.0.1]); Wed, 17 Aug 2011 20:36:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Lutomirski <luto@mit.edu> wrote:

> Somewhat to my surprise, fully up-to-date Fedora 15 seems to work 
> fine with vsyscall=none, and I wouldn't be terribly surprised if a 
> few of the distributions starting making it the default sooner or 
> later.  I might do a followup patch to make the switch betweeen 
> vsyscall=emulate and vsyscall=none work as a sysctl.  (Switching 
> from native to emulate at runtime could be problematic.)

As long as no binaries break (emulation is fine) it's perfectly fine 
to phase out the executable vsyscall page and keep it as a data page 
only - and we can put that into feature-removal-schedule.txt just 
fine.

Thanks,

	Ingo
