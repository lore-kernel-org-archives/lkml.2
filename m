Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab1JJMIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 08:08:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55914 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab1JJMIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 08:08:15 -0400
Subject: Re: [PATCH 00/11] IO-less dirty throttling v12
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>, Greg Thelen <gthelen@google.com>,
        Minchan Kim <minchan.kim@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
        Andrea Righi <arighi@develer.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20111003134228.090592370@intel.com>
References: <20111003134228.090592370@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Oct 2011 14:14:06 +0200
Message-ID: <1318248846.14400.21.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-03 at 21:42 +0800, Wu Fengguang wrote:
> This is the minimal IO-less balance_dirty_pages() changes that are expected to
> be regression free (well, except for NFS).

I can't seem to get around reviewing these patches in detail, but fwiw
I'm fine with pushing fwd with this set (plus a possible NFS fix).

I don't see a reason to strip it down even further.

So I guess that's:

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>



