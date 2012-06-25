Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349Ab2FYQ7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 12:59:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37327 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab2FYQ7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 12:59:21 -0400
Date: Mon, 25 Jun 2012 09:59:16 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: devel@driverdev.osuosl.org, Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH 2/3] zsmalloc: add generic path and remove x86 dependency
Message-ID: <20120625165915.GA20464@kroah.com>
References: <1340640878-27536-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1340640878-27536-3-git-send-email-sjenning@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340640878-27536-3-git-send-email-sjenning@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 11:14:37AM -0500, Seth Jennings wrote:
> This patch adds generic pages mapping methods that
> work on all archs in the absence of support for
> local_tlb_flush_kernel_range() advertised by the
> arch through __HAVE_LOCAL_TLB_FLUSH_KERNEL_RANGE

Is this #define something that other arches define now?  Or is this
something new that you are adding here?

thanks,

greg k-h
