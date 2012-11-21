Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026Ab2KVUIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:08:19 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:57752 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756417Ab2KVUGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:06:38 -0500
Date: Wed, 21 Nov 2012 13:48:23 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Rupesh Gujare <rgujare@ozmodevices.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        sachin.kamat@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [V2 PATCH 1/3] staging: ozwpan: Remove redundant null check
 before kfree in ozpd.c
Message-ID: <20121121214823.GA28532@kroah.com>
References: <20121120163513.GC4990@kroah.com>
 <1353501977-6585-2-git-send-email-rgujare@ozmodevices.com>
 <20121121130527.GH11248@mwanda>
 <50ACDA54.7040508@ozmodevices.com>
 <20121121161859.GI6186@mwanda>
 <50AD0EB4.5070307@ozmodevices.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50AD0EB4.5070307@ozmodevices.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 05:26:12PM +0000, Rupesh Gujare wrote:
> On 21/11/12 16:19, Dan Carpenter wrote:
> >When someone sends a patch there are a several possible responses:
> >1) Ack the patch.
> >2) Request that the submitter redo it.  The downside is that no one
> >    likes redoing patches.
> >3) Reject the patch.
> >4) Redo it yourself and say "Based on a patch from Sachin Kamat".
> >    This isn't nice because everyone wants author credit.
> >5) Redo it and get permission from the original author to give them
> >    author credit get their signed-off-by.
> >
> >
> Thanks Dan
> 
> I will keep it in mind in future.
> 
> Sachin,
> 
> Are you interested in redoing (or sending sign-off ?) for this patch
> series ? I am more than happy to accept either.

Don't worry, I'll clean up the mess here...

