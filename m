Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237Ab1LOHVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 02:21:37 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:37274 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753003Ab1LOHVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 02:21:35 -0500
X-Sasl-enc: sBYXwBzzeK0xdDVLm5bOmP1aQMhYnDAH1TRoG7iOvtu2 1323933694
Date: Wed, 14 Dec 2011 23:21:03 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-ID: <20111215072103.GA13747@kroah.com>
References: <20111215173754.87103f66f6188693933cb539@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111215173754.87103f66f6188693933cb539@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 05:37:54PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the driver-core tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/xen/xen-selfballoon.c:305:36: error: expected ')' before '(' token
> drivers/xen/xen-selfballoon.c:327:42: error: expected ')' before '(' token
> drivers/xen/xen-selfballoon.c:349:48: error: expected ')' before '(' token
> 
> etc ...
> 
> [Along with many warnings like:
> 
> drivers/xen/xen-selfballoon.c:284:8: warning: 'struct device_attribute' declared inside parameter list [enabled by default]
> ]
> 
> Presumably caused by commit drivers/xen/xen-selfballoon.c ("xen-balloon:
> convert sysdev_class to a regular subsystem").

Ick, Kay, can you make a fix-up patch?

And here I thought I built xen in my test kernel, crap, sorry about
that.

greg k-h
