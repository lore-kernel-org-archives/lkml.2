Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713Ab0HMHrs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 03:47:48 -0400
Received: from verein.lst.de ([213.95.11.210]:52501 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045Ab0HMHrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 03:47:43 -0400
Date: Fri, 13 Aug 2010 09:47:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: Tejun Heo <tj@kernel.org>
Cc: Jan Kara <jack@suse.cz>, jaxboe@fusionio.com,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, hch@lst.de, James.Bottomley@suse.de,
        tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com,
        konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net,
        rwheeler@redhat.com, hare@suse.de
Subject: Re: [PATCH 10/11] fs, block: propagate REQ_FLUSH/FUA interface to upper layers
Message-ID: <20100813074713.GA24428@lst.de>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <1281616891-5691-11-git-send-email-tj@kernel.org> <20100812212404.GB3665@quack.suse.cz> <4C64F21D.7010409@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C64F21D.7010409@kernel.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI: I've already sent a patch to kill BH_Ordered, hopefully Al will
still push it in this merge window.

