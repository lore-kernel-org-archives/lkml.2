Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab2EVWIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 18:08:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36907 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab2EVWIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 18:08:34 -0400
Date: Tue, 22 May 2012 15:08:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PATCH] driver core patches for 3.5-rc1 - try 2
Message-ID: <20120522220820.GA12837@kroah.com>
References: <1337723927.9270.15.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337723927.9270.15.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 02:58:47PM -0700, Joe Perches wrote:
> While there are several things I like about the
> printk modifications, (binary header, delta time,
> slightly better partial message deinterleaving,
> global msg_id, kmsg is ok too), I am concerned
> about the utility and expectations for the new
> [v]printk_emit functions.
> 
> I think it is not really ready to be merged
> at this time.
> 
> The commit sequencing was unclean.

Yes, but the build was never broken, the system always worked, and the
end result was agreed apon by everyone as a nice addition.

> The original commit originally required KERN_CONT
> and it was modified by another commit to return
> to the current behavior.
> 
> What really are the expectations and true use-cases
> for [v]printk_emit?

What's wrong with the existing use case?  Since when do we write
use-cases for kernel functions?

> How is it really better that what is available now?
> 
> Perhaps it would be better to respin all the
> printk modifications without adding [v]printk_emit
> and have the [v]printk_emit bits debated a bit more.

I'm always glad to review patches, but to just propose something that
works to be reverted without a patch to replace the functionality, isn't
ok.

thanks,

greg k-h
