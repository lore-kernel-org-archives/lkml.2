Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab2ARWgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 17:36:09 -0500
Received: from relay2.sgi.com ([192.48.179.30]:40947 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753194Ab2ARWgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 17:36:07 -0500
Date: Wed, 18 Jan 2012 16:36:02 -0600
From: Ben Myers <bpm@sgi.com>
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: Alex Elder <elder@kernel.org>, Christoph Hellwig <hch@lst.de>,
        xfs-masters@oss.sgi.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 1/1] xfs: kill the unused XFS_BB_FSB_OFFSET macro
Message-ID: <20120118223602.GA30741@sgi.com>
References: <1326716676-11842-1-git-send-email-amit.sahrawat83@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326716676-11842-1-git-send-email-amit.sahrawat83@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 05:54:36PM +0530, Amit Sahrawat wrote:
> Removing the macro, as this is no more needed in the code.
> Tried to find the reference when it was last used - but the usage
> for this seemed to have been dropped long time ago.
> 
> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks good.
Reviewed-by: Ben Myers <bpm@sgi.com>
