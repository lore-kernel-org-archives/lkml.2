Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756Ab1JDP1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 11:27:05 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:59425 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932688Ab1JDP0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 11:26:34 -0400
X-Sasl-enc: DRLU+VHZ9erQwuv6/eUJjToRlub0jNeGrpy/FfKrLSuh 1317741994
Date: Tue, 4 Oct 2011 08:25:43 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <jaxboe@fusionio.com>,
        Jerome Marchand <jmarchan@redhat.com>
Subject: Re: linux-next: manual merge of the staging tree with the block tree
Message-ID: <20111004152543.GB29994@kroah.com>
References: <20111004171415.db52e4eb5c913afeba0a3bee@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111004171415.db52e4eb5c913afeba0a3bee@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 05:14:15PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/zram/zram_drv.c between commit 5a7bbad27a41 ("block:
> remove support for bio remapping from ->make_request") from the block
> tree and commit 0900beae178a ("staging: zram: fix zram locking") from the
> staging tree.
> 
> I fixed it up (I think - see below) and can carry the fix as necessary.

That looks correct to me, thanks for doing this.

greg k-h
