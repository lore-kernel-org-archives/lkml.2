Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab1ASV4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 16:56:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754408Ab1ASV4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 16:56:37 -0500
Date: Wed, 19 Jan 2011 13:55:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH -v10 0/4] Lock-less list
Message-Id: <20110119135546.bb7e8f62.akpm@linux-foundation.org>
In-Reply-To: <1295245019-7816-1-git-send-email-ying.huang@intel.com>
References: <1295245019-7816-1-git-send-email-ying.huang@intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm trying to remember why we're talking about this.

You had an ACPI-based "hardware error reporting" thing.  And that
required an nmi-context memory allocator.  And that required a
"lockless" list implementation.

Yes?

If so, what happened to all of that?  I assume that the facilities
which this patch series adds will be used for "hardware error reporting"?
