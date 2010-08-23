Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab0HWMsr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 08:48:47 -0400
Received: from verein.lst.de ([213.95.11.210]:33305 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729Ab0HWMsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 08:48:45 -0400
Date: Mon, 23 Aug 2010 14:48:15 +0200
From: Christoph Hellwig <hch@lst.de>
To: Tejun Heo <tj@kernel.org>
Cc: Ric Wheeler <rwheeler@redhat.com>, Christoph Hellwig <hch@lst.de>,
        jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
        dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, hare@suse.de
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with sequenced flush
Message-ID: <20100823124815.GA20095@lst.de>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <20100820132214.GA6184@lst.de> <4C6E9CAF.5010202@redhat.com> <4C7269E9.9070304@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C7269E9.9070304@kernel.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 02:30:33PM +0200, Tejun Heo wrote:
> It might be useful to give several example configurations with
> different cache configurations.  I don't have much experience with
> battery backed arrays but aren't they suppose to report write through
> cache automatically?

They usually do.  I have one that doesn't, but SYNCHRONIZE CACHE on
it is so fast that it effectively must be a no-op.

