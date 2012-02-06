Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab2BFTc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 14:32:59 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:53913 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab2BFTc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 14:32:58 -0500
Date: Mon, 6 Feb 2012 19:32:56 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 2/2] hfsplus: Add an ioctl to bless files
Message-ID: <20120206193256.GA4064@srcf.ucam.org>
References: <1328215191-4201-1-git-send-email-mjg@redhat.com>
 <1328215191-4201-2-git-send-email-mjg@redhat.com>
 <20120206173553.GB1135@infradead.org>
 <20120206174549.GA1655@srcf.ucam.org>
 <20120206174943.GA14225@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120206174943.GA14225@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 12:49:43PM -0500, Christoph Hellwig wrote:
> On Mon, Feb 06, 2012 at 05:45:49PM +0000, Matthew Garrett wrote:
> > On Mon, Feb 06, 2012 at 12:35:53PM -0500, Christoph Hellwig wrote:
> > > +#define HFSPLUS_IOC_BLESS              _IO('f', 0x20)
> > > 
> > > I'd probably move this to fs.h and follow the numbering there,
> > > otherwise we are bound to run into conflicts.
> > 
> > Ok. Any problem with leaving something filesystem specific in there?
> 
> Leaving it in hfsplus sounds fine, but I'd avoid using 'f' then just to
> reduce the chance for overlap.

Using the same range but putting it in a different file seems like a 
good way to have someone miss it. I added the range to ioctl-list.txt so 
in theory nobody should step on it - do you think that's likely to be 
inadequate?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
