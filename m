Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933217Ab1LFK0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:26:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933137Ab1LFK0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:26:22 -0500
Date: Tue, 6 Dec 2011 11:26:23 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] mm,x86: initialize high mem before free_all_bootmem()
Message-ID: <20111206102622.GC3105@redhat.com>
References: <1322582711-14571-1-git-send-email-sgruszka@redhat.com>
 <20111205110656.GA22259@elte.hu>
 <20111205150019.GA5434@redhat.com>
 <20111205155434.GD30287@elte.hu>
 <20111206075530.GA3105@redhat.com>
 <20111206080833.GB3105@redhat.com>
 <20111206082555.GA28314@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206082555.GA28314@elte.hu>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 09:25:55AM +0100, Ingo Molnar wrote:
> The thing is, the pagealloc bug you fixed basically kept 
> pagealloc debugging essentially disabled for a really long time, 
> correct?
Yes, it worked only in special cases.
 
> So i'd expect there to be quite a few latent problems - 
> i'll give it some more testing before pushing out the result.
Ehh, I expect them too, but fortunately only with CONFIG_DEBUG_PAGEALLOC,
non-debug kernel are not affected.

Thanks
Stanislaw 
