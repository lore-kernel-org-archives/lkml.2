Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406Ab2DSUIE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 16:08:04 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50445 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932246Ab2DSUIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 16:08:01 -0400
X-Sasl-enc: M/gZxCFJs9Bn0nsv2rDkjmoxMqvvA60BGj/KgHGVzuK/ 1334866080
Date: Thu, 19 Apr 2012 13:07:59 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Hannes Reinecke <hare@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-ID: <20120419200759.GD10059@kroah.com>
References: <20120419144815.50f7c3d30d88e6259665313d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120419144815.50f7c3d30d88e6259665313d@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 02:48:15PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the driver-core tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> lib/klist.c: In function 'klist_iter_init_node':
> lib/klist.c:287:4: error: too few arguments to function 'kref_put'
> include/linux/kref.h:92:19: note: declared here
> 
> Caused by commit a15d49fd3094 ("driver core: check start node in
> klist_iter_init_node").  That really hasn't been build tested, has it?
> 
> I have used the driver-core tree from next-20120418 for today.

Ick.  Hannes, care to send me a fix for this?

thanks,

greg k-h
