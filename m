Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759961Ab1IIUrY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 16:47:24 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:41585 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759922Ab1IIUrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 16:47:21 -0400
X-Sasl-enc: k1AWOX92Ebc+iPfuWWviP4gMHKOR8uk24OellGcZ1b8B 1315601240
Date: Fri, 9 Sep 2011 13:34:47 -0700
From: Greg KH <greg@kroah.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, dan.magenheimer@oracle.com,
        cascardo@holoscopio.com, linux-kernel@vger.kernel.org,
        dave@linux.vnet.ibm.com, linux-mm@kvack.org, brking@linux.vnet.ibm.com,
        rcj@linux.vnet.ibm.com, ngupta@vflare.org
Subject: Re: [PATCH v2 0/3] staging: zcache: xcfmalloc support
Message-ID: <20110909203447.GB19127@kroah.com>
References: <1315404547-20075-1-git-send-email-sjenning@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315404547-20075-1-git-send-email-sjenning@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 09:09:04AM -0500, Seth Jennings wrote:
> Changelog:
> v2: fix bug in find_remove_block()
>     fix whitespace warning at EOF
> 
> This patchset introduces a new memory allocator for persistent
> pages for zcache.  The current allocator is xvmalloc.  xvmalloc
> has two notable limitations:
> * High (up to 50%) external fragmentation on allocation sets > PAGE_SIZE/2
> * No compaction support which reduces page reclaimation

I need some acks from other zcache developers before I can accept this.

{hint...}

