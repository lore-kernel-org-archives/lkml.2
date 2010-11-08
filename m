Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab0KHWhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 17:37:37 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45320 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583Ab0KHWhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 17:37:35 -0500
Date: Mon, 8 Nov 2010 17:37:33 -0500
From: Christoph Hellwig <hch@infradead.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>,
        Joel Becker <joel.becker@oracle.com>
Subject: Re: [RFCv3 00/21] TCM Core and TCM_Loop patches for v2.6.37
Message-ID: <20101108223733.GA26515@infradead.org>
References: <1287441313-19703-1-git-send-email-nab@linux-iscsi.org>
 <20101108143952.GB22121@infradead.org>
 <1289251207.27226.59.camel@haakon2.linux-iscsi.org>
 <20101108214825.GA26609@infradead.org>
 <1289253869.27226.75.camel@haakon2.linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289253869.27226.75.camel@haakon2.linux-iscsi.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 02:04:29PM -0800, Nicholas A. Bellinger wrote:
> Hmmm, I recall asking Joel about this at some point back in 2008 and
> back then I believe configfs was still limited to a PAGE_SIZE.
> 
> Joel, any comments here on the usage of seq_file() w/ configfs..?

If fixing this would require configfs changes feel free to postponed it
for now.
