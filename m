Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab0HTQBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 12:01:40 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:57206 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321Ab0HTQBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 12:01:37 -0400
Date: Fri, 20 Aug 2010 12:00:09 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>,
        jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        James.Bottomley@suse.de, tytso@mit.edu, swhiteho@redhat.com,
        konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net,
        jack@suse.cz, hare@suse.de
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
 sequenced flush
Message-ID: <20100820160009.GI5854@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Ric Wheeler <rwheeler@redhat.com>, Christoph Hellwig <hch@lst.de>,
	Tejun Heo <tj@kernel.org>, jaxboe@fusionio.com,
	linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu,
	swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
	dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, hare@suse.de
References: <1281616891-5691-1-git-send-email-tj@kernel.org>
 <20100820132214.GA6184@lst.de>
 <4C6E9CAF.5010202@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6E9CAF.5010202@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 11:18:07AM -0400, Ric Wheeler wrote:
> On 08/20/2010 09:22 AM, Christoph Hellwig wrote:
> >FYI: here's a little writeup to document the new cache flushing scheme,
> >intended to replace Documentation/block/barriers.txt.  Any good
> >suggestion for a filename in the kernel tree?
> >
> >---
> 
> I was thinking that we might be better off using the "durable
> writes" term more since it is well documented (at least in the
> database world, where it is the "D" in ACID properties).  Maybe
> "durable_writes_support.txt" ?

sata_lies.txt?

Ok, maybe writeback_cache.txt?

-chris
