Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab2DXOfz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 10:35:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53618 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab2DXOfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 10:35:54 -0400
Date: Tue, 24 Apr 2012 07:35:49 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: devel@driverdev.osuosl.org, Dan Magenheimer <dan.magenheimer@oracle.com>,
        Autif Khan <autif.mlist@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH] drivers: staging: zcache: fix Kconfig crypto dependency
Message-ID: <20120424143549.GA3438@kroah.com>
References: <1335231230-29344-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <20120424022702.GA6573@kroah.com>
 <4F96AAF4.2000402@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F96AAF4.2000402@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 08:30:28AM -0500, Seth Jennings wrote:
> On 04/23/2012 09:27 PM, Greg Kroah-Hartman wrote:
> > Ok, this fixes one of the build problems reported, what about the other
> > one?
> 
> Both problems that I heard about were caused by same issue;
> the issue fixed in this patch.
> 
> ZSMALLOC=m was only allowed because CRYPTO=m was allowed.
> This patch requires CRYPTO=y, which also requires ZSMALLOC=y
> when ZCACHE=y.
> 
> https://lkml.org/lkml/2012/4/19/588
> 
> https://lkml.org/lkml/2012/4/23/481

Ah, ok, I didn't realize that, thanks for letting me know, I'll queue
this up later today.

greg k-h
