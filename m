Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab1C2UIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 16:08:15 -0400
Received: from verein.lst.de ([213.95.11.211]:42861 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860Ab1C2UIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 16:08:14 -0400
Date: Tue, 29 Mar 2011 22:08:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [xfs-masters] linux-next: manual merge of the xfs tree with
	Linus' tree
Message-ID: <20110329200813.GA9687@lst.de>
References: <20110328122148.1b48a742.sfr@canb.auug.org.au> <20110328104753.GA27327@lst.de> <20110328105348.GA27458@lst.de> <4D9069C1.4080602@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9069C1.4080602@fusionio.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI, the blk_flush_plug call in ufs_truncate also seem to be almost
certainly incorrect as it's followed by a yield.

That only leaves the RAID code as remaining modular users of it, and
I suspect it really is something that shouldn't need to be exported.
