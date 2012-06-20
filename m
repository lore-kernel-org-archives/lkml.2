Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab2FTQf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 12:35:59 -0400
Received: from relay3.sgi.com ([192.48.152.1]:42544 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757076Ab2FTQf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 12:35:58 -0400
Date: Wed, 20 Jun 2012 11:36:08 -0500
From: Ben Myers <bpm@sgi.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Engelhardt <jengelh@inai.de>, xfs@oss.sgi.com, joe@perches.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] types.h: implement intptr_t and uintptr_t
Message-ID: <20120620163608.GA10196@sgi.com>
References: <1338487534-14575-1-git-send-email-jengelh@inai.de>
 <20120620075216.GA24798@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120620075216.GA24798@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Christoph,

On Wed, Jun 20, 2012 at 03:52:16AM -0400, Christoph Hellwig wrote:
> I'd really like to get Jans type cleanups in XFS in for the next
> merge window.  Given the lack of feedback on lkml in favor or
> against (u)intptr_t I'm tempted to add them to xfs_linux.h for now,
> and then do another push to propagate them to kernel-wide types later.
> 
> Is that fine with everybody?

That's fine with me.  But maybe there will be some feedback.  There is still
some time before the merge window.

-Ben
