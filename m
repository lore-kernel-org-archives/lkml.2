Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab0GBKxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 06:53:17 -0400
Received: from verein.lst.de ([213.95.11.210]:36095 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755699Ab0GBKxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 06:53:13 -0400
Date: Fri, 2 Jul 2010 12:52:56 +0200
From: Christoph Hellwig <hch@lst.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: axboe@kernel.dk, snitzer@redhat.com, hch@lst.de, James.Bottomley@suse.de,
       linux-scsi@vger.kernel.org, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] scsi: remove unused free discard page in sd_done
Message-ID: <20100702105256.GE26318@lst.de>
References: <1277981359-10717-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1277981359-10717-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277981359-10717-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 07:49:19PM +0900, FUJITA Tomonori wrote:
> - sd_done isn't called for pc request so we never call the code.
> - we use sd_unprep to free discard page now.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

