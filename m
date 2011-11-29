Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab1K2PD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 10:03:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410Ab1K2PDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 10:03:25 -0500
Date: Tue, 29 Nov 2011 10:03:16 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [SCSI] sd: Lower printk level for drive cache information
Message-ID: <20111129150112.GA2453@zod.bos.redhat.com>
References: <20111128163053.GA24618@zod.bos.redhat.com>
 <20111129044442.GA19616@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111129044442.GA19616@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 11:44:42PM -0500, Christoph Hellwig wrote:
> On Mon, Nov 28, 2011 at 11:31:55AM -0500, Josh Boyer wrote:
> > Numerous devices don't present cache data, particularly USB sticks.  The
> > devices operate correctly despite this, so lower the printk severity to
> > KERN_NOTICE.
> 
> Do they?  The last reports on the list were for devices that didn't
> present it but actually needed cache flushes despite not having the
> cache mode page.

We've seen a number of reports for liveusb images that spit out those
printks, but seem to otherwise work fine.

Even if the devices need cache flushes, what is a typical user supposed
to do about that?  I'm not particularly tied to this patch, but there is
nothing a normal user can do with the information spit out by these
printks, so making it KERN_ERR seems excessive.

josh
> 
