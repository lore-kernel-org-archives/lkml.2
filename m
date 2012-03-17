Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064Ab2CQLuk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 07:50:40 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:44514
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754151Ab2CQLuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 07:50:39 -0400
Date: Sat, 17 Mar 2012 07:50:34 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Gerard Snitselaar <dev@snitselaar.org>
Cc: bpm@sgi.com, xfs@oss.sgi.com, elder@kernel.org,
        linux-kernel@vger.kernel.org, xfs-master@oss.sgi.com
Subject: Re: [PATCH] fs: xfs: fix section mismatch in linux-next
Message-ID: <20120317115034.GA12342@infradead.org>
References: <1331922978-28572-1-git-send-email-dev@snitselaar.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331922978-28572-1-git-send-email-dev@snitselaar.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 11:36:18AM -0700, Gerard Snitselaar wrote:
> xfs_qm_exit() is called in init_xfs_fs().
> 
> Signed-off-by: Gerard Snitselaar <dev@snitselaar.org>

Thanks for catching this, the fix looks good to me.

Reviewed-by: Christoph Hellwig <hch@lst.de>
