Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887Ab0GUMCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 08:02:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55958 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518Ab0GUMCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 08:02:51 -0400
Date: Wed, 21 Jul 2010 08:02:50 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 09/11] writeback: restructure bdi forker loop a little
Message-ID: <20100721120250.GE28745@infradead.org>
References: <1279704706-1267-1-git-send-email-dedekind1@gmail.com>
 <1279704706-1267-10-git-send-email-dedekind1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279704706-1267-10-git-send-email-dedekind1@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 12:31:44PM +0300, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> 
> This patch re-structures the loop which walks bdi a little. This is just a
> micro-step towards the coming change where the forker thread will kill the bdi
> threads. It should simplify reviewing the following changes, which would
> otherwise be larger.
> 
> This patch also adds the 'bdi_cap_flush_forker(bdi)' condition check to the
> loop. The reason for this is that the forker thread can start _before_ the
> 'BDI_registered' flag is set (see 'bdi_register()'), so the WARN() statement
> will fire for the default bdi. I observed this warning at boot-up.
> 
> This patch also amends comments a little.

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

