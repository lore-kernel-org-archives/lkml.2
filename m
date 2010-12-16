Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab0LPRAu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 12:00:50 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47731 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399Ab0LPRAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 12:00:48 -0500
Date: Thu, 16 Dec 2010 12:00:30 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kay.sievers@vrfy.org, jack@suse.cz,
        James.Bottomley@HansenPartnership.com
Subject: Re: [PATCHSET] block/SCSI: implement in-kernel disk event handling,
 take#2
Message-ID: <20101216170030.GA13585@infradead.org>
References: <1291838262-21274-1-git-send-email-tj@kernel.org>
 <4D0A3EE1.4050404@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D0A3EE1.4050404@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 05:31:29PM +0100, Tejun Heo wrote:
> On 12/08/2010 08:57 PM, Tejun Heo wrote:
> > This is the second take of in-kernel-disk-event patchset which
> > implements in-kernel disk event handling framework and adds support
> > for it to sr and sd.  This is largely to move media presence polling
> > into kernel as userspace implementation turned out to be quite
> > problematic over the years.
> 
> Kay, Jens, James, how does this look to you guys?

Any chance could could conver all block drivers to the new methods
instead of leaving us with yet another incomplete transition?

