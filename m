Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012Ab1CWO6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 10:58:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48403 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932945Ab1CWO6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 10:58:53 -0400
Date: Wed, 23 Mar 2011 14:57:49 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stephen Wilson <wilsons@start.ca>
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
Message-ID: <20110323145748.GA22723@ZenIV.linux.org.uk>
References: <1300891441-16280-1-git-send-email-wilsons@start.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300891441-16280-1-git-send-email-wilsons@start.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 10:43:49AM -0400, Stephen Wilson wrote:
> Hello,
> 
> This is a resend[1] of a patch series that implements safe writes to
> /proc/pid/mem.  Such functionality is useful as it gives debuggers a simple and
> efficient mechanism to manipulate a process' address space.  Memory can be read
> and written using single calls to pread(2) and pwrite(2) instead of iteratively
> calling into ptrace(2).

It's in local queue already, along with other procfs fixes; I'm going to push
it today, with several more procfs race fixes added.
