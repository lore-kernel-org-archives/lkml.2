Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab0DUTdy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 15:33:54 -0400
Received: from relay2.sgi.com ([192.48.179.30]:52880 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755503Ab0DUTdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 15:33:53 -0400
Date: Wed, 21 Apr 2010 20:33:50 +0100
From: Hedi Berriche <hedi@sgi.com>
To: John Stoffel <john@stoffel.org>
Cc: Rik van Riel <riel@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/1] init: Provide a kernel start parameter to increase
	pid_max v2
Message-ID: <20100421193350.GU16427@zorg.emea.sgi.com>
References: <4BCE579C.5070100@sgi.com> <4BCE5A73.3000904@sgi.com> <20100421102350.4c222e6b@lxorguk.ukuu.org.uk> <20100421165934.GN16427@zorg.emea.sgi.com> <4BCF336B.1050706@redhat.com> <19407.20109.308816.104856@stoffel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19407.20109.308816.104856@stoffel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 20:15 John Stoffel wrote:
| >>>>> "Rik" == Rik van Riel <riel@redhat.com> writes:
| 
| Rik> That is 15 kernel threads per CPU.
| 
| Rik> Reducing the number of kernel threads sounds like a
| Rik> useful thing to do.
| 
| Isn't that already a project? 

Yes, thanks to Alan's probing I looked it up 

    http://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git

but we're definitely talking long term solution vs. something that can ease
pain now.

Cheers,
Hedi.
-- 
Be careful of reading health books, you might die of a misprint.
	-- Mark Twain
