Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab1GPQiw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 12:38:52 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:58131
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754973Ab1GPQiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 12:38:51 -0400
Date: Sat, 16 Jul 2011 12:38:24 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Ted Ts'o" <tytso@mit.edu>, Greg KH <gregkh@suse.de>,
        Mike Waychison <mikew@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Kconfig: Allow disabling of CONFIG_DEVPORT
Message-ID: <20110716163824.GA8536@infradead.org>
References: <1310675693-9204-1-git-send-email-mikew@google.com>
 <20110714212113.GA28639@suse.de>
 <CAGTjWtB53vW5B2EJ5=+C3buDAY0RtsfANxx5NhC5aWnmEx08EQ@mail.gmail.com>
 <20110715064147.GA1021@suse.de>
 <C70E3912-6AA9-4EB3-85CC-11BF90D230C8@mit.edu>
 <20110715145132.GA4296@suse.de>
 <20110715185519.GI8453@thunk.org>
 <20110716075600.GA17945@suse.de>
 <20110716130555.GC29946@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110716130555.GC29946@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI, back when SGI was maintained in SGI ptools, which required a bug
to check in we always had the SGI Bugworks reference, and the ptools
commit description in the commits, with none of that beeing publically
available, and no one comaplined.

Example:

commit f1ccd2955157e1aff992f6aaaba0944209076220
Author: Lachlan McIlroy <lachlan@sgi.com>
Date:   Fri Sep 26 12:16:46 2008 +1000

    [XFS] Fix extent list corruption in xfs_iext_irec_compact_full().

    If we don't move all the records from the next buffer into the current
    buffer then we need to update the er_extoff field of the next buffer as we
    shift the remaining records to the start of the buffer.

    SGI-PV: 987159

    SGI-Modid: xfs-linux-melb:xfs-kern:32165a
				        
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

