Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab0JPAXL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 20:23:11 -0400
Received: from canuck.infradead.org ([134.117.69.58]:44111 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab0JPAXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 20:23:09 -0400
Date: Fri, 15 Oct 2010 20:23:08 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/18] fs: rework icount to be a locked variable
Message-ID: <20101016002308.GA13678@infradead.org>
References: <1286928961-15157-1-git-send-email-david@fromorbit.com>
 <1286928961-15157-8-git-send-email-david@fromorbit.com>
 <20101013113643.GD19456@infradead.org>
 <20101016001533.GL4681@dastard>
 <20101016002043.GM4681@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101016002043.GM4681@dastard>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 11:20:43AM +1100, Dave Chinner wrote:
> Oh, NAK that - hit send too soon. I forgot - they're are done that
> way because they are under the inode_lock, and iref(), at this point
> in the series, takes the inode_lock. So while it looks weird, it has
> to stay that way otherwise it deadlocks.....

Sounds fine anyway.  I was just wondering why it was done, and
the later extension of the i_lock coverage is reason enough anyway.

