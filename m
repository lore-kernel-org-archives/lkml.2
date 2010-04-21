Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab0DUQ7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 12:59:39 -0400
Received: from relay2.sgi.com ([192.48.179.30]:60798 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752248Ab0DUQ7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 12:59:38 -0400
Date: Wed, 21 Apr 2010 17:59:34 +0100
From: Hedi Berriche <hedi@sgi.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/1] init: Provide a kernel start parameter to increase
	pid_max v2
Message-ID: <20100421165934.GN16427@zorg.emea.sgi.com>
References: <4BCE579C.5070100@sgi.com> <4BCE5A73.3000904@sgi.com> <20100421102350.4c222e6b@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421102350.4c222e6b@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 10:20 Alan Cox wrote:
| > of 32k will not be enough.  A system with 1664 CPU's, there are 25163 processes
| > started before the login prompt.  It's estimated that with 2048 CPU's we will pass
| 
| Is that perhaps the bug not the 32K limit?

Doubt it: I just checked on an *idle* 1664 CPUs system and I can see 26844
tasks, all but few being kernel threads.

Worst case scenario i.e. 4096 CPUs system (+ typically thousands of disks) will
most certainly pain to boot, if it ever manages to, when pid_max is set to 32K.

Cheers,
Hedi.
-- 
Be careful of reading health books, you might die of a misprint.
	-- Mark Twain
