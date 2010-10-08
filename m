Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab0JHHVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 03:21:21 -0400
Received: from canuck.infradead.org ([134.117.69.58]:54906 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111Ab0JHHVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 03:21:20 -0400
Date: Fri, 8 Oct 2010 03:21:19 -0400
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/18] exofs: use iput() for inode reference count
 decrements
Message-ID: <20101008072119.GF23595@lst.de>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-8-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286515292-15882-8-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 04:21:21PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Direct modification of the inode reference count is a no-no. Convert
> the exofs decrements to call iput() instead of acting directly on
> i_count.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

The real question is why exofs got along with this so long.

