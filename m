Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab0G0RJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 13:09:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50002 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab0G0RJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 13:09:40 -0400
Date: Tue, 27 Jul 2010 13:09:39 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] bdi: Initialize noop_backing_dev_info properly
Message-ID: <20100727170939.GB9034@infradead.org>
References: <1280250301-17603-1-git-send-email-jack@suse.cz>
 <1280250301-17603-4-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280250301-17603-4-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 07:05:01PM +0200, Jan Kara wrote:
> Properly initialize this backing dev info so that writeback code does not
> barf when getting to it e.g. via sb->s_bdi.

When do we actually get it in s_bdi?  That should never happen.

