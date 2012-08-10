Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab2HJBPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 21:15:52 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39590 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782Ab2HJBPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 21:15:51 -0400
Date: Thu, 9 Aug 2012 21:15:46 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: Re: [PATCH 0/7] zram/zsmalloc promotion
Message-ID: <20120810011545.GA25218@localhost.localdomain>
References: <1344406340-14128-1-git-send-email-minchan@kernel.org>
 <5022A369.5020304@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5022A369.5020304@vflare.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 10:35:37AM -0700, Nitin Gupta wrote:
> On 08/07/2012 11:12 PM, Minchan Kim wrote:
> > This patchset promotes zram/zsmalloc from staging.
> > Both are very clean and zram is used by many embedded product
> > for a long time.
> > 
> > [1-3] are patches not merged into linux-next yet but needed
> > it as base for [4-5] which promotes zsmalloc.
> > Greg, if you merged [1-3] already, skip them.
> > 
> > Seth Jennings (5):
> >   1. zsmalloc: s/firstpage/page in new copy map funcs
> >   2. zsmalloc: prevent mappping in interrupt context
> >   3. zsmalloc: add page table mapping method
> >   4. zsmalloc: collapse internal .h into .c
> >   5. zsmalloc: promote to mm/
> > 
> > Minchan Kim (2):
> >   6. zram: promote zram from staging
> >   7. zram: select ZSMALLOC when ZRAM is configured
> > 
> 
> All the changes look good to me. FWIW, for the entire series:
> Acked-by: Nitin Gupta <ngupta@vflare.org>

And Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
as well. Thanks!
> 
> Thanks for all the work.
> Nitin
> 
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
