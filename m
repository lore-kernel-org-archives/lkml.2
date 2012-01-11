Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372Ab2AKPCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 10:02:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36513 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755110Ab2AKPCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 10:02:14 -0500
Date: Wed, 11 Jan 2012 07:00:21 -0800
From: Greg KH <gregkh@suse.de>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ben Myers <bpm@sgi.com>
Subject: Re: [41/42] xfs: validate acl count
Message-ID: <20120111150021.GB23608@suse.de>
References: <20120110215031.GA19398@kroah.com>
 <20120110215024.482323323@clark.kroah.org>
 <20120111074135.GA30829@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120111074135.GA30829@lst.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 08:41:35AM +0100, Christoph Hellwig wrote:
> On Tue, Jan 10, 2012 at 01:48:51PM -0800, Greg KH wrote:
> > 3.1-stable review patch.  If anyone has any objections, please let me know.
> 
> Just curious, how well tested are all the patches on 2.6.32 and 3.1 hat I only
> submitted for 3.0?  I'd really prefer if they at least get an xfstest run
> before they get sent out to the world.

I took these patches on my own as they were reported to fix a public
vulnerability which was assigned a CVE.  They applied with no fuzz and
"looked correct" so I applied them on my own.

If I shouldn't have, please let me know and I'll drop them.

Otherwise, a nice run of xfstest by someone would be appreciated.

thanks,

greg k-h
