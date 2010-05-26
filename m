Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab0EZOxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 10:53:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:45931 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754812Ab0EZOxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 10:53:14 -0400
Date: Wed, 26 May 2010 07:35:33 -0700
From: Greg KH <gregkh@suse.de>
To: David Miller <davem@davemloft.net>
Cc: ebiederm@xmission.com, error27@gmail.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [patch] kobject: free memory if netlink_kernel_create() fails
Message-ID: <20100526143533.GA5644@suse.de>
References: <20100525095110.GG22515@bicker>
 <m1d3wk2s7y.fsf@fess.ebiederm.org>
 <20100526.004347.115926528.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100526.004347.115926528.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 12:43:47AM -0700, David Miller wrote:
> From: ebiederm@xmission.com (Eric W. Biederman)
> Date: Tue, 25 May 2010 03:25:37 -0700
> 
> > Dan Carpenter <error27@gmail.com> writes:
> > 
> >> There is a kfree(ue_sk) missing on the error path if 
> >> netlink_kernel_create() fails.
> >>
> >> Signed-off-by: Dan Carpenter <error27@gmail.com>
> > Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Greg, I assume you've got this one?

Yes, I'll queue it up in a day or so.

thanks,

greg k-h
