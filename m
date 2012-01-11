Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab2AKLfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 06:35:12 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:38614
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753670Ab2AKLfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 06:35:08 -0500
Date: Wed, 11 Jan 2012 06:35:07 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: Alex Elder <aelder@sgi.com>, Ben Myers <bpm@sgi.com>,
        xfs masters <xfs-masters@oss.sgi.com>, xfs <xfs@oss.sgi.com>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: cleanup XFS_BB_FSB_OFFSET
Message-ID: <20120111113507.GB14423@infradead.org>
References: <1325848338-6063-1-git-send-email-amit.sahrawat83@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325848338-6063-1-git-send-email-amit.sahrawat83@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 06, 2012 at 04:42:18PM +0530, Amit Sahrawat wrote:
> Removing the macro, as this is no more needed in the code. 
> Tried to find the reference when it was last used - but the usage 
> for this seemed to have been dropped long time ago.
> 
> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>

This looks good, but the subject should be something like:

"xfs: kill the unused XFS_BB_FSB_OFFSET macro"


Reviewed-by: Christoph Hellwig <hch@lst.de>
