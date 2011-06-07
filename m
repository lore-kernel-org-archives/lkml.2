Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab1FGUPh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 16:15:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755623Ab1FGUPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 16:15:36 -0400
Date: Tue, 7 Jun 2011 13:15:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org
Subject: Re: writeback merge status, was Re: [PATCH 00/18] writeback fixes
 and cleanups for 2.6.40 (v3)
Message-Id: <20110607131512.bf27eb68.akpm@linux-foundation.org>
In-Reply-To: <20110607121335.GA14080@infradead.org>
References: <20110519214530.939830917@intel.com>
	<20110523090739.GA27894@infradead.org>
	<20110523092838.GA25829@localhost>
	<20110524032859.GA17429@localhost>
	<20110601153142.0bf83332.akpm@linux-foundation.org>
	<20110602022919.GB6015@localhost>
	<20110607121335.GA14080@infradead.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jun 2011 08:13:36 -0400
Christoph Hellwig <hch@infradead.org> wrote:

> It looks like we once again got no writeback fixes merged for $NEXT,
> even with Wu having a very nice, well reviewed and tested series of 
> fairly trivial patches.

We're waiting for the v4 series:

: I'll rearrange the series and move patch 14 to the end, so that the
: patches come in order
:
: - 10 (updated) patches in -mm
: - 6 more trivial patches that is safe to go upstream after -rc1 
: - the current patch 14 and patch 16 (that depends on 14)
