Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933459Ab0J1N67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 09:58:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57886 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758753Ab0J1N65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 09:58:57 -0400
Date: Thu, 28 Oct 2010 09:58:55 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: fs: break out inode LRU operations from inode_lock V2
Message-ID: <20101028135855.GA13038@infradead.org>
References: <1288220538-21476-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288220538-21476-1-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 10:02:14AM +1100, Dave Chinner wrote:
> Hi Al,
> 
> The following patches break the inode LRU operations and the first
> half of iput_final() out from under the inode_lock.  The patches
> should apply to your current merge-stem tree.

The series looks good to me and survives QA so far.

