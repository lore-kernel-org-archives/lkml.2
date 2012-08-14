Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab2HNCfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 22:35:37 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65397 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242Ab2HNCfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 22:35:36 -0400
Date: Mon, 13 Aug 2012 19:35:30 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>
Subject: Re: [PATCH 0/7] zram/zsmalloc promotion
Message-ID: <20120814023530.GA9787@kroah.com>
References: <1344406340-14128-1-git-send-email-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344406340-14128-1-git-send-email-minchan@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 03:12:13PM +0900, Minchan Kim wrote:
> This patchset promotes zram/zsmalloc from staging.
> Both are very clean and zram is used by many embedded product
> for a long time.
> 
> [1-3] are patches not merged into linux-next yet but needed
> it as base for [4-5] which promotes zsmalloc.
> Greg, if you merged [1-3] already, skip them.

I've applied 1-3 and now 4, but that's it, I can't apply the rest
without getting acks from the -mm maintainers, sorry.  Please work with
them to get those acks, and then I will be glad to apply the rest (after
you resend them of course...)

thanks,

greg k-h
