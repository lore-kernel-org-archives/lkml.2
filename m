Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab1BCWUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 17:20:55 -0500
Received: from kroah.org ([198.145.64.141]:59592 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754138Ab1BCWUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 17:20:53 -0500
Date: Thu, 3 Feb 2011 14:17:42 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/3] hvc_dcc cleanups and fixes
Message-ID: <20110203221742.GA4159@kroah.com>
References: <1292649385-28771-1-git-send-email-sboyd@codeaurora.org>
 <1292875718-7980-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292875718-7980-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 12:08:35PM -0800, Stephen Boyd wrote:
> Here are the split patches.
> 
> The first two patches cleanup and fix the hvc_dcc driver for my
> compiler. The final patch is more controversial, it removes the
> v6 and v7 differences in this driver.
> 
> Stephen Boyd (3):
>   hvc_dcc: Fix bad code generation by marking assembly volatile
>   hvc_dcc: Simplify put_chars()/get_chars() loops
>   hvc_dcc: Simplify assembly for v6 and v7 ARM

Can you redo these against the linux-next tree as they don't apply
anymore and resend them so I can apply them?

thanks,

greg k-h
