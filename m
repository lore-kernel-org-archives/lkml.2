Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab1CCFlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 00:41:47 -0500
Received: from kroah.org ([198.145.64.141]:37385 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754302Ab1CCFlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 00:41:46 -0500
Date: Wed, 2 Mar 2011 20:06:05 -0800
From: Greg KH <greg@kroah.com>
To: pavan_savoy@ti.com
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH] drivers:misc: ti-st: fix debugging code
Message-ID: <20110303040605.GA26776@kroah.com>
References: <1299059996-21267-1-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299059996-21267-1-git-send-email-pavan_savoy@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 03:59:56AM -0600, pavan_savoy@ti.com wrote:
> From: Pavan Savoy <pavan_savoy@ti.com>
> 
> debug code in TI-ST driver can be enabled by #defining
> DEBUG in the first line of the code and in case debugfs
> is mounted, the 2 entries in /sys/kernel/debug/ti-st/ will
> also provide useful information.
> These 2 were broken because of the recent changes to the parsing
> logic and the registration mechanism of the protocol drivers,
> this patch fixes them.
> 
> Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
> ---
>  drivers/misc/ti-st/st_core.c |   18 ++++--------------
>  1 files changed, 4 insertions(+), 14 deletions(-)

What tree was this made against?  I can't seem to apply it to my
staging-next tree.

confused,

greg k-h
