Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349Ab2AYREQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 12:04:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47895 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754883Ab2AYREP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 12:04:15 -0500
Date: Wed, 25 Jan 2012 09:03:51 -0800
From: Greg KH <gregkh@suse.de>
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, KY Srinivasan <kys@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>
Subject: Re: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out of
 the staging area
Message-ID: <20120125170351.GB5461@suse.de>
References: <1326402943-14031-1-git-send-email-kys@microsoft.com>
 <20120114164228.GB9682@infradead.org>
 <6E21E5352C11B742B20C142EB499E0481B6F0307@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20120116152951.GA9720@infradead.org>
 <6E21E5352C11B742B20C142EB499E0481B6FE0E2@TK5EX14MBXC122.redmond.corp.microsoft.com>
 <20120125154300.GA19509@infradead.org>
 <20120125155115.GA3608@suse.de>
 <1327507166.2776.32.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327507166.2776.32.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 03:59:26PM +0000, James Bottomley wrote:
> On Wed, 2012-01-25 at 07:51 -0800, Greg KH wrote:
> > On Wed, Jan 25, 2012 at 10:43:00AM -0500, Christoph Hellwig wrote:
> > > On Wed, Jan 25, 2012 at 03:29:05PM +0000, KY Srinivasan wrote:
> > > > James,
> > > > Any updates here? 
> > > 
> > > Given that this is a new driver without external dependencies it seems
> > > fine even for a 3.3 merge to me.
> > 
> > Fine with me as well.
> 
> OK, so what I need to linux-scsi is an applyable patch moving it out of
> staging.

I think there have been about 3-4 copies of this in your email archives,
but if that didn't work, I'm sure that KY can create it again :)

thanks,

greg k-h
