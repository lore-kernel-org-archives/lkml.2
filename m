Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759423Ab1CDNGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 08:06:46 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35861 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759261Ab1CDNGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 08:06:45 -0500
Date: Fri, 4 Mar 2011 08:06:45 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [REVIEW] NVM Express driver
Message-ID: <20110304130645.GA21454@infradead.org>
References: <20110303204749.GY3663@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303204749.GY3663@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What's the reason to make this a make_request based driver?  That loses
all the intelligence that has been put into the queueing layer, like I/O
bandwith controlling and fair scheduling.  Is it just queue_lock
contention?  If so it would be great if you could help with testing
Jens' stack-plug and request allocation scalability patches.

