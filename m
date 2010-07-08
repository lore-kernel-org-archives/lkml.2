Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab0GHUET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 16:04:19 -0400
Received: from kroah.org ([198.145.64.141]:34437 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021Ab0GHUEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 16:04:12 -0400
Date: Thu, 8 Jul 2010 13:00:18 -0700
From: Greg KH <greg@kroah.com>
To: Joe Eloff <kagen101@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Simon Horman <horms@verge.net.au>, devel <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Staging: dt3155: fix coding style issues in
 dt3155_drv.c
Message-ID: <20100708200018.GC3530@kroah.com>
References: <1278435198.5396.73.camel@dermezel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278435198.5396.73.camel@dermezel>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 06, 2010 at 06:53:18PM +0200, Joe Eloff wrote:
> I just realised how the commit chaining works after messing it up so I have already 
> uploaded a 1/2 and 2/2 and now it made another 2/2 for this patch which is different.
> 
> I have realised how it works now and wont mess it up again and have no idea how to reverse chain the
> 3 patches.
> 
> This now fixes up all checkpatch.pl issues bar 1.

This doesn't apply either :(

care to redo all of these against the latest linux-next?

thanks,

greg k-h
