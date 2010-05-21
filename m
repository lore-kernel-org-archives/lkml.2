Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933530Ab0EUPV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 11:21:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57699 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758226Ab0EUPVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 11:21:22 -0400
Date: Fri, 21 May 2010 11:21:22 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Josef Bacik <josef@redhat.com>
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@infradead.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 4/6] fs: kill blockdev_direct_IO_no_locking
Message-ID: <20100521152122.GC16049@infradead.org>
References: <1274300694-8976-1-git-send-email-josef@redhat.com> <1274300694-8976-4-git-send-email-josef@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274300694-8976-4-git-send-email-josef@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 04:24:52PM -0400, Josef Bacik wrote:
> Christoph said he'd rather everybody use __blockdev_direct_IO directly instead
> of having a bunch of random helper functions, so thats what this patch does.
> It's a basic change, I've tested it with xfstests on ext4 and xfs.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>

Ok,


Reviewed-by: Christoph Hellwig <hch@lst.de>

