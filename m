Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab0JNKGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 06:06:36 -0400
Received: from verein.lst.de ([213.95.11.210]:47881 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755122Ab0JNKGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 06:06:35 -0400
Date: Thu, 14 Oct 2010 12:06:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Richard Sharpe <realrichardsharpe@gmail.com>
Subject: Re: [PATCH 2/5] tcm: Unify INQUIRY subsystem plugin handling
Message-ID: <20101014100609.GA29611@lst.de>
References: <1286959681-3445-1-git-send-email-nab@linux-iscsi.org> <20101013110653.GA26366@lst.de> <1287001189.7334.47.camel@haakon2.linux-iscsi.org> <20101014000421.GB15583@lst.de> <1287030937.9909.30.camel@haakon2.linux-iscsi.org> <20101014092601.GB28446@lst.de> <1287050087.9909.79.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287050087.9909.79.camel@haakon2.linux-iscsi.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 02:54:47AM -0700, Nicholas A. Bellinger wrote:
> It would make the most sense to just go ahead and set a pre-configured
> struct queue_limits into transport_add_device_to_core_hba() from
> subsystem specific ->create_virtdevice() code, and just drop whatever
> unnecessary struct se_subsystem_api ops are duplicate of what is being
> registered as defaults with struct queue_limits.

That sounds good.  Note that by now it's not just queue_limits but
also other paramters, so a rename of the structure might be a good idea.

