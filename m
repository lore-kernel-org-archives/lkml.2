Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab1BRVbf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 16:31:35 -0500
Received: from kroah.org ([198.145.64.141]:41543 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389Ab1BRVbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 16:31:32 -0500
Date: Fri, 18 Feb 2011 13:25:42 -0800
From: Greg KH <greg@kroah.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Allow sharing xvmalloc for zram and zcache
Message-ID: <20110218212542.GI796@kroah.com>
References: <1297371646-11604-1-git-send-email-ngupta@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297371646-11604-1-git-send-email-ngupta@vflare.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 04:00:46PM -0500, Nitin Gupta wrote:
> Both zram and zcache use xvmalloc allocator. If xvmalloc
> is compiled separately for both of them, we will get linker
> error if they are both selected as "built-in". We can also
> get linker error regarding missing xvmalloc symbols if zram
> is not built.
> 
> So, we now compile xvmalloc separately and export its symbols
> which are then used by both of zram and zcache.
> 
> Signed-off-by: Nitin Gupta <ngupta@vflare.org>

This doesn't apply to my tree, care to respin it and resend?

thanks,

greg k-h
