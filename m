Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934824Ab0GOVVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 17:21:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54719 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934799Ab0GOVVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 17:21:18 -0400
Date: Thu, 15 Jul 2010 17:21:16 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Alex Elder <aelder@sgi.com>,
        Felix Blyakher <felixb@sgi.com>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com, xfs-masters@oss.sgi.com,
        Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 6/8] xfs: fix unsigned underflow
Message-ID: <20100715212116.GA7013@infradead.org>
References: <1279219605-12631-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279219605-12631-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 10:46:45PM +0400, Kulikov Vasiliy wrote:
> map_len is unsigned. Checking map_len <= 0 is buggy when it should be
> below zero. So, check exact expression instead of map_len.
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

