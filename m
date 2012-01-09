Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933521Ab2AIXLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 18:11:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33590 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932953Ab2AIXLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 18:11:16 -0500
Date: Mon, 9 Jan 2012 15:09:44 -0800
From: Greg KH <gregkh@suse.de>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>, Konrad Wilk <konrad.wilk@oracle.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] staging: zsmalloc: memory allocator for compressed
 pages
Message-ID: <20120109230944.GA11802@suse.de>
References: <1326149520-31720-1-git-send-email-sjenning@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326149520-31720-1-git-send-email-sjenning@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 04:51:55PM -0600, Seth Jennings wrote:
> This patchset introduces a new memory allocation library named
> zsmalloc.  zsmalloc was designed to fulfill the needs
> of users where:
>  1) Memory is constrained, preventing contiguous page allocations
>     larger than order 0 and
>  2) Allocations are all/commonly greater than half a page.

As this is submitted during the merge window, I don't have any time to
look at it until after 3.3-rc1 is out.

I'll queue it up for then.

thanks,

greg k-h
