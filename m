Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab0F0Pet (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 11:34:49 -0400
Received: from verein.lst.de ([213.95.11.210]:44539 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755390Ab0F0Pes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 11:34:48 -0400
Date: Sun, 27 Jun 2010 17:33:59 +0200
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk,
       martin.petersen@oracle.com, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, James.Bottomley@suse.de, akpm@linux-foundation.org
Subject: Re: [PATCH 2/2 v2] block: defer the use of inline biovecs for discard requests
Message-ID: <20100627153359.GB25667@lst.de>
References: <20100622180029.GA15950@redhat.com> <1277582211-10725-2-git-send-email-snitzer@redhat.com> <20100627145515.GE3970@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100627145515.GE3970@redhat.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

