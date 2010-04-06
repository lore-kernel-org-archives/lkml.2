Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041Ab0DFRpF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 13:45:05 -0400
Received: from verein.lst.de ([213.95.11.210]:56326 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756735Ab0DFRo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 13:44:58 -0400
Date: Tue, 6 Apr 2010 19:44:44 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anton Blanchard <anton@samba.org>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] raw: fsync method is now required
Message-ID: <20100406174444.GA11979@lst.de>
References: <20100404004523.GL5594@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100404004523.GL5594@kryten>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 04, 2010 at 10:45:23AM +1000, Anton Blanchard wrote:
> +int block_fsync(struct file *filp, struct dentry *dentry, int datasync)

Can you rename this to blkdev_fsync now that it's exported?

