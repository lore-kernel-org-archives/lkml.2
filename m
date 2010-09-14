Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab0INW0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 18:26:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38972 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728Ab0INW0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 18:26:13 -0400
Date: Tue, 14 Sep 2010 18:26:12 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: VFS scalability git tree
Message-ID: <20100914222612.GA23871@infradead.org>
References: <20100722190100.GA22269@amd>
 <20100730091226.GA10437@amd>
 <1280795279.3966.47.camel@localhost.localdomain>
 <20100803054400.GA7398@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100803054400.GA7398@amd>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick,

what's the plan for going ahead with the VFS scalability work?  We're
pretty late in the 2.6.36 cycle now and it would be good to get the next
batch prepared and reivew so that it can get some testing in -next.

As mentioned before my preference would be the inode lock splitup and
related patches - they are relatively simple and we're already seeing
workloads where inode_lock really hurts in the writeback code.

