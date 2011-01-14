Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493Ab1ANBQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 20:16:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343Ab1ANBQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 20:16:13 -0500
Date: Thu, 13 Jan 2011 20:15:39 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Hannes Reinecke <hare@suse.de>, k-ueda@ct.jp.nec.com, michaelc@cs.wisc.edu,
        tytso@mit.edu, sshtylyov@mvista.com, linux-scsi@vger.kernel.org,
        jaxboe@fusionio.com, jack@suse.cz, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, swhiteho@redhat.com,
        linux-raid@vger.kernel.org, linux-ide@vger.kernel.org,
        dm-devel@redhat.com, James.Bottomley@suse.de,
        konishi.ryusuke@lab.ntt.co.jp, j-nomura@ce.jp.nec.com, vst@vlnb.net,
        rwheeler@redhat.com, hch@lst.de, chris.mason@oracle.com, tj@kernel.org
Subject: Re: [RFC PATCH 0/3] differentiate between I/O errors
Message-ID: <20110114011538.GB21818@redhat.com>
References: <20101130225956.GA8882@redhat.com>
 <1291763802-8251-1-git-send-email-snitzer@redhat.com>
 <20101210234036.GA4841@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101210234036.GA4841@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10 2010 at  6:40pm -0500,
Malahal Naineni <malahal@us.ibm.com> wrote:

> Mike Snitzer [snitzer@redhat.com] wrote:
> > Refreshed Hannes' initial "scsi: Detailed I/O errors" patch against
> > v2.6.37-rc5.  v2 introduces __scsi_error_from_host_byte to avoid
> > the duplicate switch statement.  Also a few whitespace and comment
> > changes.
> > 
> > Split DM mpath change out to separate v2 patch; failed discard is now
> > retryable in the face of a non-target IO error.
> > 
> > Added improved block layer's I/O error message (based on the finer
> > grained I/O error returns afforded by SCSI).
> > 
> > Comments/suggestions are welcome.
> 
> I did test the Hannes original patch with the latest Linus' git tree! I
> used scsi_debug to simulate path failures as well as 'Media' failures
> and it did work as expected. I will test your patches soon.

Hi Malahal,

I was wondering if you had any feedback (testing or otherwise) for these
patches:

https://patchwork.kernel.org/patch/384612/
https://patchwork.kernel.org/patch/384602/
https://patchwork.kernel.org/patch/390882/

We haven't heard from Hannes in a bit but I was hoping we could at least
understand that the few changes I made are agreeable and working as
expected.

Thanks,
Mike
