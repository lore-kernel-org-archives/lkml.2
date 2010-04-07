Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632Ab0DGKMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 06:12:46 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57672 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab0DGKMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 06:12:40 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux  2.6.34-rc3)
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Borislav Petkov <bp@alien8.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com,
       Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>
In-Reply-To: <y2u84144f021004070309rbfdc4980q67d95404567aed9b@mail.gmail.com>
References: <alpine.LFD.2.00.1004061707250.3487@i5.linux-foundation.org> <y2u84144f021004070309rbfdc4980q67d95404567aed9b@mail.gmail.com>
Message-Id: <20100407191108.FB87.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  7 Apr 2010 19:12:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Linus,
> 
> On Wed, Apr 7, 2010 at 3:10 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > Sounds at least possible. Way more likely than any of the "trivially
> > obvious" code being buggy, or the SLUB layer suddenly having a serious bug
> > that only the new user could trigger.
> 
> I haven't followed the discussion at all but if someone wants to
> investigate that angle more, the most likely suspect are the recent
> per-cpu changes. That said, I'd expect the problem to be more
> widespread if SLUB is to blame here.

Nope. We don't doubt SLUB nor per-cpu anymore. Rik found the bug in his patch.

thanks.



