Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab0GBKt6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 06:49:58 -0400
Received: from verein.lst.de ([213.95.11.210]:59490 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856Ab0GBKt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 06:49:56 -0400
Date: Fri, 2 Jul 2010 12:49:38 +0200
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@redhat.com>
Cc: James Bottomley <James.Bottomley@suse.de>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, axboe@kernel.dk,
       hch@lst.de, linux-scsi@vger.kernel.org, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: scsi: address leak in the error path of discard page allocation
Message-ID: <20100702104938.GC26318@lst.de>
References: <1277981359-10717-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1277981359-10717-3-git-send-email-fujita.tomonori@lab.ntt.co.jp> <20100701130328.GB19605@redhat.com> <20100701201508.GA28546@redhat.com> <1278015548.2813.147.camel@mulgrave.site> <20100701210749.GB28546@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100701210749.GB28546@redhat.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 05:07:49PM -0400, Mike Snitzer wrote:
> OK, thanks for clarifying.  This confirms that the general approach I
> took in this patch is correct.  It remains to be seen if Jens is
> agreeable with blk_clear_request_payload.
> 
> I know Christoph thought my introduction and use of
> blk_clear_request_payload was reasonable.  Christoph, please feel free
> to add your Ack to this patch if you approve.

Yes, I think that's the right way to do it.


Btw, guys - what happened to the idea of trimming useless context in
mail replies?  This thread got almost unreadable because of the quoting
at this point.

