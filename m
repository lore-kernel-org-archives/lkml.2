Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab1DZTsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 15:48:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56953 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755975Ab1DZTsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 15:48:30 -0400
Date: Tue, 26 Apr 2011 12:39:01 -0700
From: Greg KH <gregkh@suse.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: [PATCH 00/25] Staging: hv: Cleanup vmbus driver code
Message-ID: <20110426193901.GC17467@suse.de>
References: <1303834785-4981-1-git-send-email-kys@microsoft.com>
 <20110426165704.GA29301@infradead.org>
 <6E21E5352C11B742B20C142EB499E0481DAFB2@TK5EX14MBXC124.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481DAFB2@TK5EX14MBXC124.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 05:04:36PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Christoph Hellwig [mailto:hch@infradead.org]
> > Sent: Tuesday, April 26, 2011 12:57 PM
> > To: KY Srinivasan
> > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; virtualization@lists.osdl.org
> > Subject: Re: [PATCH 00/25] Staging: hv: Cleanup vmbus driver code
> > 
> > Do you have a repository containing the current state of your patche
> > somewhere?  There's been so much cleanup that it's hard to review these
> > patches against the current mainline codebase.
> 
> Christoph,
> 
> Yesterday (April 25, 2011), Greg checked in all of the outstanding hv patches. So, if
> You checkout Greg's tree today, you will get the most recent hv codebase. This current
> patch-set is against Greg's current tree.

It's also always in the linux-next tree, which is easier for most people
to work off of.

thanks,

greg k-h
