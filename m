Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576Ab0GIQDE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 12:03:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44585 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757133Ab0GIQDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 12:03:01 -0400
Date: Fri, 9 Jul 2010 12:02:52 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Eric B Munson <emunson@mgebm.net>
Cc: akpm@linux-foundation.org, mingo@redhat.com, hugh.dickins@tiscali.co.uk,
       riel@redhat.com, peterz@infradead.org, anton@samba.org,
       hch@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] Add trace point to mremap
Message-ID: <20100709160252.GA3281@infradead.org>
References: <1278690830-22145-1-git-send-email-emunson@mgebm.net>
 <1278690830-22145-2-git-send-email-emunson@mgebm.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278690830-22145-2-git-send-email-emunson@mgebm.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 09, 2010 at 04:53:50PM +0100, Eric B Munson wrote:
> This patch completes the trace point addition to the [m|mre|mun]map
> and brk functions.  These trace points will be used by a userspace
> tool that models application memory usage.

Please keep all the trace events for the mmap family of syscalls in
one subsystem identifier / header file as they're closely related.

I'd prefer to have them all in the mmap one, not mm but that's
debatable.

