Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab1EPKnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 06:43:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40862 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118Ab1EPKnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 06:43:49 -0400
Date: Mon, 16 May 2011 06:43:39 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/17] writeback: skip balance_dirty_pages() for
 in-memory fs
Message-ID: <20110516104339.GB18520@infradead.org>
References: <20110512135706.937596128@intel.com>
 <20110512140032.160664798@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512140032.160664798@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Isn't this a fix that should go to Linus ASAP independent of the rest
of this series to fix tmpfs?

