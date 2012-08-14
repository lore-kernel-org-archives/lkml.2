Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab2HNNbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 09:31:49 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:51549 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab2HNNbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 09:31:47 -0400
Date: Tue, 14 Aug 2012 09:21:31 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>
Subject: Re: [PATCH 0/7] zram/zsmalloc promotion
Message-ID: <20120814132131.GB10880@phenom.dumpdata.com>
References: <1344406340-14128-1-git-send-email-minchan@kernel.org>
 <20120814023530.GA9787@kroah.com>
 <20120814062246.GB31621@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120814062246.GB31621@bbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 03:22:47PM +0900, Minchan Kim wrote:
> Hi Greg,
> 
> On Mon, Aug 13, 2012 at 07:35:30PM -0700, Greg Kroah-Hartman wrote:
> > On Wed, Aug 08, 2012 at 03:12:13PM +0900, Minchan Kim wrote:
> > > This patchset promotes zram/zsmalloc from staging.
> > > Both are very clean and zram is used by many embedded product
> > > for a long time.
> > > 
> > > [1-3] are patches not merged into linux-next yet but needed
> > > it as base for [4-5] which promotes zsmalloc.
> > > Greg, if you merged [1-3] already, skip them.
> > 
> > I've applied 1-3 and now 4, but that's it, I can't apply the rest
> 
> Thanks!
> 
> > without getting acks from the -mm maintainers, sorry.  Please work with
> 
> Nitin suggested zsmalloc could be in /lib or /zram out of /mm but I want
> to confirm it from akpm so let's wait his opinion.
> 
> Anyway, another question. zram would be under driver/blocks.
> Do I need ACK from Jens for that?

Yes.
> 
> > them to get those acks, and then I will be glad to apply the rest (after
> > you resend them of course...)
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > --
> > To unsubscribe, send a message with 'unsubscribe linux-mm' in
> > the body to majordomo@kvack.org.  For more info on Linux MM,
> > see: http://www.linux-mm.org/ .
> > Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
> -- 
> Kind regards,
> Minchan Kim
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
