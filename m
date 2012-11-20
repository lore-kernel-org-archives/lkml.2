Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab2KTQgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 11:36:36 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:51801
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751804Ab2KTQge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 11:36:34 -0500
Date: Tue, 20 Nov 2012 11:36:31 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: torvalds@linux-foundation.org, tytso@mit.edu, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: revert commit bbdd6808 to fallocate UAPI
Message-ID: <20121120163631.GA18034@infradead.org>
References: <1353366267-15629-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353366267-15629-1-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 10:04:27AM +1100, Dave Chinner wrote:
> The method of pushing of such a commit (i.e. written, committed and
> pushed by a tree maintainer as part of a larger subsystem merge)
> could be seen as designed to avoid review and discussion of a
> controversial change that is likely to be NAKed. A long-term
> subsystem maintainer should know better than to push changes in this
> manner.


Agreed, this needs to be reverted.

Reviewed-by: Christoph Hellwig <hch@lst.de>
