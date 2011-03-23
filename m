Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933037Ab1CWPFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 11:05:10 -0400
Received: from mout.perfora.net ([74.208.4.195]:51683 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932625Ab1CWPFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 11:05:08 -0400
Date: Wed, 23 Mar 2011 11:04:06 -0400
From: Stephen Wilson <wilsons@start.ca>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>, Andi Kleen <ak@linux.intel.com>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Mackall <mpm@selenic.com>, David Rientjes <rientjes@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 resend 0/12] enable writing to /proc/pid/mem
Message-ID: <20110323150406.GA16511@fibrous.localdomain>
References: <1300891441-16280-1-git-send-email-wilsons@start.ca> <20110323145748.GA22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110323145748.GA22723@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Provags-ID: V02:K0:E+YA0Ao+r6xAB3q6cR0HjU+bkn4DG8uyzbpxMjRZ5/7
 De2GFbZlTt+mt2EtVljHS/7/etYlKNZitxNzSt9VSAUfI4HT5+
 m8fAQAHAt1rR0+wga6+jpfsYLmwTdrmhkCp2zS0ZD+7gLJcj8K
 TkmckEw5iUIbhFXyVZd9CQmf3Akpu+ibY2R6nplXWXQ/LDIQ4x
 S8o3V8XHslJsNRN7uOAGSUL03Df9JCc3574LgdylvY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 02:57:49PM +0000, Al Viro wrote:
> On Wed, Mar 23, 2011 at 10:43:49AM -0400, Stephen Wilson wrote:
> > Hello,
> > 
> > This is a resend[1] of a patch series that implements safe writes to
> > /proc/pid/mem.  Such functionality is useful as it gives debuggers a simple and
> > efficient mechanism to manipulate a process' address space.  Memory can be read
> > and written using single calls to pread(2) and pwrite(2) instead of iteratively
> > calling into ptrace(2).
> 
> It's in local queue already, along with other procfs fixes; I'm going to push
> it today, with several more procfs race fixes added.

Ah, OK.  I had no idea.  Thanks so much!


-- 
steve

