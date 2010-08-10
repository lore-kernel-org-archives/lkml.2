Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137Ab0HJXYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 19:24:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:44167 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757938Ab0HJXY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 19:24:27 -0400
Subject: Re: [REVISED PULL REQUEST] md updates for 2.6.36
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com
In-Reply-To: <AANLkTinbCHAB3tPos1sp078maWaHAQbRM8oWMOiF1U8D@mail.gmail.com>
References: <19552.39399.490494.51990@notabene.brown>
	 <AANLkTinbCHAB3tPos1sp078maWaHAQbRM8oWMOiF1U8D@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Aug 2010 00:23:31 +0100
Message-ID: <1281482611.5887.38.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.6 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-10 at 15:47 -0700, Linus Torvalds wrote:
> 
> Hmm. Why "lib/raid6/raid6sse2.c" and friends? Why "raid6" twice? You
> don't mean "raid6+1" (mirrored raid6 ;), so why not just remove the
> second "raid6", and call it "lib/raid6/sse2.c"
> 
> But I pulled. Just in case there was some logic to the duplication. 

No particular reason -- I just wanted the initial move to be as simple
as possible. Since it all gets built into raid6_pq.ko and we never see
these filenames even in module names, it does make sense to rename them.

If Neil approves, git://git.infradead.org/~dwmw2/libraid-2.6.git

The userspace test/ (neé raid6test/) directory doesn't build, but it
didn't before. At least I fixed the awk incantations.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

