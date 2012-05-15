Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706Ab2EOLyx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 07:54:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757851Ab2EOLyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 07:54:52 -0400
Date: Tue, 15 May 2012 13:54:45 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, tool: Add modifiers to be part of the event name
Message-ID: <20120515115445.GB1729@m.brq.redhat.com>
References: <1336695468-5464-1-git-send-email-andi@firstfloor.org>
 <20120511102522.GA2012@m.brq.redhat.com>
 <20120514235517.GL27374@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120514235517.GL27374@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 01:55:17AM +0200, Andi Kleen wrote:
> > Please check attached patch.
> 
> Does not apply to Linus tree. I assume you want to fix it there -- 
> after all it's a regression -- so do need a patch for that.

hm, I got it cleanly applied/built in:
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

what do I miss?
jirka
