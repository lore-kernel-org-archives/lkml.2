Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab0G0UqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 16:46:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50845 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab0G0UqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 16:46:10 -0400
Date: Tue, 27 Jul 2010 16:46:08 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] bdi: Use parent filesystem BDI for inodes not
 capable of writeback
Message-ID: <20100727204608.GA22822@infradead.org>
References: <1280250301-17603-1-git-send-email-jack@suse.cz>
 <1280250301-17603-2-git-send-email-jack@suse.cz>
 <20100727170903.GA9034@infradead.org>
 <20100727172437.GE6820@quack.suse.cz>
 <20100727172731.GA25727@infradead.org>
 <20100727180131.GG6820@quack.suse.cz>
 <20100727201207.GA16335@infradead.org>
 <20100727202129.GA28641@infradead.org>
 <20100727204407.GH6820@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100727204407.GH6820@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 10:44:07PM +0200, Jan Kara wrote:
>   Yes. So what I do in inode_to_bdi() is necessary (although I agree it
> looks a bit ugly).

Yes, seem like it.  Damn, so much for my plan of never looking at
mapping->backing_dev_info from writeback code.

