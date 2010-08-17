Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949Ab0HQRKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 13:10:21 -0400
Received: from verein.lst.de ([213.95.11.210]:55039 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088Ab0HQRKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 13:10:19 -0400
Date: Tue, 17 Aug 2010 19:08:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, jaxboe@fusionio.com,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu,
        chris.mason@oracle.com, swhiteho@redhat.com,
        konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net,
        jack@suse.cz, rwheeler@redhat.com, hare@suse.de,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/11] block: rename barrier/ordered to flush
Message-ID: <20100817170857.GA15297@lst.de>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <1281616891-5691-9-git-send-email-tj@kernel.org> <20100817132646.GA3577@lst.de> <4C6AB79B.2040303@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6AB79B.2040303@kernel.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 06:23:55PM +0200, Tejun Heo wrote:
> Yeap, agreed.  I couldn't really understand why the the sequence
> needed to be atomic for ide in the first place so just left it alone.
> Do you understand why it tried to be atomic?

I think initial drafs of the barrier specification talked about atomic
sequences.  Except for that I can't think of any reason.

