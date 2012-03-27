Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866Ab2C0JEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 05:04:22 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:47397
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753609Ab2C0JET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 05:04:19 -0400
Date: Tue, 27 Mar 2012 05:04:15 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/2] block: tweak rounding of max_discard_sectors
Message-ID: <20120327090415.GA17685@infradead.org>
References: <1331745148-24885-1-git-send-email-pbonzini@redhat.com>
 <1331745148-24885-2-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331745148-24885-2-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 06:12:27PM +0100, Paolo Bonzini wrote:
> Mostly a preparation for the next patch.
> 
> In principle this fixes an infinite loop if max_discard_sectors < granularity,
> but that really shouldn't happen.
> 
> Cc: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Looks good, thanks for fixing this.

Reviewed-by: Christoph Hellwig <hch@lst.de>
