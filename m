Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab1EWJHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 05:07:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54355 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab1EWJHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 05:07:43 -0400
Date: Mon, 23 May 2011 05:07:39 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/18] writeback fixes and cleanups for 2.6.40 (v3)
Message-ID: <20110523090739.GA27894@infradead.org>
References: <20110519214530.939830917@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110519214530.939830917@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu, Andrew,

what's the plan for these for 2.6.40?  We'll need to make some progress
in this area, and even if we can't get everything it we should make sure
to at least include the updated versions of those in -mm.  But even
some of the later ones are pretty low risk.

